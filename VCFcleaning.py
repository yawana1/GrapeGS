#!/usr/bin/env python
# encoding: utf-8
'''
GBScleaning -- Remove unwanted variants from VCF file

GBScleaning is a description

It defines classes_and_methods

@author:     Yaw Nti-Addae

@copyright:  2018 Cornell University. All rights reserved.

@license:    MIT

@contact:    user_email
@deffield    updated: 11/05/2018
'''

import sys
import os
import allel
import time
import numpy as np
import array as arr
import pandas as pd
import math

from scipy.spatial.distance import squareform
from optparse import OptionParser
from logging_utils import setup_logging_to_file, log_exception, log_info,log_warn
from Utils import saveFile
from tqdm import tqdm

__all__ = []
__version__ = 0.1
__date__ = '2018-11-05'
__updated__ = '2018-11-05'

DEBUG = 1
TESTRUN = 0
PROFILE = 0

def cleanMissing(outdir, gt, lst_variants, number_samples, threshold):
    log_info("Clean Missing (" + str(number_samples) + " :: " + str(len(lst_variants)) + ")")
    lst_new = []
    count_missing = gt.count_missing(axis=1)
    try:
        f = open(os.path.join(outdir, "freq.missing.txt"), "w")
        f.write('ID\tMissing\tSelected\n')
        for i in tqdm(range(len(lst_variants))):
            freq_missing = float(count_missing[i])/number_samples
            passed = freq_missing <= threshold
            if passed:
                lst_new.append(lst_variants[i])
            f.write(lst_variants[i]+'\t'+str(freq_missing)+'\t'+('T' if passed else 'F') +'\n')
            
        log_info('# markers :: ' + str(len(lst_new)))
        return lst_new
    except Exception as e:
        log_exception(e)
    finally:
        f.close()
        
def minCount(lst):
    if len(lst) <= 2:
        return min(lst)
    else:
        lst = list(filter(lambda a: a != 0, lst))
        if len(lst) <= 1:
            return 0
        elif len(lst) == 2:
            return min(lst)
        else:
            return -1
        
def cleanMAF(outdir, gt, lst_variants, lst_filtered_variants, number_samples, threshold):
    if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
    log_info("Clean MAF (" + str(number_samples) + " :: " + str(len(lst_filtered_variants)) + ")")
    lst_new = []
    try:
        f = open(os.path.join(outdir, "freq.maf.txt"), "w")
        f.write('ID\tMAF\n')
        freq_alleles =  gt.count_alleles().to_frequencies()
        for variant in tqdm(lst_filtered_variants):
            i = int((np.where(lst_variants == variant))[0][0])
#             allele_min = minCount(count_alleles[i])
#             allele_max = float(max(count_alleles[i]))
#             freq_maf = allele_min / (allele_min + allele_max)
            freq_maf = freq_alleles[i]
            if len(freq_maf[freq_maf != 0]) > 1:
                freq_maf = freq_maf[freq_maf != 0]
            maf = np.amin(freq_maf)
#             if allele_min == -1:
#                 f.write(lst_variants[i]+'\t\n')
#             else:
            if maf >= threshold:
                lst_new.append(lst_variants[i])
                f.write(lst_variants[i]+'\t'+str(maf)+'\n')
        log_info('# markers :: '+str(len(lst_new)))
        return lst_new
    except Exception as e:
        log_exception(e)
    finally:
        f.close()

def countAlleles(outdir, gt, lst_variants, lst_filtered_variants, number_samples):
    if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
    log_info("Allele Frequencies (" + str(number_samples) + " :: " + str(len(lst_filtered_variants)) + ")")
    lst_alleles = gt.count_alleles()
    header = []
    for i in range(len(lst_alleles[0])):
        header.append(str(i))
    df_final = pd.DataFrame(columns = [header])
    df_alleles = pd.DataFrame(columns = ["Major Index", "Minor Index"], index = lst_filtered_variants)
    log_info('# markers :: '+str(len(lst_filtered_variants)))
    for variant in tqdm(lst_filtered_variants):
        i = int((np.where(lst_variants == variant))[0][0])
        arr = np.asarray(lst_alleles[i])
        total = np.sum(arr)
        data = []
        mm = [-1,-1]
        major_val = 0;
        minor_val = 0;
        for j in range(len(arr)):
            if total == 0:
                data.append(0)
            else:
                data.append(arr[j]/total)
                val = arr[j]
                if j == 0:
                    major_val = val
                    mm[0] = j
                    minor_val = val
                    mm[1] = j
                elif val > major_val:
                    major_val = val
                    mm[0] = j
                elif val <= major_val and val > minor_val and j != mm[0]:
                    mm[1] = j
                    minor_val = val 
                elif val <= major_val and major_val == minor_val:
                    mm[1] = j
                    minor_val = val
                    
        df_final.loc[len(df_final)] = data
        df_alleles.loc[variant] = mm
    saveFile(df_final, os.path.join(outdir, "freq.alleles.txt"), index=True)
    return df_alleles
        
def cleanHet(outdir, gt, lst_variants, lst_filtered_variants, number_samples, threshold):
    if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
    log_info("Clean HET (" + str(number_samples) + " :: " + str(len(lst_filtered_variants)) + ")")
    lst_new = []
    count_missing = gt.count_missing(axis=1)
    count_het = gt.count_het(axis=1)
    try:
        f = open(os.path.join(outdir, "freq.het.txt"), "w")
        f.write('ID\tHom\tHet\n')
        for variant in tqdm(lst_filtered_variants):
            i = int((np.where(lst_variants == variant))[0][0])
            n_data = number_samples - float(count_missing[i])
            freq_het = float(count_het[i])/n_data
            freq_hom = 1 - freq_het
            if freq_het >= threshold:
                lst_new.append(lst_variants[i])
            f.write(lst_variants[i]+'\t'+str(freq_hom)+'\t'+str(freq_het)+'\n')
        log_info('# markers :: '+str(len(lst_new)))
        return lst_new
    except Exception as e:
        log_exception(e)
    finally:
        f.close()
        
def cleanLD(outdir, gt, lst_variants, lst_filtered_variants, number_samples):
    log_info("Clean LD (" + str(number_samples) + " :: " + str(len(lst_filtered_variants)) + ")")
    try:
        gn = gt.to_n_alt(fill=-1)
        r = allel.rogers_huff_r(gn)
        sqr = squareform(r ** 2)
        df_final = pd.DataFrame(data=sqr, columns=lst_variants, index=lst_variants)
        saveFile(df_final, os.path.join(outdir, "freq.ld.all.txt"), index=True)
        df_final = df_final[lst_filtered_variants]
        df_final = df_final.loc[lst_filtered_variants]
        saveFile(df_final, os.path.join(outdir, "freq.ld.txt"), index=True)
#         f = open(os.path.join(outdir, "freq.variants.ld.txt"), "w")
#         f.write('\t'+'\t'.join(lst_variants)+'\n')
# #         for i in range(len(lst_variants)):
#         for variant in lst_filtered_variants:
#             i = int((np.where(lst_variants == variant))[0][0])
#             f.write(lst_variants[i] + '\t' + '\t'.join(map(str, sqr[i])) + '\n')
    except Exception as e:
        log_exception(e)

def cleanByNumberOfAlles(outdir, gt, lst_variants, lst_filtered_variants, allele_limit = 2):
    log_info('Filber by number of alleles')
    try:
        lst_new = []
        if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
        allele_freq = gt.count_alleles().to_frequencies()
        for variant in lst_filtered_variants:
            i = int((np.where(lst_variants == variant))[0][0])
            alleles = allele_freq[i]
            nNonZeroes = np.count_nonzero(alleles)
            if nNonZeroes <= allele_limit:
                lst_new.append(lst_variants[i])
#                 removeZeros = allele_freq[i]
#                 removeZeros[removeZeros == 0] = np.nan
#                 lst_allele_freq.append(removeZeros)
#         data = pd.DataFrame(data=lst_allele_freq, index=lst_variant)
#         saveFile(pd.DataFrame(data=data), os.path.join(outdir, "allele2.frequencies.txt"), index=True)
        log_info('# markers :: '+str(len(lst_new)))
        return lst_new
    except Exception as e:
        log_warn(e)
        
def snpMatrix(outdir, callset, df_alleles, lst_filtered_variants = []):
    log_info('SNP Matrix')
    try:
        lst_ref = callset['variants/REF']
        lst_alt = callset['variants/ALT']
        lst_variants = callset['variants/ID']
        if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
        lst_samples = callset['samples']
        gt = allel.GenotypeArray(callset['calldata/GT'])
        df_codom = None
        df_maf = None
        
        log_info("# samples :: " + str(len(lst_samples)))
        log_info("# markers :: " + str(len(lst_filtered_variants)) + " ("+str(len(lst_variants))+")")
        for variant in tqdm(lst_filtered_variants):
            i = int((np.where(lst_variants == variant))[0][0])
            snp = np.insert(lst_alt[i], 0, lst_ref[i])                              # append ref to alts
            snp = np.delete(snp, np.argwhere(snp == ''))
            variant_record = gt[i].values
            mm = list(df_alleles.loc[variant])
            data_codom = pd.DataFrame(columns = [variant], index=lst_samples)
            data_maf = pd.DataFrame(columns = [variant], index=lst_samples)
            for v in range(len(variant_record)):
                alleles = variant_record[v]                
                try:
                    if -1 in alleles:
                        continue
                    elif -1 in mm:
                        continue
                    elif len(snp[alleles[0]]) > 1 or len(snp[alleles[1]]) > 1:
                        continue
                    elif '-' in snp or '+' in snp:
                        continue
                    elif alleles[0] not in mm or alleles[1] not in mm:
                        continue
                    else:
                        data_codom[variant][lst_samples[v]] = snp[alleles[0]] + snp[alleles[1]]
                        if alleles[0] != alleles[1]:
                            data_maf[variant][lst_samples[v]] = 1
                        elif alleles[0] == mm[0]:
                            data_maf[variant][lst_samples[v]] = 0
                        else:
                            data_maf[variant][lst_samples[v]] = 2
                except Exception as es:
                    log_warn(es)
            if df_codom is None:
                df_codom = data_codom
                df_maf = data_maf
            else:
                df_codom = pd.concat([df_codom, data_codom], axis=1)
                df_maf = pd.concat([df_maf, data_maf], axis=1)
        saveFile(df_codom, os.path.join(outdir, "matrix.snp.txt"), index=True)
        saveFile(df_maf, os.path.join(outdir, "matrix.maf.txt"), index=True)
        return df_maf
    except Exception as e:
        log_exception(e)

def codominantMatrix(outdir, callset, lst_filtered_variants = []):
    log_info('Codom Matrix')
    try:
        lst_ref = callset['variants/REF']
        lst_alt = callset['variants/ALT']
        lst_variants = callset['variants/ID']
        if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
#         lst_samples = callset['samples']
#         gt = allel.GenotypeArray(callset['calldata/GT'])
#         count_alleles = gt.count_alleles().to_frequencies()
#         data_variants = pd.DataFrame(data=count_alleles, index=lst_filtered_variants)
#         saveFile(data_variants, os.path.join(outdir, "allele.frequencies.txt"), index=True)
#         data_filtered = cleanByNumberOfAlles(outdir, lst_filtered_variants, count_alleles)
#         df_final = None
#         
#         log_info("# samples :: " + str(len(lst_samples)))
#         log_info("# markers :: " + str(len(lst_filtered_variants)) + " ("+str(len(data_filtered))+")")
#         for variant in data_filtered.index:
#             i = int((np.where(lst_variants == variant))[0][0])
#             snp = np.insert(lst_alt[i], 0, lst_ref[i])                              # append ref to alts
#             snp = np.delete(snp, np.argwhere(snp == ''))
#             variant_record = gt[i].values
#             data = np.zeros((len(variant_record),1), dtype=int)
#             for v in range(len(variant_record)):
#                 alleles = variant_record[v]
#                 try:
#                     if -1 in alleles:
#                         data[v] = -1
#                     elif(alleles[0] != alleles[1]):
#                         data[v] = 1
#                     else:
#                         try:
#                             freq = data_variants.loc[variant]
#                             allele_value = freq[alleles[0]]
#                             max_index = np.argmax(freq)
#                             min_index = np.argmin(freq)
#                             if allele_value == 1:
#                                 data[v] = 0
#                             elif alleles[0] == max_index and alleles[0] != min_index:
#                                 data[v] = 0
#                             elif alleles[0] == min_index and alleles[0] != max_index:
#                                 data[v] = 2
#                             else:
#                                 if alleles[0] < (len(snp)-1):
#                                     data[v] = 0
#                                 else:
#                                     data[v] = 2
#                         except Exception as es:
#                             log_warn(es)
#                 except Exception as es:
#                         log_warn(es)
#             data_df = pd.DataFrame(data=data, columns=[variant], index=lst_samples)
#             if df_final is None:
#                 df_final = data_df
#             else:
#                 df_final = pd.concat([df_final, data_df], axis=1)
#         saveFile(df_final, os.path.join(outdir, "matrix.codominant.txt"), index=True)
    except Exception as e:
        log_exception(e)

def incidenceMatrix(outdir, callset, lst_filtered_variants = []):
    log_info("Incidence Matrix")
    try:
        lst_ref = callset['variants/REF']
        lst_alt = callset['variants/ALT']
        lst_variants = callset['variants/ID']
        if(len(lst_filtered_variants) == 0):
            lst_filtered_variants = lst_variants
        lst_samples = callset['samples']
        gt = allel.GenotypeArray(callset['calldata/GT'])
        df_final = None
        
        log_info("# samples :: " + str(len(lst_samples)))
        log_info("# markers :: " + str(len(lst_filtered_variants)) + " ("+str(len(lst_variants))+")")
        for variant in tqdm(lst_filtered_variants):
            i = int((np.where(lst_variants == variant))[0][0])
            snp = np.insert(lst_alt[i], 0, lst_ref[i])                              # append ref to alts
            snp = np.delete(snp, np.argwhere(snp == ''))                            # remove empty items
            header = []
            name = lst_variants[i]
            variant_data = gt[i].values
            for j in range(len(snp)):
                header.append(name + '_' +str(j))
            data = np.zeros((len(variant_data), len(snp)), dtype=int)
            for v in range(len(variant_data)):
                alleles = variant_data[v]
                if np.all(alleles == -1):
                    data[v] = np.full(snp.shape, -1, dtype=int)
                    continue
                for a in range(len(alleles)):
                    data[v, alleles[a]] += 1
            data_df = pd.DataFrame(data=data, columns=header, index=lst_samples)    # convert ndarray to dataframe
            data_df = data_df.iloc[:, :-1]                                          # drop last column from dataframe to prevent confounding
            if df_final is None:
                df_final = data_df
            else:
                df_final = pd.concat([df_final, data_df], axis=1)
        
        saveFile(df_final, os.path.join(outdir, "matrix.incidence.txt"), index=True)
    except Exception as e:
        log_exception(e)
        
def calculateSNPsimilarity(snp_i, snp_j):
    try:
        snp_x = snp_i[snp_i != -1]
        snp_y = snp_j[snp_j != -1]
        if(len(snp_x) == 0 or len(snp_y) == 0):
            return float('NaN')
        else:
            snp_comp = np.equal(snp_x, snp_y)
            sim = len(snp_comp[snp_comp == True]) / len(snp_comp)
            return sim
    except Exception as e:
        log_warn(e)
        return float('NaN')
        
# def calculateSimilarity(lst_variant_i, lst_variant_j):
#     try:
#         lst_sim = []
#         for i in range(len(lst_variant_i)):
#             sim = calculateSNPsimilarity(lst_variant_i[i], lst_variant_j[i])
#             if not math.isnan(sim):
#                 lst_sim.append(sim)
#         np_sim = np.array(lst_sim)
#         av = np.average(np_sim)
#         return av
#     except Exception as e:
#         log_warn(e)
#         return 0
        
# def tabularMatrix(outdir, gt, lst_variants, lst_filtered_variants = [], lst_samples = []):
#     log_info("GRM Matrix using Tabular method")
#     try:
#         num_samples = len(lst_samples)
#         data_filler = np.zeros(shape=(num_samples,num_samples), dtype=float)
#         grm = pd.DataFrame(data_filler,columns=lst_samples, index=lst_samples)
#         lst_index = []
#         if(len(lst_filtered_variants) > 0):
#             for variant in lst_filtered_variants:
#                 i = int((np.where(lst_variants == variant))[0][0])
#                 lst_index.append(i)
#             gt = gt[lst_index,:]
#         for i in range(num_samples):
#             log_info("Builing "+str(i)+" out of "+str(num_samples))
#             try:
#                 sample_i = lst_samples[i]
#                 lst_variant_i = gt[:,i]
#                 for j in range(i, num_samples):
#                     sample_j = lst_samples[j]
#                     lst_variant_j = gt[:,j]
#                     similarity = calculateSimilarity(lst_variant_i, lst_variant_j)
#                     if sample_i == sample_j:
#                         grm.loc[sample_i, sample_i] =  similarity
# #                         grm[sample_i, sample_j] = similarity
#                     else:
#                         grm.loc[sample_i, sample_j] =  similarity
#                         grm.loc[sample_j, sample_i] =  similarity
# #                         grm[sample_i, sample_j] = similarity
# #                         grm[sample_j, sample_i] = similarity
#             except Exception as e:
#                 log_warn(e)
#         saveFile(grm, os.path.join(outdir, "grm.tabular.txt"), index=True)
#     except Exception as e:
#         log_exception(e) 

def calculateSimilarity(lst_variant_i, lst_variant_j):
    try:
        sim = 0.0
        total = 0.0
        for i in tqdm(range(len(lst_variant_i))):
            if math.isnan(lst_variant_i[i]) and math.isnan(lst_variant_j[i]):
                continue
            elif math.isnan(lst_variant_i[i]) or math.isnan(lst_variant_j[i]):
                total += 1
                continue
            elif lst_variant_i[i] == lst_variant_j[i]:
                sim += 1
                total += 1
            else:
                total += 1
                
        if total == 0:
            return 0
        else:
            return sim/total
    except Exception as e:
        log_warn(e)
        return 0
        
def tabularMatrix2(outdir, df_maf):
    log_info("GRM Matrix using Tabular method")
    try:
        lst_samples = list(df_maf.index.values)
        num_samples = len(lst_samples)
        data_filler = np.zeros(shape=(num_samples,num_samples), dtype=float)
        grm = pd.DataFrame(data_filler,columns=lst_samples, index=lst_samples)
        for i in tqdm(range(num_samples)):
#             log_info("Builing "+str(i)+" out of "+str(num_samples))
            try:
                sample_i = lst_samples[i]
                lst_variant_i = list(df_maf.loc[sample_i])
                for j in range(i, num_samples):
                    sample_j = lst_samples[j]
                    lst_variant_j = list(df_maf.loc[sample_j])
                    similarity = calculateSimilarity(lst_variant_i, lst_variant_j)
                    if sample_i == sample_j:
                        grm.loc[sample_i, sample_i] =  similarity
                    else:
                        grm.loc[sample_i, sample_j] =  similarity
                        grm.loc[sample_j, sample_i] =  similarity
            except Exception as e:
                log_warn(e)
        saveFile(grm, os.path.join(outdir, "grm.tabular.txt"), index=True)
    except Exception as e:
        log_exception(e)       
                
def statistics(infile, outdir):
    try:
        callset = allel.read_vcf(infile)
    except Exception as e:
        log_exception(e)
    lst_variants = callset['variants/ID']
    lst_samples = callset['samples']
    gt = allel.GenotypeArray(callset['calldata/GT'])
    
    try:
        log_info("Observed Frequencies")
        ho = allel.heterozygosity_observed(gt)
        df_ho = pd.DataFrame(list(zip(lst_variants, ho)), columns=['Variant', 'Observed_freq'])
        saveFile(df_ho, os.path.join(outdir, "freq.observed.txt"), index=False)
        
#         log_info("Expected Frequencies")
#         he = allel.heterozygosity_expected(gt, ploidy=2)
#         df_he = pd.DataFrame(list(zip(lst_variants, he)), columns=['Variant', 'Expected_freq'])
#         saveFile(df_he, os.path.join(outdir, "freq.expected.txt"), index=False)
        
        log_info('Inbreeding Coefficient')
        ic = allel.inbreeding_coefficient(gt)
        df_ic = pd.DataFrame(list(zip(lst_variants, ic)), columns=['Variant', 'Inbreeding_coeff'])
        saveFile(df_ic, os.path.join(outdir, "freq.coeff.txt"), index=False)
    except Exception as e:
        log_exception(e)
    
def cleanVariants(infile, outdir, missingThreshold, mafThreshold, hetThreshold, alleleThreshold, phasedData = False):
    log_info("Start cleaning")
    log_info("Load data file")
    try:
        callset = allel.read_vcf(infile)
    except Exception as e:
        log_exception(e)
    
    log_info("Read genotypes")
#     lst_filtered_variants = []
    lst_samples = callset['samples']
    n_samples = len(lst_samples)
    with open(os.path.join(outdir, 'samples.txt'), 'w') as f:
        for item in lst_samples:
            f.write("%s\n" % item)
    
    lst_variants = callset['variants/ID']
#     lst_chrom = list(zip(callset['variants/CHROM'], callset['variants/ID']))
#     data_chrom = pd.DataFrame(lst_chrom, columns=['Chrom', 'Variant'])
    gt = allel.GenotypeArray(callset['calldata/GT'])
     
    lst_filtered_variants = []
     
#     if filterMissing:
    lst_filtered_variants = cleanMissing(outdir, gt, lst_variants, n_samples, missingThreshold)
#     if filterAlleles:
#     lst_filtered_variants = cleanByNumberOfAlles(outdir, gt, lst_variants, lst_filtered_variants, alleleThreshold)
#     if filterMAF:
    lst_filtered_variants = cleanMAF(outdir, gt, lst_variants, lst_filtered_variants, n_samples, mafThreshold)
#     if filterHet:
    lst_filtered_variants = cleanHet(outdir, gt, lst_variants, lst_filtered_variants, n_samples, hetThreshold)
#     cleanLD(outdir, gt, lst_variants, lst_filtered_variants, n_samples)
 
    df_alleles = countAlleles(outdir, gt, lst_variants, lst_filtered_variants, n_samples)
    incidenceMatrix(outdir, callset, lst_filtered_variants)
#     codominantMatrix(outdir, callset, [])
    df_maf = snpMatrix(outdir, callset, df_alleles, lst_filtered_variants);
 
#     tabularMatrix2(outdir,df_maf)

    log_info("End cleaning")

def main(argv=None):
    '''Command line options.'''

    program_name = os.path.basename(sys.argv[0])
    program_version = "v0.1"
    program_build_date = "%s" % __updated__

    program_version_string = '%%prog %s (%s)' % (program_version, program_build_date)
    #program_usage = '''usage: spam two eggs''' # optional - will be autogenerated by optparse
    program_longdesc = '''''' # optional - give further explanation about what the program does
    program_license = "Copyright 2018 user_name (organization_name)                                            \
                Licensed under the Apache License 2.0\nhttp://www.apache.org/licenses/LICENSE-2.0"

    if argv is None:
        argv = sys.argv[1:]
    try:
        # setup option parser
        parser = OptionParser(version=program_version_string, epilog=program_longdesc, description=program_license)
        parser.add_option("-i", "--in", dest="infile", help="set input path VCF file [default: %default]", metavar="FILE")
        parser.add_option("-o", "--out", dest="outdir", help="set output path [default: %default]", metavar="FILE")
        parser.add_option("-m", "--missing", dest="missingThreshold", help="Threshold for missing data", default=0.25)
        parser.add_option("-f", "--maf", dest="mafThreshold", help="Threshold for minor allele frequency", default=0.20)
        parser.add_option("-t", "--het", dest="hetThreshold", help="Threshold for heterozygosity", default=0.00)
        parser.add_option("-a", "--allele", dest="alleleThreshold", help="Threshold for # alleles", default=2)
        parser.add_option("-v", "--verbose", dest="verbose", action="count", help="set verbosity level [default: %default]")
        parser.add_option("-r", action="store_true", dest="rQTL", default=False)
#         parser.add_option("-v", "--verbose", dest="verbose", action="count", help="set verbosity level [default: %default]")
#         parser.add_option("-a", action="store_true", dest="filterMAF", default=False)
#         parser.add_option("-e", action="store_true", dest="filterHet", default=False)
#         parser.add_option("-p", action="store_true", dest="filterAlleles", default=False)
        

        # set defaults
        parser.set_defaults(outdir="./out.txt", infile="./in.txt")

        # process options
        (opts, args) = parser.parse_args(argv)

#         if opts.verbose > 0:
#             print("verbosity level = %d" % opts.verbose)
#         if opts.infile:
#             print("infile = %s" % opts.infile)
#         if opts.outdir:
#             print("outdir = %s" % opts.outdir)

        # MAIN BODY #
        if not os.path.exists(opts.outdir):
            os.makedirs(opts.outdir)
        log_file = os.path.join(opts.outdir, 'log.'+ time.strftime("%Y-%m-%d") + '.txt')
        setup_logging_to_file(log_file, opts.verbose)
        missingThreshold = float(opts.missingThreshold)
        mafThreshold = float(opts.mafThreshold)
        hetThreshold = float(opts.hetThreshold)
        alleleThreshold = float(opts.alleleThreshold)
#         statistics(opts.infile, opts.outdir)
        cleanVariants(opts.infile, opts.outdir, missingThreshold, mafThreshold, hetThreshold, alleleThreshold, opts.rQTL)
        
        log_info("Exit program")

    except Exception as e:
        indent = len(program_name) * " "
        sys.stderr.write(program_name + ": " + repr(e) + "\n")
        sys.stderr.write(indent + "  for help use --help")
        return 2


if __name__ == "__main__":
#     if DEBUG:
#         sys.argv.append("-h")
    if TESTRUN:
        import doctest
        doctest.testmod()
    if PROFILE:
        import cProfile
        import pstats
        profile_filename = 'GBScleaning_profile.txt'
        cProfile.run('main()', profile_filename)
        statsfile = open("profile_stats.txt", "wb")
        p = pstats.Stats(profile_filename, stream=statsfile)
        stats = p.strip_dirs().sort_stats('cumulative')
        stats.print_stats()
        statsfile.close()
        sys.exit(0)
    sys.exit(main())
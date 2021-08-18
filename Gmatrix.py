#!/usr/bin/env python
# encoding: utf-8
'''
asreml.Gmatrix -- shortdesc

asreml.Gmatrix is a description

It defines classes_and_methods

@author:     user_name

@copyright:  2020 organization_name. All rights reserved.

@license:    license

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os
import time
import numpy as np
import array as arr
import pandas as pd
import Utils

from optparse import OptionParser
from logging_utils import setup_logging_to_file, log_exception, log_info,log_warn

__all__ = []
__version__ = 0.1
__date__ = '2020-06-02'
__updated__ = '2020-06-02'

DEBUG = 1
TESTRUN = 0
PROFILE = 0

def getMAFvalue(arr, idx):
    if arr == [0,0]:
        return 0 if idx == 1 else 2
    elif arr == [1,1]:
        return 2 if idx == 1 else 0
    elif arr == [0,1] or arr == [1,0]:
        return 1
    else:
        return ''

def mafMatrix(infile, outdir, df):
    log_info('MAF Matrix')
    
    log_info('Calculate frequencies')
    df_freq = pd.DataFrame(columns=['0', '1'], index=df.index)
    try:
        for index, row in df.iterrows():
            freq = [0,0]
            count = 0            
            for val in row.values:
                count_0 = np.count_nonzero(np.asarray(val, dtype='i1') == 0)
                count_1 = np.count_nonzero(np.asarray(val, dtype='i1') == 1)
                count_neg = np.count_nonzero(np.asarray(val, dtype='i1') == -1)
                if count_neg > 0:
                    continue
                else:
                    freq[0] += count_0
                    freq[1] += count_1
                    count += 2
            df_freq.loc[index] = [freq[0]/count, freq[1]/count]
#         gt_freq = gt.count_alleles().to_frequencies()
        log_info('Write frequencies')
        Utils.saveFile(df_freq, os.path.join(outdir, "freq.alleles.txt"), index=True)
    except Exception as e:
        log_warn(e)
        
    log_info('Construct MAF matrix')
    try:
        vector_maf = pd.DataFrame(columns=['MAF'], index=df.index)
        for index, row in df.iterrows():
            arr = df_freq.loc[index].values
            idx = np.argmin(arr)
#             idx = np.where(arr == np.amin(arr))
            vector_maf.loc[index] = arr[idx]
            df.loc[index] = df.loc[index].apply(lambda x: getMAFvalue(x, idx))
        
        log_info('Write MAF matrix')
        df = df.transpose()
        Utils.saveFile(df, os.path.join(outdir, "matrix.maf.txt"), index=True)
        
        log_info('Write MAF frequencies')
        df_maf = pd.DataFrame(columns=df.columns, index=df.index)
        for index, row in df.iterrows():
            df_maf.loc[index] = list(vector_maf['MAF'].values)
        Utils.saveFile(vector_maf, os.path.join(outdir, "freq.maf.txt"), index=True)
        Utils.saveFile(df_maf, os.path.join(outdir, "matrix.P.txt"), index=True)
        
        log_info("End MAF")
        return df
    except Exception as e:
        log_warn(e)

def codeGenotype(code):
    try:
        if code == 1:
            return [0, 0]
        elif code == 2:
            return [0, 1]
        elif code == 3:
            return [1, 0]
        elif code == 4:
            return [1, 1]
        else:
            return [-1,-1]
    except Exception as e:
        log_warn(e)
        
def loadrQTL(infile):
    log_info('Load rQTL')
    files = infile.split(',')
    try:
        df_final = None
        for f in files:
            df = Utils.loadFile(f)
            df = df.set_index('ID', drop=True)
            df = df.iloc[4:]   
            df = df.astype(dtype='int32')
            df = df.applymap(lambda x: codeGenotype(x))
            df = df.transpose()
            if df_final is None:
                df_final = df
            else:
                df_final = pd.concat([df_final, df], axis=1, sort=False)
        
        return df_final
    except Exception as e:
        log_exception(e)

def calculateSimilarity(lst0, lst1):
    try:
        count = 0
        for i in range(len(lst0)):
            count += 1 if lst0[i] == lst1[i] else 0
        return count / len(lst0)
    except Exception as e:
        log_warn(e)
        return 0

def tabulate(df_maf, outdir):
    log_info('Construct Relationship Matrix using Tabulation method')
    df_grm = pd.DataFrame(columns=df_maf.index, index=df_maf.index)
    try:
        for i in range(len(df_maf.index)):
            lst_i = df_maf.iloc[i].to_list();
            for j in range(i, len(df_maf.index)):
                lst_j = df_maf.iloc[j].to_list()
                rel = calculateSimilarity(lst_i, lst_j)
                df_grm.iloc[i, j] = rel
                df_grm.iloc[j, i] = rel 
        Utils.saveFile(df_grm, os.path.join(outdir, "grm.tabular.txt"), index=True)
        log_info('End Relationship Matrix')
    except Exception as e:
        log_warn(e)

def main(argv=None):
    '''Command line options.'''

    program_name = os.path.basename(sys.argv[0])
    program_version = "v0.1"
    program_build_date = "%s" % __updated__

    program_version_string = '%%prog %s (%s)' % (program_version, program_build_date)
    #program_usage = '''usage: spam two eggs''' # optional - will be autogenerated by optparse
    program_longdesc = '''''' # optional - give further explanation about what the program does
    program_license = "Copyright 2020 user_name (organization_name)                                            \
                Licensed under the Apache License 2.0\nhttp://www.apache.org/licenses/LICENSE-2.0"

    if argv is None:
        argv = sys.argv[1:]
    try:
        # setup option parser
        parser = OptionParser(version=program_version_string, epilog=program_longdesc, description=program_license)
        parser.add_option("-i", "--in", dest="infile", help="set input path [default: %default]", metavar="FILE")
        parser.add_option("-o", "--out", dest="outdir", help="set output path [default: %default]", metavar="FILE")

        # set defaults
        parser.set_defaults(outfile="./out.txt", infile="./in.txt")

        # process options
        (opts, args) = parser.parse_args(argv)

        # MAIN BODY #
        if not os.path.exists(opts.outdir):
            os.makedirs(opts.outdir)
        log_file = os.path.join(opts.outdir, 'log.'+ time.strftime("%Y-%m-%d") + '.txt')
        setup_logging_to_file(log_file)
        
#         test_data = pd.DataFrame([[[0, 0], [1, 1], [0, 0]],
#                                   [[0, 0], [1, 1], [0, 0]],
#                                   [[1, 1], [0, 0], [1, 1]],
#                                   [[0, 0], [0, 1], [-1, -1]]])
#         test_gt = allel.GenotypeArray([[[0, 0], [1, 1], [0, 0]],
#                                   [[0, 0], [1, 1], [0, 0]],
#                                   [[1, 1], [0, 0], [1, 1]],
#                                   [[0, 0], [0, 1], [-1, -1]]], dtype='i1')
        df = loadrQTL(opts.infile);
        matrix_maf = mafMatrix(opts.infile, opts.outdir, df)
        tabulate(matrix_maf, opts.outdir)
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
        profile_filename = 'asreml.Gmatrix_profile.txt'
        cProfile.run('main()', profile_filename)
        statsfile = open("profile_stats.txt", "wb")
        p = pstats.Stats(profile_filename, stream=statsfile)
        stats = p.strip_dirs().sort_stats('cumulative')
        stats.print_stats()
        statsfile.close()
        sys.exit(0)
    sys.exit(main())
#!/usr/bin/env python
# encoding: utf-8
'''
asreml.GRMgenerator -- shortdesc

asreml.GRMgenerator is a description

It defines classes_and_methods

@author:     Yaw Nti-Addae

@copyright:  2020 Cornell University. All rights reserved.

@license:    MIT

@contact:    user_email
@deffield    updated: Updated
'''

import sys
import os
import time

from optparse import OptionParser
from logging_utils import setup_logging_to_file, log_exception, log_info, log_warn
from gsUtils import Utils

__all__ = []
__version__ = 0.1
__date__ = '2020-04-07'
__updated__ = '2020-04-07'

DEBUG = 1
TESTRUN = 0
PROFILE = 0

def main(argv=None):
    '''Command line options.'''

    program_name = os.path.basename(sys.argv[0])
    program_version = "v0.1"
    program_build_date = "%s" % __updated__

    program_version_string = '%%prog %s (%s)' % (program_version, program_build_date)
    #program_usage = '''usage: spam two eggs''' # optional - will be autogenerated by optparse
    program_longdesc = '''''' # optional - give further explanation about what the program does
    program_license = "Copyright 2020 Yaw Nti-Addae (Cornell University)                                            \
                Licensed under the Apache License 2.0\nhttp://www.apache.org/licenses/LICENSE-2.0"

    if argv is None:
        argv = sys.argv[1:]
    try:
        # setup option parser
        parser = OptionParser(version=program_version_string, epilog=program_longdesc, description=program_license)
        parser.add_option("-p", "--pheno", dest="phenofile", help="set input phenotype file path [default: %default]", metavar="FILE")
        parser.add_option("-g", "--geno", dest="genofile", help="set input genotype file path [default: %default]", metavar="FILE")
        parser.add_option("-o", "--out", dest="outdir", help="set output path [default: %default]", metavar="FILE")

        # set defaults
        parser.set_defaults(outfile="./out.txt", infile="./in.txt")

        # process options
        (opts, args) = parser.parse_args(argv)


        # MAIN BODY #
        
        # set log file
        if not os.path.exists(opts.outdir):
            os.makedirs(opts.outdir)
        log_file = os.path.join(opts.outdir, 'log.'+ time.strftime("%Y-%m-%d") + '.txt')
        setup_logging_to_file(log_file)

        log_info('load phenotype and genotype datasets')
        datasetPhenotype = Utils.loadFile(opts.phenofile)
        datasetGenotype = Utils.loadFile(opts.genofile)
        
        ids = list(datasetPhenotype['Genotype'])
        genoIds = list(datasetGenotype['Genotype'])
        processedIds = {}
        genotypeFilename = os.path.join(opts.outdir, 'matrix.grm')
        phenotypeFilename = os.path.join(opts.outdir, 'phenotype.asd')
        genotypeColumn = datasetPhenotype['Genotype']
        
        log_info('Read lower half of genotype matrix and write to file')
        outFile = open(genotypeFilename, 'w+')
        counter = 0;
        for i in range(len(ids)):
            if ids[i] in processedIds:
                continue
            
            counter += 1
            idx = ids[i]
            processedIds[idx] = str(counter)
            genotypeColumn = genotypeColumn.replace(idx, processedIds[idx])
            if not idx in genoIds:
#                 record = str(processedIds[idx]) + ' ' + str(processedIds[idx]) + ' 1' 
                record = ' '.join([processedIds[idx], processedIds[idx], '1'])
                outFile.write(record + '\n')
            else:
                for j in range(0, i+1):
                    idy = ids[j]
                    if not idy in genoIds:
                        continue
                    try:
                        cov = datasetGenotype.loc[datasetGenotype['Genotype'] == idx, idy].values[0]
#                         record = str(processedIds[idx]) + ' ' + str(processedIds[idy]) + ' ' + str(cov)
                        record = ' '.join([processedIds[idx], processedIds[idy], cov])
                        outFile.write(record + '\n')
                    except Exception as es:
                        log_warn(es)
#             processedIds.append(ids[i])
        outFile.close()
        datasetPhenotype['Genotype'] = genotypeColumn
        datasetPhenotype = datasetPhenotype.replace('', 'NA', regex=True)
        Utils.saveFile(datasetPhenotype, phenotypeFilename)
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
        profile_filename = 'asreml.GRMgenerator_profile.txt'
        cProfile.run('main()', profile_filename)
        statsfile = open("profile_stats.txt", "wb")
        p = pstats.Stats(profile_filename, stream=statsfile)
        stats = p.strip_dirs().sort_stats('cumulative')
        stats.print_stats()
        statsfile.close()
        sys.exit(0)
    sys.exit(main())
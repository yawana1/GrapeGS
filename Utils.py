'''
Created on Apr 8, 2020

@author: yn259
'''

import pandas as pd
import numpy as np
from logging_utils import log_exception, log_info, log_warn

def loadFile(filename):
    """
    ** Function loadFile** loads the content of a file into a python dataframe
    
    Allowed file formats are TXT (.txt), CSV (.csv), and Excel (.xls or xlsx)
    
    **parameters**:
    >*filename: name of file to load
    
    **return
    >dataframe
    
    **exception**
    >write error to log file and quit application
    """
    try:
        if filename.endswith('.csv') or filename.endswith('.txt'):
            with open(filename, 'r') as f:
                header = f.readline()
                if '\t' in header:
                    data = pd.read_csv(filename, sep='\t', dtype='str', na_values='NA')
                else:
                    data = pd.read_csv(filename, na_values='NA')
                del header
            f.close()
        elif filename.endswith('.xlsx') or filename.endswith('.xls'):
            data = pd.read_excel(filename, sheet_name=0, na_values='NA')
        return data.replace(np.nan, '', regex=True)
    except Exception as e:
        log_exception('Error opening file %s' %filename)
        log_exception(e)
        return 2
    
def saveFile(data, filename, index=False, header=True):
    """
    **Function saveFile** saves a dataframe to file with specified filename.
    
    The file format used is based on the extension of the specified filename.
    >CSV - comma separated values (.csv)
    
    >TXT - tab delimited values (.txt)
    
    >XLSX - MS Excel format (.xlsx or xls)
    """
    try:
#         if filename.endswith('.csv'):
#             data.to_csv(filename, index=None, sep=',', na_rep='', mode='w', line_terminator='\n')
#         elif filename.endswith('.txt'):
#             data.to_csv(filename, index=None, sep='\t', na_rep='', mode='w', line_terminator='\n')
#         elif filename.endswith('.xlsx') or filename.endswith('.xls'):
#             data.to_excel(filename, index=None, sep='\t', na_rep='', mode='w', line_terminator='\n')
#         else:
#             data.to_csv(filename, index=None, sep='\t', na_rep='', mode='w', line_terminator='\n')
        if filename.endswith('.csv'):
            data.to_csv(filename, index=index, header=header, sep=',', na_rep='', mode='w', line_terminator='\n')
        elif filename.endswith('.txt') :
            data.to_csv(filename, index=index, header=header, sep='\t', na_rep='', mode='w', line_terminator='\n')
        elif filename.endswith('.xlsx') or filename.endswith('.xls') :
            data.to_excel(filename, index=index, header=header, sep='\t', na_rep='', mode='w', line_terminator='\n')
        else:
            data.to_csv(filename, index=index, header=header, sep='\t', na_rep='NA', mode='w', line_terminator='\n')
    except Exception as e:
        log_exception('Error saving file %s' %filename)
        log_exception(e)
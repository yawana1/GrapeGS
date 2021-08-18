'''
Created on Jun 29, 2017

@author: Alex Martelli
'''

import sys
import traceback
import logging

_verbose = False

def setup_logging_to_file(filename, verbose = False):
    if verbose:
        logging.basicConfig( filename=filename,
                             filemode='w',
                             level=logging.DEBUG,
                             format= '%(asctime)s - %(levelname)s - %(message)s',
                           )
    else:
        logging.basicConfig( filename=filename,
                             filemode='w',
                             level=logging.ERROR,
                             format= '%(asctime)s - %(levelname)s - %(message)s',
                           )
    _verbose = verbose

def extract_function_name():
    """
        Extracts failing function name from Traceback
        by Alex Martelli
        http://stackoverflow.com/questions/2380073/\how-to-identify-what-function-call-raise-an-exception-in-python
    """
    tb = sys.exc_info()[-1]
    stk = traceback.extract_tb(tb, 1)
    fname = stk[0][3]
    return fname

def log_exception(e):
    logging.error(
    "Function {function_name} raised {exception_class} ({exception_docstring}): {exception_message}".format(
    function_name = extract_function_name(), #this is optional
    exception_class = e.__class__,
    exception_docstring = e.__doc__,
    exception_message = e.message))
    
def log_info(msg):
    logging.info(msg)
    print (msg)

def log_warn(msg):
    logging.warn(msg)
    print (msg)
    
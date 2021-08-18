'''
Created on Jun 1, 2020

@author: yaw
'''

import allel
import pandas as pd
from utils import Utils

class rQTL:
    '''
    classdocs
    '''


    def __init__(self, infile):
        '''
        Constructor
        '''
        self.df = Utils.loadFile(infile)
        self.df = self.df.transpose()
        self.chrom = self.df[['Chr']].to_numpy()
        self.df.drop([1,2,3])
        
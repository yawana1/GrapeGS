'''
Created on Oct 8, 2020

@author: yn259
'''

import pandas as pd
import os
from gsUtils import Utils

p1 = '/media/yn259/data/research/HI/phenos/FruitQuality.csv'
p2 = '/media/yn259/data/research/HR/phenos/FruitQuality.csv'
outdir = '/media/yn259/data/research/HIR/phenos/'

df1 = Utils.loadFile(p1)
df2 = Utils.loadFile(p2)

for row in range(len(df2)):
    df2.iloc[row, 0] = 'X'+ str(df2.iloc[row, 0])
df = pd.concat([df1, df2], axis=0, sort=False)

# print(df)

Utils.saveFile(df, os.path.join(outdir, "FruitQuality.csv"), index=False)
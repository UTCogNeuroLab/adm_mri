import os
import numpy as np
import pandas as pd

for file in os.listdir(os.getcwd()):
    ts = pd.read_csv(file, delimiter = ' ', header = None)
    fname = os.path.basename(file).split('.')[0]
    ts.to_excel(fname + '.xlsx', index = False, header = None)

import pandas as pd

## VIASH START
par = {
    "input": "data/file1.tsv",
    "column": 2,
    "output": "temp/foo"
}
## VIASH END

# read the tsv file
tab = pd.read_csv(par["input"], sep="\t", comment="#")

# subset a column
tab_filt = tab.iloc[:, par["column"]-1]

# write to file
tab_filt.to_csv(par["output"], index=False)

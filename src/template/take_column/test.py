import pandas as pd
import subprocess

print("Generating test data", flush=True)

df = pd.DataFrame({
  "a": [1, 2, 3],
  "b": [4, 5, 6],
  "c": ["a", "b", "c"],
  "d": [True, False, True]
})

df.to_csv("file.tsv", sep="\t", index=False, header=False)

print(f"Running {meta['name']}", flush=True)

cmd = [
  meta["executable"],
  "--input",
  "file.tsv",
  "--column",
  "2",
  "--output",
  "foo.tsv"
]
subprocess.run(cmd, check=True)

print("Checking results", flush=True)
table = pd.read_csv("foo.tsv", header=None, sep="\t")

expected_table = pd.DataFrame({
  0: [4, 5, 6]
})

assert table.equals(expected_table), "Output table does not match expected table"
print("Test successful", flush=True)

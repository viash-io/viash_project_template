#!/usr/bin/env bash

echo "Generate test tsv content"

echo ">>> Running tests with only comments"

cat > file1.tsv <<EOF
# This
#file
#  only
# contains comments
EOF

./$meta_functionality_name -i file1.tsv -o output1.tsv

[[ ! -f output1.tsv ]] && echo "It seems no output is generated" && exit 1
[[ ! `sed -n '$=' output1.tsv` == "" ]] && echo "All lines should be filtered out" && exit 1

echo ">>> Running tests with no comments"

cat > file2.tsv <<EOF
This file contains
no comments no
EOF

./$meta_functionality_name -i file2.tsv -o output2.tsv

[[ ! -f output2.tsv ]] && echo "It seems no output is generated" && exit 1
[[ ! `sed -n '$=' output2.tsv` == 2 ]] && echo "No lines should be filtered out" && exit 1

echo ">>> Running tests mixed"

cat > file3.tsv <<EOF
# This file contains
no comments no
EOF

./$meta_functionality_name -i file3.tsv -o output3.tsv

[[ ! -f output3.tsv ]] && echo "It seems no output is generated" && exit 1
[[ ! `sed -n '$=' output3.tsv` == 1 ]] && echo "No lines should be filtered out" && exit 1

echo ">>> Test finished successfully"

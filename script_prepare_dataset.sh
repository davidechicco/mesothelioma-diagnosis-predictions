#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o pipefail -o errexit
set -o nounset
set -o xtrace

mkdir -p models

curl -O 'https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx'

mv Mesothelioma%20data%20set.xlsx Mesothelioma_data_set.xlsx

Rscript arrange_mesothelioma_dataset.r Mesothelioma_data_set.xlsx 

echo "The normalized dataset file Mesothelioma_data_set_COL_NORM.csv is ready now"    


#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#
set -o nounset -o pipefail -o errexit
set -o xtrace

iteTot=10

i=1
outputFile=""

random_numberA=$(shuf -i1-100000 -n1)
method="perceptron"

mkdir -p "results"
subdir="./results/"$method"FIXED_rand"$random_numberA"/"
mkdir -p $subdir

for i in $( seq 1 $iteTot )
do

  echo $i
  today=`date +%Y-%m-%d`
  random_numberB=$(shuf -i1-100000 -n1)
  jobName=$method"_"$today"_rand"$random_numberB
  outputFile=$subdir$jobName
  
  qsub -q all.q -N "-"$jobName -cwd -b y -o $outputFile -e $outputFile th mesothelioma_ann_script_NEW.lua > $outputFile 2> $outputFile
  
done

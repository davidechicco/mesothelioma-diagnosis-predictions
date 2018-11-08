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
method="oneR"
percPos=38
percTrain=70
subdir="./results/"$method"_"$percPos"percPos_"$percTrain"percTrain_rand"$random_numberA"/"
mkdir -p $subdir

for i in $( seq 1 $iteTot )
do

  echo $i
  today=`date +%Y-%m-%d`
  random_numberB=$(shuf -i1-100000 -n1)
  jobName=$method"_"$today"_rand"$random_numberB
  outputFile=$subdir$jobName
  /usr/bin/Rscript oner_class_v2.r $percPos $percTrain > $outputFile 2> $outputFile
done

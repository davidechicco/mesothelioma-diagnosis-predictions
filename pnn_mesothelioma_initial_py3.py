#!/usr/bin/env python3.5

import numpy as np
from sklearn import datasets
from sklearn.metrics import matthews_corrcoef
from sklearn.cross_validation import StratifiedKFold
from sklearn.metrics import accuracy_score

from neupy.algorithms import PNN
import time
start = time.time()

fileName="../data/MesotheliomaDataSet_original_COL_NORM_34features.csv"
TARGET_COLUMN=34

# fileName="./MesotheliomaDataSet_DicleUniversity_NORMALIZED_withoutDiagnosisMethod.csv"
# TARGET_COLUMN=34



from numpy import genfromtxt
mesothelioma_data = genfromtxt(fileName, delimiter=',', skip_header=1, usecols=(list(range(0, TARGET_COLUMN-1))))
#print(mesothelioma_data)
mesothelioma_target = genfromtxt(fileName, delimiter=',', skip_header=1, usecols=(TARGET_COLUMN-1))
#print(mesothelioma_target)

#print(data)

#dataset = datasets.load_iris()
#data = dataset.data
#target = dataset.target

#mesothelioma_data = data
#mesothelioma_target = target

# kfold_number = 5 # ORIGINAL

kfold_number = 5
skfold = StratifiedKFold(mesothelioma_target, kfold_number, shuffle=True)
avarage_result = 0

accu_sum = 0
mcc_sum = 0

print("> Start classify mesothelioma dataset")

for i, (train, test) in enumerate(skfold, start=1):
    x_train, x_test = mesothelioma_data[train], mesothelioma_data[test]
    y_train, y_test = mesothelioma_target[train], mesothelioma_target[test]

    pnn_network = PNN(std=0.1, step=0.2,  verbose=True) # BEST
    #pnn_network = PNN(std=0.1, step=0.2,  verbose=True, batch_size=20)
    
    # pnn_network.train(x_train, y_train)
    # predictions = pnn_network.predict(x_test)
    pnn_network.train(mesothelioma_data[train], mesothelioma_target[train])
    predictions = pnn_network.predict(mesothelioma_data[test])
    
    # print(predictions)
    #print(mesothelioma_target[test])
    
    mcc = matthews_corrcoef(mesothelioma_target[test], predictions)
    print(("The Matthews correlation coefficient is %.2f" % mcc))
    
    accu = accuracy_score(mesothelioma_target[test], predictions)
    print(("The accuracy is %.2f" % accu))
    accu_sum = accu_sum + accu
    mcc_sum = mcc_sum + mcc

    print(("kfold #{:<2}: Guessed {} out of {}".format(
        i, np.sum(predictions == mesothelioma_target[test]), test.size
    )))

mcc_average = mcc_sum/kfold_number
accu_average = accu_sum/kfold_number

print(("\n>>> The average MCC is %.3f" % mcc_average))
print((">>> The average accuracy is %.3f\n" % accu_average))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print(("{:0>2} hours {:0>2} minutes {:05.2f} seconds".format(int(hours),int(minutes),seconds)))

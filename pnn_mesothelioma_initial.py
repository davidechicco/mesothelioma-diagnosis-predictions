from __future__ import division
import numpy as np
from sklearn import datasets
from sklearn.metrics import matthews_corrcoef
from sklearn.cross_validation import StratifiedKFold
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score

from neupy.algorithms import PNN
import time
start = time.time()


def median(lst):
    n = len(lst)
    if n < 1:
            return None
    if n % 2 == 1:
            return sorted(lst)[n//2]
    else:
            return sum(sorted(lst)[n//2-1:n//2+1])/2.0

fileName="./Mesothelioma_data_set_COL_NORM.csv"
TARGET_COLUMN=34

# fileName="./MesotheliomaDataSet_DicleUniversity_NORMALIZED_withoutDiagnosisMethod.csv"
# TARGET_COLUMN=34



from numpy import genfromtxt
mesothelioma_data = genfromtxt(fileName, delimiter=',', skip_header=1, usecols=(range(0, TARGET_COLUMN-1)))
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

vectMCC = []
vectAcc = []
vectSpec = []
vectSens = []
vectF1 = []

kfold_number = 10
skfold = StratifiedKFold(mesothelioma_target, kfold_number, shuffle=True)
avarage_result = 0

accu_sum = 0
mcc_sum = 0
specificity_sum = 0
thisF1_sum = 0
sensitivity_sum = 0

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
      
    tn, fp, fn, tp = confusion_matrix(mesothelioma_target[test], predictions).ravel()
    print("tn, fp, fn, tp")
    print(tn, fp, fn, tp, )
    
    mcc = matthews_corrcoef(mesothelioma_target[test], predictions)
    print("The Matthews correlation coefficient is %.2f" % mcc)
   
    
    accu = accuracy_score(mesothelioma_target[test], predictions)
    print("The accuracy is %.2f" % accu)
    
    sensitivity = recall_score(mesothelioma_target[test], predictions)
    print("The sensitivity is %.2f" % sensitivity)
    
    thisF1 = f1_score(mesothelioma_target[test], predictions)
    print("The F1 score is %.2f" % thisF1)
    
    specificity = tn / (tn + fp)
    print("The specificity is %.2f" % specificity)

    specificity_sum = specificity_sum + specificity
    thisF1_sum = thisF1_sum + thisF1
    sensitivity_sum = sensitivity_sum + sensitivity
    accu_sum = accu_sum + accu
    mcc_sum = mcc_sum + mcc
    
    vectMCC.append(mcc)
    vectSens.append(sensitivity)
    vectSpec.append(specificity)
    vectAcc.append(accu)
    vectF1.append(thisF1)


    print("kfold #{:<2}: Guessed {} out of {}".format(
        i, np.sum(predictions == mesothelioma_target[test]), test.size
    ))

mcc_average = mcc_sum/kfold_number
accu_average = accu_sum/kfold_number
specificity_average = specificity_sum/kfold_number
thisF1_average = thisF1_sum/kfold_number
sensitivity_average = sensitivity_sum/kfold_number

print("\n>>> The average MCC is %.3f" % mcc_average)
print(">>> The average accuracy is %.3f" % accu_average)
print("\n>>> The average specificity is %.3f" % specificity_average)
print(">>> The average sensitivity is %.3f" % sensitivity_average)
print(">>> The average F1 score is %.3f\n" % thisF1_average)

print("\n>>> The median MCC is ")
print(median(vectMCC))
print("\n>>> The median sensitivity is ")
print(median(vectSens))
print("\n>>> The median specificity is ")
print(median(vectSpec))
print("\n>>> The median accuracy is ")
print(median(vectAcc))
print("\n>>> The median F1 score is ")
print(median(vectF1))

end = time.time()
hours, rem = divmod(end-start, 3600)
minutes, seconds = divmod(rem, 60)
print("{:0>2} hours {:0>2} minutes {:05.2f} seconds".format(int(hours),int(minutes),seconds))

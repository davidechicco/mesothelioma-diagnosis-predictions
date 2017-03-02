# Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset
Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset

##Installation
To run the scripts, you need to have installed:
* R
* R packages clusterSim and randomForest
* Python
* Python package xlsx2csv
* Git
* Torch

You need to have root privileges, an internet connection, and at least 1 GB of free space on your hard disk. We here provide the instructions to install all the needed programs and dependencies on Linux CentOS, Linux Ubuntu, and Mac OS. Our scripts were originally developed on a Linux Ubuntu computer.

###Dependency installation for Linux Ubuntu
<img src="http://www.internetpost.it/wp-content/uploads/2016/04/ubuntu-head.png" width="150" align="right">
Here are the instructions to install all the programs and libraries needed by our scripts on a Linux Ubuntu computer, from a shell terminal. We tested these instructions on a Dell Latitude 3540 laptop running Linux Ubuntu 16.10 operating system, in February 2017. If you are using another operating system version, some instructions might be slightly different.

First of all, update:<br>
`sudo apt-get update`<br>

Install R and its rgl, clusterSim, randomForest packages:<br>
`sudo apt-get -y install r-base-core`<br>
`sudo apt-get -y install r-cran-rgl`<br>
`sudo Rscript -e 'install.packages(c("rgl", "clusterSim", "randomForest"), repos="https://cran.rstudio.com")'`<br>

Install xlsx2csv and git:<br>
`sudo apt-get -y install xlsx2csv`<br>
`sudo apt-get -y install git`<br>

Install Torch and luarocks:<br>
`# in a terminal, run the commands WITHOUT sudo`<br>
`git clone https://github.com/torch/distro.git ~/torch --recursive`<br>
`cd ~/torch; bash install-deps;`<br>
`./install.sh`<br>

`source ~/.bashrc`<br>
`cd ~`<br>

`sudo apt-get -y install luarocks`<br>
`sudo luarocks install csv`<br>

Clone this repository:<br>
`git clone https://github.com/davidechicco/mesothelioma-diagnosis-predictions.git`<br>

Move to the project main directory, and download the mesothelioma dataset file:<br>
`cd /mesothelioma-diagnosis-predictions/` <br>
`wget https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx` <br>

Remove the spaces from the dataset file name:<br>
`mv Mesothelioma\ data\ set.xlsx Mesothelioma_data_set.xlsx `

###Dependency installation for Linux CentOS
<img src="https://daichan.club/wp-content/uploads/2015/08/logo-centos-7.png" width="60" align="right">
Here are the instructions to install all the programs and libraries needed by our scripts on a Linux CentOS computer, from a shell terminal. We tested these instructions on a Dell Latitude 3540 laptop running Linux CentOS 7.2.1511 operating system, in February 2017. If you are using another operating system version, some instructions might be slightly different.

First of all, update:<br>
`sudo yum -y update`

Install R, its dependencies, and is rgl, clusterSim, randomForest packages:<br>
`sudo yum -y install R` <br>
`sudo yum -y install mesa-libGL` <br>
`sudo yum -y  install mesa-libGL-devel` <br>
`sudo yum -y  install mesa-libGLU` <br>
`sudo yum -y  install mesa-libGLU-devel` <br>
`sudo yum -y install libpng-devel` <br>
`sudo Rscript -e 'install.packages(c("rgl", "clusterSim", "randomForest"), repos="https://cran.rstudio.com")'` <br>

Install Python, its dependencies, and its packages pip and xlsxcsv:<br>
`sudo yum -y install python` <br>
`sudo yum -y install epel-release` <br>
`sudo yum -y install python-pip` <br>
`sudo pip install xlsx2csv` <br>

Install Torch and luarocks:<br>
`sudo apt-get -y install git` <br>
`# in a terminal, run the commands WITHOUT sudo` <br>
`git clone https://github.com/torch/distro.git ~/torch --recursive` <br>
`cd ~/torch; bash install-deps;` <br>
`./install.sh` <br>

`source ~/.bashrc`<br>
`cd ~`<br>

`sudo yum -y install luarocks` <br>
`sudo luarocks install csv` <br>

Clone this repository:<br>
`git clone https://github.com/davidechicco/mesothelioma-diagnosis-predictions.git`<br>

Move to the project main directory, and download the mesothelioma dataset file:<br>
`cd /mesothelioma-diagnosis-predictions/` <br>
`wget https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx` <br>

Remove the spaces from the dataset file name:<br>
`mv Mesothelioma\ data\ set.xlsx Mesothelioma_data_set.xlsx `

###Dependency installation for Mac OS
<img src="https://www.technobuffalo.com/wp-content/uploads/2015/06/Mac-OS-logo.jpg" width="150" align="right">
Here are the instructions to install all the programs and libraries needed by our scripts on a Mac computer, from a shell terminal. We tested these instructions on an Apple computer running a Mac OS macOS 10.12.2 Sierra operating system, in March 2017. If you are using another operating system version, some instructions might be slightly different.

First of all, update:<br>
`sudo softwareupdate -iva`<br>

Manually download and install XQuartz from https://www.xquartz.org <br>

Install R and its packages:
`brew install r`<br>
`sudo Rscript -e 'install.packages(c("rgl”, "clusterSim”, "randomForest”), repos="https://cran.rstudio.com")' `<br>

Install rudix:<br>
`curl -O https://raw.githubusercontent.com/rudix-mac/rpm/2016.12.13/rudix.py`<br>
`sudo python rudix.py install rudix`<br>

Install the development tools (such as gcc):<br>
`xcode-select --install`<br>

Install xlsx2csv:<br>
`sudo easy_install xlsx2csv` <br>

Install Torch and laurocks:<br>
`git clone https://github.com/torch/distro.git ~/torch --recursive`<br>
`cd ~/torch; bash install-deps`<br>
`./install.sh`<br>
`cd ~`<br>

`brew install lua`<br>
`source ~/.profile`<br>
`sudo luarocks install csv`<br>

Clone this repository:<br>
`git clone https://github.com/davidechicco/mesothelioma-diagnosis-predictions.git`<br>

Move to the project main directory, and download the mesothelioma dataset file:<br>
`cd /mesothelioma-diagnosis-predictions/`<br>
`curl -O 'https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx`<br>

Remove the spaces from the dataset file name:<br>
`mv Mesothelioma%20data%20set.xlsx Mesothelioma_data_set.xlsx` <br> 

##Execution for all (Linux Ubuntu, Linux CentOS, and Mac)
Normalize the dataset by column from zero to one:<br>
`Rscript arrange_mesothelioma_dataset.r Mesothelioma_data_set.xlsx` <br>

Run the artificial neural network Torch code:<br>
`th mesothelioma_ann_script_val.lua Mesothelioma_data_set_COL_NORM.csv` <br>

Run the random forest R code:<br>
`Rscript random_forests.r Mesothelioma_data_set_COL_NORM.csv` <br><br>

##License
All the software code is licensed under the [GNU General Public License, version 2 (GPLv2)](http://www.gnu.org/licenses/gpl-2.0-standalone.html).
The [metrics](https://github.com/hpenedones/metrics) package was developed and released by hpdenedones under the same GPLv2 license. The [weight-init.lua](https://github.com/e-lab/torch-toolbox) file was developed and released by e-lab under the same GPLv2 license

The [mesothelioma dataset file](https://archive.ics.uci.edu/ml/datasets/Mesothelioma%C3%A2%E2%82%AC%E2%84%A2s+disease+data+set+) is publically available on the website of the [University of California Irvine Machine Learning Repository](http://archive.ics.uci.edu/ml/), under their copyright license.

##Contacts
This sofware was developed by [Davide Chicco](http://www.DavideChicco.it) at [the Princess Margaret Cancer Centre](http://www.uhn.ca/PrincessMargaret/Research/) (Toronto, Ontario, Canada).

For questions or help, please write to davide.chicco(AT)davidechicco.it

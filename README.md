# Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset
Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset

##Dependency installation for Linux Ubuntu 12
<img src="http://www.internetpost.it/wp-content/uploads/2016/04/ubuntu-head.png" width="150" align="right">

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

`sudo apt-get -y install luarocks`<br>
`sudo luarocks install csv`<br>

##Dependency installation for Linux CentOS 7
<img src="https://daichan.club/wp-content/uploads/2015/08/logo-centos-7.png" width="60" align="right">

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

`sudo yum -y install luarocks` <br>
`sudo luarocks install csv` <br>


##Dependency installation for Mac OS 10
<img src="https://www.technobuffalo.com/wp-content/uploads/2015/06/Mac-OS-logo.jpg" width="150" align="right">

First of all, update:<br>

##Execution for all (Linux Ubuntu, Linux CentOS, and Mac)
Move to the project main directory, and download the mesothelioma dataset file from the University of California Irvine Machine Learning Repository:<br>
`cd /mesothelioma-diagnosis-predictions/` <br>
`wget https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx` <br>

Pre-process the input dataset, normalize it by column, and save it into a .csv file:<br>
`mkdir models` <br>
`mkdir mse_logs` <br>
`mv Mesothelioma\ data\ set.xlsx Mesothelioma_data_set.xlsx` <br>
`Rscript arrange_mesothelioma_dataset.r Mesothelioma_data_set.xlsx` <br>

Run the artificial neural network Torch code:<br>
`th mesothelioma_ann_script_val.lua Mesothelioma_data_set_COL_NORM.csv` <br>

Run the random forest R code:<br>
`Rscript randomForest.r` <br><br>

( For questions or help, please write to davide.chicco(AT)davidechicco.it )

# Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset
Computational prediction of patients diagnosis and feature selection applied to a mesothelioma dataset

##Instructions for Linux Ubuntu 12

`sudo apt-get update`<br>

`sudo apt-get -y install r-base-core`<br>
`sudo apt-get -y install r-cran-rgl`<br>
`sudo Rscript -e 'install.packages(c("rgl", "clusterSim", "randomForest"), repos="https://cran.rstudio.com")'`<br>
`sudo apt-get -y install xlsx2csv`<br>

`sudo apt-get -y install git`<br>
`# in a terminal, run the commands WITHOUT sudo`<br>
`git clone https://github.com/torch/distro.git ~/torch --recursive`<br>
`cd ~/torch; bash install-deps;`<br>
`./install.sh`<br>

`sudo apt-get -y install luarocks`<br>
`sudo luarocks install csv`<br>

`cd /mesothelioma-diagnosis-predictions/`<br>
`wget https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx`<br>

`mv Mesothelioma\ data\ set.xlsx Mesothelioma_data_set.xlsx`<br>
`Rscript arrange_mesothelioma_dataset.r Mesothelioma_data_set.xlsx`<br>
`th mesothelioma_ann_script_val.lua Mesothelioma_data_set_COL_NORM.csv`<br>
`Rscript randomForest.r`<br>



##Instructions for Linux CentOS 7
`sudo yum -y update`

`sudo yum -y install R` <br>
`sudo yum -y install mesa-libGL` <br>
`sudo yum -y  install mesa-libGL-devel` <br>
`sudo yum -y  install mesa-libGLU` <br>
`sudo yum -y  install mesa-libGLU-devel` <br>
`sudo yum -y install libpng-devel` <br>
`sudo Rscript -e 'install.packages(c("rgl", "clusterSim", "randomForest"), repos="https://cran.rstudio.com")'` <br>

`sudo yum -y install python` <br>
`sudo yum -y install epel-release` <br>
`sudo yum -y install python-pip` <br>
`sudo pip install xlsx2csv` <br>

`sudo apt-get -y install git` <br>
`# in a terminal, run the commands WITHOUT sudo` <br>
`git clone https://github.com/torch/distro.git ~/torch --recursive` <br>
`cd ~/torch; bash install-deps;` <br>
`./install.sh` <br>

`sudo yum -y install luarocks` <br>
`sudo luarocks install csv` <br>

`cd /mesothelioma-diagnosis-predictions/` <br>
`wget https://archive.ics.uci.edu/ml/machine-learning-databases/00351/Mesothelioma%20data%20set.xlsx` <br>

`mkdir models` <br>
`mkdir mse_logs` <br>
`mv Mesothelioma\ data\ set.xlsx Mesothelioma_data_set.xlsx` <br>
`Rscript arrange_mesothelioma_dataset.r Mesothelioma_data_set.xlsx` <br>
`th mesothelioma_ann_script_val.lua Mesothelioma_data_set_COL_NORM.csv` <br>
`Rscript randomForest.r` <br>



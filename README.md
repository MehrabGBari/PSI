# Positive Synergy Index (PSI)

Feature selection method for gene expression microarray data.
Microarray gene expression data from 22 different tumor type were used for test PSI algorithm. 
Please see http://compgenomics.utsa.edu/zgroup/PSI/download.html to download the interested data set.

Related paper(s):

%[1] 
Bari, M. G., Salekin, S. and Zhang, J. (2016), 
A Robust and Efficient Feature Selection Algorithm for Microarray Data. Mol. Inf.. doi:10.1002/minf.201600099
[2]
Salekin, Sirajul, Mehrab Ghanat Bari, Itay Raphael, Thomas G. Forsthuber, and Jianqiu Michelle Zhang. 
"Early disease correlated protein detection using early response index (ERI)." 
In 2016 IEEE-EMBS International Conference on Biomedical and Health Informatics (BHI), pp. 569-572. IEEE, 2016.


                                                     ****
                                                 ************
                                      ************************************
                                      ************************************               
                                  
                                  
## 1 Introduction
We developed a new feature selection method, PSI, which based on the synergistic effects caused
when the features combined to each other and are used as input of a classifier. The idea is that, irrelevant
features, while combining other features are more likely to contribute negatively to classifier performance
in train set. On the other hand, when informative genes are used in panels, the synergistic effect of them
cause the classifier better learning, and this leads to better classification results. Our exprements show that,
ranking features based on their performance when they are combined, could provide a good feature set to
train a model to classify the unseen test set.

## SVM vs LR in developing PSI
In the PSI algorithm, to compute the synergy scores of features, the individual and paired accuracy of preselected $N$ features are needed, and it uses SVM classifier to do so. Here, we want to show the benefit of using SVM for the computation of accuracy of a feature or feature pairs, $Acc(F_i)$ and $Acc(F_i, F_j)$, respectively.

![acc_svm_lr_n300_alpha29v1](https://cloud.githubusercontent.com/assets/12883478/21485654/d8c0cdc4-cb6b-11e6-8bcc-2eee0b11da38.png)

As SVM scales with number of samples and Logistic Regression (LR) with number of features, this should be preferable for large datasets. It is a good practice to use LR instead of SVM in PSI body to see whether on not LR would be more efficient. The Figure \ref{fig1} shows the average accuracy and run time of PSI when using LR and SVM over all the datasets. In both cases the $N=300$, $\alpha = 0.29$ and 10-fold cross validation scheme was used. When $N=300$, PSI is about 5 times faster than, when it uses LR instead of SVM. However, it causes very poor accuracy results as shown in the Figure \ref{fig1}\_a. Note that, we proposed $N$ to be equal to 100 in the final PSI while using SVM, which is at lease 7 times faster than when $N=300$ and still has the same good average accuracies. The effect of $N$ on PSI performance is represented in the next section.
Above results, convincing us to use SVM in PSI structure, and since we are using the original SVM function in MATLAB without any parameter setting, subsequently PSI uses SVM with the benefit of not having to select a cost parameters. 
  

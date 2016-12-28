# Positive Synergy Index (PSI)

Feature selection method for gene expression microarray data.
Microarray gene expression data from 22 different tumor type were used for test PSI algorithm.

Please see http://compgenomics.utsa.edu/zgroup/PSI/download.html to download the interested data set.

### Related paper(s):

[1]. Bari, M. G., Salekin, S. and Zhang, J. (2016), 
A Robust and Efficient Feature Selection Algorithm for Microarray Data. Mol. Inf.. doi:10.1002/minf.201600099

[2]. Salekin, S., Bari, M. G., Raphael, I., Forsthuber, T. G., & Zhang, J. M. (2016, February). Early disease correlated protein detection using early response index (ERI). In 2016 IEEE-EMBS International Conference on Biomedical and Health Informatics (BHI) (pp. 569-572). IEEE.

[3]. ....


                                                     ****
                                                 ************
                                      ************************************
                                      ************************************               
                                                 ************                                  
                                                     ****
						     
						     
## Introduction
We developed a new feature selection method, PSI, which based on the synergistic effects caused
when the features combined to each other and are used as input of a classifier. The idea is that, irrelevant
features, while combining other features are more likely to contribute negatively to classifier performance
in train set. On the other hand, when informative genes are used in panels, the synergistic effect of them
cause the classifier better learning, and this leads to better classification results. Our exprements show that,
ranking features based on their performance when they are combined, could provide a good feature set to
train a model to classify the unseen test set.

## SVM vs LR in developing PSI
In the PSI algorithm, to compute the synergy scores of features, the individual and paired accuracy of preselected N features are needed, and it uses SVM classifier to do so. Here, we want to show the benefit of using SVM for the computation of accuracy of a feature or feature pairs, *Acc(F_i)* and *Acc(F_i, F_j)*, respectively.

![figs1](https://cloud.githubusercontent.com/assets/12883478/21486274/0ea5477a-cb77-11e6-90d4-c72e0aea755d.png)
__Figure 1:__ Comparing PSI accuracy performance and time complicity using SVM and LR, a) Average accuracy over 22 datasets b) Boxplot of the average of averages running time

As SVM scales with number of samples and Logistic Regression (LR) with number of features, this should be preferable for large datasets. It is a good practice to use LR instead of SVM in PSI body to see whether on not LR would be more efficient. The Figure 1 shows the average accuracy and run time of PSI when using LR and SVM over all the datasets. In both cases the N=300, *alpha* = 0.29 and 10-fold cross validation scheme was used. When N=300, PSI is about 5 times faster than, when it uses LR instead of SVM. However, it causes very poor accuracy results as shown in the Figure Figure 1_a. Note that, we proposed N to be equal to 100 in the final PSI while using SVM, which is at lease 7 times faster than when N=300 and still has the same good average accuracies. The effect of N on PSI performance is represented in the next section.
Above results, convincing us to use SVM in PSI structure, and since we are using the original SVM function in MATLAB without any parameter setting, subsequently PSI uses SVM with the benefit of not having to select a cost parameters. 


## The effect of  N on average performance 
To find the best N for PSI, we examined the effect of N on the PSI's average performance and computational time. Since, bigger N makes PSI computationally expensive, the question is that how much a big N would increase the accuracy? As shown in the Figure Figure 2, we compared PSI's average running time and accuracy for N equal to 100, 200 and 300. The mixing parameter, *alpha*, was set to 0.29 for all cases and 10-fold outer and 5-fold inner cross validation were used. 

![figs2](https://cloud.githubusercontent.com/assets/12883478/21486275/0ea56f66-cb77-11e6-9acf-a7d81a2eab10.png)
__Figure 2:__ Comparing the The effect of  N on average performance, a) Average accuracies, b) Average running time

The number of SVM classifiers need by PSI is equal to 10 * 5 * (N(N-1)/2) which is a function of N. The number 10 and 5 show the number of outer and inner cross validation. The number of SVM classifiers for N=100, 200 and 300 are 247500, 995000 and 2242500 for each dataset respectively. Although, PSI was developed using parallel processing technique, by increasing N, running time increases rapidly without any improvement over PSI's results when N is 100.  

Also for the datasets "Colon" and "CNS", which have 2000 and 7129 genes, we used all features to calculating the synergy scores. The number of classifiers are 99950000 and 1270400000 and the running time were 33 and 285 hours for "Colon" and "CNS" respectively, and in the both of the cases the accuracies were below than those of when N was equal to 100 (in average 2% less). 

## The effect of  *alpha* on average performance

The ‘mixing’ parameter*alpha*, is a parameter of PSI along with N the number of features considered (Set to 100). It is selected to be 0.29 based on the average of the *alpha* cause best accuracy for each dataset in training step. 
Figure 3 shows the effect of changing *alpha* on PSI's average accuracy on datasets "CNS'', "GCM'', "GSE27854'' and "Prostate4'', when PSI applies on unseen test sets. PSI average accuracy in most of 22 cases show a peak when *alpha* is around 0.16 like the cases "GCM'' and "Prostate4''. Because *alpha*=0.16 was seen in the outmost loop of the double CV scheme, then PSI may have an unfair advantage over the other methods, then we report the results by using *alpha* = 0.29.

![figs3](https://cloud.githubusercontent.com/assets/12883478/21486273/0ea53190-cb77-11e6-86f1-9672abd28c08.png)
__Figure 3:__ The effect of  *alpha* on average accuracy of PSI using 1 up to 50 top features in dataset, a) CNS, b) GCM, c) GSE27854, d) Prostate3

## KNN classifier
Each of the 14 feature selection methods in this study, were applied to all 22 datasets and the 50 features reported by each method, used to train the SVM classifier. PSI shows best average accuracy over all other method while having 4th less computational times. PSI, also uses SVM to calculating the synergy scores. To make sure that PSI good performance is not because of classifier effect, we used top 50 features reported by all methods to train K-Nearest Neighbor (KNN) classifier, and then the trained KNN classifier were applied on test sets and the accuracy of each method were recorded. Figure Figure4} shows the average results over 22 datasets when top 1, 2, 10, 15, 25 and 50 features were used.
The parameter K for KNN classifier is a user-defined positive constant and a common used choice to assign a value for K is equal to the square root of the number of samples. It is a good starting point and given a dataset, we rounded its square root of the number of samples to the nearest odd number *(2 * round(sqrt{S-1}/2)+1)*, and that was selected as the final K.
As shown in the Figure 4, PSI has the best accuracies in general like what we can see when the SVM used as final classifier. SAM method as explained in the main paper, when the number of features are small, has the highest average accuracy but as the number of features used are increased, the synergistic based methods, PSI and k-TSP could provide more informative features to the classifier and cause better performances. However, this is not k-TSP in reality, because it is proposed as classifier, which is based on majority of voting of negatively correlated pairs. It has been shown that when the features extracted by k-TSP used to train SVM classifier, the achieved performance is pretty better than of k-TSP as classifier. Also, it shall be noted that the k-TSP is computationally is much more expensive the PSI. Our results show that, PSI in average is 35 times faster than k-TSP.

![figs4](https://cloud.githubusercontent.com/assets/12883478/21486278/0eacd2b0-cb77-11e6-9e7d-1aef0b24ea0c.png)
__Figure 4:__ KNN classifier average 10-fold cross validation accuracy over 22 datasets using 1 in (a), 2 in (b), 10 in (c), 15 in (d), 25 in (e) and 50 in (f), features.

 Also, Figure 5 shows box-plot of average accuracies achieved by using 1, 2, ...,50 top features when SVM and KNN used as final classifiers. The 14 methods ranked by the median of the average accuracies they produced and it is clear in both case PSI has the best results. There are slight changes in other method's rank when different classifiers are used and these spares changes are acceptable due to internal characteristics of different classifiers. PSI, k-TSP and SAM are the three best method using SVM or KNN, and CI, the other synergistic method is in the 4th rank when SVM was used. The k-TSP has received those good performance because in this exprement it uses SVM and KNN as classifiers and previous studies have shown than when k-TSP uses it own internal classifier, its performance will be lower than what were represented in this research, furthermore its time complexity is much more than PSI, since it uses combinations of two all features, while PSI needs to evaluate those of only N=100 preselected features for the same dataset.             

![figs5](https://cloud.githubusercontent.com/assets/12883478/21486370/29b9a75c-cb79-11e6-80fc-0365a96ae6ac.png)
__Figure 5:__ Boxplot of 10-fold cross validation accuracy results using top 10 features (SVM).


## Wilcoxon test to examining the significance in accuracy gain
Figure 5 shows the box plot of accuracy results provided by 14 methods using top 10 features on 22 datasets, which are represented in the Table 3 in the main paper [1]. We want to evaluate the significance of the gain in accuracy listed in that Table. Wilcoxon test, is appropriate for evaluating the median difference in outcomes of two populations which are paired or dependent. The null hypothesis, H_0, which indicates that the median of changes in accuracy comparing PSI and all others is equal 0. Table 1 shows the alternative hypothesis H_1 as well as test statistic, confidence interval and p-value when PSI's results compared to those of other methods. In all the comparisons, H_0 is rejected by Wilcoxon test at significance level equal to 0.05, and the conclusion is that data available in the Table 3 in the main paper, provide sufficient evidence to conclude that PSI is grater than those of each other methods at significance level of 0.05.   

**Table 1:** Wilcoxon signed rank test with continuity correction

 *H_1* |  95% confidence interval | (pseudo)median | Test statistic |  p-value	 | -log2(p-value)  
--- | --- | --- | --- | --- | --- 
PSI v.s. IA	| True	| (1.4 , 9.1) |	4.73	| 198 |	0.0043 |	7.8 
PSI v.s. k-TSP	| True| (-0.5 , 2.6) |	1.39 |	157 |	0.15 |	2.6  
PSI v.s. SVM-R	| True| (0.1 , 5.6) |	2.64 |	176	| 0.037 |	4.7  
PSI v.s. mRMR	| True	| (14.5 , 25.3) |	19.57 |	252	| 4.93e-05	| 14.3  
PSI v.s. SAM	| True	| (-0.9 , 2.5) |	0.84	| 140	| 0.40 |	1.3  
PSI v.s. IG	| True| (-1 , 2.1) |	0.90 |	151	 | 0.22	| 2.1  
PSI v.s. oneR	| True| (9.1 , 21.4) |	14.9 |	240	 | 4.19e-05	 | 14.5  
PSI v.s. RF	| True	| (0.7 , 5.8) |	3.27 |	188	| 0.012 | 	6.3  
PSI v.s. GR	| True	| (0.1 , 5.5) |	2.70 |	179 |	0.028 |	5.1  
PSI v.s. CS	| True	| (-1.1 , 2.9) |	1.12 |	147	 | 0.28 |	1.8  
PSI v.s. SU	| True| (0.01 , 2.4) |	1.40 |	173	| 0.046	| 4.4  
PSI v.s. CFS	| True| (3.1 , 9.1)	| 6.39	| 206	| 0.0017	| 9.1  
PSI v.s. CI	| True| (-1.3 , 2.5)	| 0.44	| 150	| 0.45	| 1.1 	


## SVM, KNN and GLM classifiers comparison

Beside SVM and KNN classifiers we also used GLM classifier for comparison of 14 feature selection approaches. Figure 6 shows the boxplots of SVM,KNN, and GLM classifiers average performance over using 1 to 50 top features reported by all 14 methods on all 22 data sets in 10-fold cross-validation approach.  

![figs6](https://cloud.githubusercontent.com/assets/12883478/21486277/0eabf7fa-cb77-11e6-9da5-85ac78882099.png)
__Figure 6:__ Boxplot of SVM,KNN, and GLM classifiers performance using 1 to 50 top features reported by all 14 methods.



  

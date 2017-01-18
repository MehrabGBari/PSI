<<<<<<< HEAD
=======
# Positive Synergy Index (PSI)

Feature selection method for gene expression microarray data.
Microarray gene expression data from 22 different tumor type were used for test PSI algorithm.
>>>>>>> origin/master


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



<<<<<<< HEAD

<!DOCTYPE html>
<html lang="en" class=" is-u2f-enabled">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    

    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/frameworks-c07e6f4b02b556d1d85052fb3853caf84c80e6b23dcdb1ae1b00f051da1115a2.css" integrity="sha256-wH5vSwK1VtHYUFL7OFPK+EyA5rI9zbGuGwDwUdoRFaI=" media="all" rel="stylesheet" />
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/github-c1778c4802d4029d4b6cda1d8b4bf3d900b36752832715d2d2895ea63cf05de2.css" integrity="sha256-wXeMSALUAp1LbNodi0vz2QCzZ1KDJxXS0olepjzwXeI=" media="all" rel="stylesheet" />
    
    
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/site-293f92180d0a619a750fa2b5eae9e36740f5723a59c0ec308972c70d24e834fc.css" integrity="sha256-KT+SGA0KYZp1D6K16unjZ0D1cjpZwOwwiXLHDSToNPw=" media="all" rel="stylesheet" />
    

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta name="viewport" content="width=device-width">
    
    <title>PSI/README.md at master · MehrabGBari/PSI · GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub">
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
    <meta property="fb:app_id" content="1401488693436528">

      <meta content="https://avatars1.githubusercontent.com/u/12883478?v=3&amp;s=400" name="twitter:image:src" /><meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="MehrabGBari/PSI" name="twitter:title" /><meta content="PSI - Positive Synergy Index. Feature selection method for gene expression microarray data. See the provided link to download .mat format of 22 microarry datasets used in this study." name="twitter:description" />
      <meta content="https://avatars1.githubusercontent.com/u/12883478?v=3&amp;s=400" property="og:image" /><meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="MehrabGBari/PSI" property="og:title" /><meta content="https://github.com/MehrabGBari/PSI" property="og:url" /><meta content="PSI - Positive Synergy Index. Feature selection method for gene expression microarray data. See the provided link to download .mat format of 22 microarry datasets used in this study." property="og:description" />
      <meta name="browser-stats-url" content="https://api.github.com/_private/browser/stats">
    <meta name="browser-errors-url" content="https://api.github.com/_private/browser/errors">
    <link rel="assets" href="https://assets-cdn.github.com/">
    
    <meta name="pjax-timeout" content="1000">
    
    <meta name="request-id" content="B8AB:03D9:8ECC5F:D9BA3C:587FC818" data-pjax-transient>

    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="selected-link" value="repo_source" data-pjax-transient>

    <meta name="google-site-verification" content="KT5gs8h0wvaagLKAVWq8bbeNwnZZK1r1XQysX3xurLU">
<meta name="google-site-verification" content="ZzhVyEFwb7w3e0-uOTltm8Jsck2F5StVihD0exw2fsA">
    <meta name="google-analytics" content="UA-3769691-2">

<meta content="collector.githubapp.com" name="octolytics-host" /><meta content="github" name="octolytics-app-id" /><meta content="B8AB:03D9:8ECC5F:D9BA3C:587FC818" name="octolytics-dimension-request_id" />
<meta content="/&lt;user-name&gt;/&lt;repo-name&gt;/blob/show" data-pjax-transient="true" name="analytics-location" />



  <meta class="js-ga-set" name="dimension1" content="Logged Out">



        <meta name="hostname" content="github.com">
    <meta name="user-login" content="">

        <meta name="expected-hostname" content="github.com">
      <meta name="js-proxy-site-detection-payload" content="MTc2YWMyMGI3MTIxNGJlZmVmOGMwNjU5YzU3MTIwODk2YmZhNzBkYjY0YTliNjJiZjg4YWQzNjA1YThhZmMyNHx7InJlbW90ZV9hZGRyZXNzIjoiMTI5LjE3Ni4xOTcuMjQiLCJyZXF1ZXN0X2lkIjoiQjhBQjowM0Q5OjhFQ0M1RjpEOUJBM0M6NTg3RkM4MTgiLCJ0aW1lc3RhbXAiOjE0ODQ3NjkzMTEsImhvc3QiOiJnaXRodWIuY29tIn0=">


      <link rel="mask-icon" href="https://assets-cdn.github.com/pinned-octocat.svg" color="#000000">
      <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">

    <meta name="html-safe-nonce" content="b291120b1a9ebc42987e057d78f57ff887c47b80">

    <meta http-equiv="x-pjax-version" content="b23642781c6e1a8e1175a8f3b29e82a6">
    

      
  <meta name="description" content="PSI - Positive Synergy Index. Feature selection method for gene expression microarray data. See the provided link to download .mat format of 22 microarry datasets used in this study.">
  <meta name="go-import" content="github.com/MehrabGBari/PSI git https://github.com/MehrabGBari/PSI.git">

  <meta content="12883478" name="octolytics-dimension-user_id" /><meta content="MehrabGBari" name="octolytics-dimension-user_login" /><meta content="69918223" name="octolytics-dimension-repository_id" /><meta content="MehrabGBari/PSI" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="69918223" name="octolytics-dimension-repository_network_root_id" /><meta content="MehrabGBari/PSI" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/MehrabGBari/PSI/commits/master.atom" rel="alternate" title="Recent Commits to PSI:master" type="application/atom+xml">


      <link rel="canonical" href="https://github.com/MehrabGBari/PSI/blob/master/README.md" data-pjax-transient>
  </head>


  <body class="logged-out  env-production windows vis-public page-blob">
    <div id="js-pjax-loader-bar" class="pjax-loader-bar"><div class="progress"></div></div>
    <a href="#start-of-content" tabindex="1" class="accessibility-aid js-skip-to-content">Skip to content</a>

    
    
    



          <header class="site-header js-details-container Details alt-body-font" role="banner">
  <div class="container-responsive">
    <a class="header-logo-invertocat" href="https://github.com/" aria-label="Homepage" data-ga-click="(Logged out) Header, go to homepage, icon:logo-wordmark">
      <svg aria-hidden="true" class="octicon octicon-mark-github" height="32" version="1.1" viewBox="0 0 16 16" width="32"><path fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"/></svg>
    </a>

    <button class="btn-link float-right site-header-toggle js-details-target" type="button" aria-label="Toggle navigation">
      <svg aria-hidden="true" class="octicon octicon-three-bars" height="24" version="1.1" viewBox="0 0 12 16" width="18"><path fill-rule="evenodd" d="M11.41 9H.59C0 9 0 8.59 0 8c0-.59 0-1 .59-1H11.4c.59 0 .59.41.59 1 0 .59 0 1-.59 1h.01zm0-4H.59C0 5 0 4.59 0 4c0-.59 0-1 .59-1H11.4c.59 0 .59.41.59 1 0 .59 0 1-.59 1h.01zM.59 11H11.4c.59 0 .59.41.59 1 0 .59 0 1-.59 1H.59C0 13 0 12.59 0 12c0-.59 0-1 .59-1z"/></svg>
    </button>

    <div class="site-header-menu">
      <nav class="site-header-nav site-header-nav-main">
        <a href="/personal" class="js-selected-navigation-item nav-item nav-item-personal" data-ga-click="Header, click, Nav menu - item:personal" data-selected-links="/personal /personal">
          Personal
</a>        <a href="/open-source" class="js-selected-navigation-item nav-item nav-item-opensource" data-ga-click="Header, click, Nav menu - item:opensource" data-selected-links="/open-source /open-source">
          Open source
</a>        <a href="/business" class="js-selected-navigation-item nav-item nav-item-business" data-ga-click="Header, click, Nav menu - item:business" data-selected-links="/business /business/partners /business/features /business/customers /business">
          Business
</a>        <a href="/explore" class="js-selected-navigation-item nav-item nav-item-explore" data-ga-click="Header, click, Nav menu - item:explore" data-selected-links="/explore /trending /trending/developers /integrations /integrations/feature/code /integrations/feature/collaborate /integrations/feature/ship /showcases /explore">
          Explore
</a>      </nav>

      <div class="site-header-actions">
            <a class="btn btn-primary site-header-actions-btn" href="/join?source=header-repo" data-ga-click="(Logged out) Header, clicked Sign up, text:sign-up">Sign up</a>
          <a class="btn site-header-actions-btn mr-1" href="/login?return_to=%2FMehrabGBari%2FPSI%2Fblob%2Fmaster%2FREADME.md" data-ga-click="(Logged out) Header, clicked Sign in, text:sign-in">Sign in</a>
      </div>

        <nav class="site-header-nav site-header-nav-secondary mr-md-3">
          <a class="nav-item" href="/pricing">Pricing</a>
          <a class="nav-item" href="/blog">Blog</a>
          <a class="nav-item" href="https://help.github.com">Support</a>
          <a class="nav-item header-search-link" href="https://github.com/search">Search GitHub</a>
              <div class="header-search scoped-search site-scoped-search js-site-search" role="search">
  <!-- '"` --><!-- </textarea></xmp> --></option></form><form accept-charset="UTF-8" action="/MehrabGBari/PSI/search" class="js-site-search-form" data-scoped-search-url="/MehrabGBari/PSI/search" data-unscoped-search-url="/search" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    <label class="form-control header-search-wrapper js-chromeless-input-container">
      <div class="header-search-scope">This repository</div>
      <input type="text"
        class="form-control header-search-input js-site-search-focus js-site-search-field is-clearable"
        data-hotkey="s"
        name="q"
        placeholder="Search"
        aria-label="Search this repository"
        data-unscoped-placeholder="Search GitHub"
        data-scoped-placeholder="Search"
        autocapitalize="off">
    </label>
</form></div>

        </nav>
    </div>
  </div>
</header>



    <div id="start-of-content" class="accessibility-aid"></div>

      <div id="js-flash-container">
</div>


    <div role="main">
        <div itemscope itemtype="http://schema.org/SoftwareSourceCode">
    <div id="js-repo-pjax-container" data-pjax-container>
      
<div class="pagehead repohead instapaper_ignore readability-menu experiment-repo-nav">
  <div class="container repohead-details-container">

    

<ul class="pagehead-actions">

  <li>
      <a href="/login?return_to=%2FMehrabGBari%2FPSI"
    class="btn btn-sm btn-with-count tooltipped tooltipped-n"
    aria-label="You must be signed in to watch a repository" rel="nofollow">
    <svg aria-hidden="true" class="octicon octicon-eye" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z"/></svg>
    Watch
  </a>
  <a class="social-count" href="/MehrabGBari/PSI/watchers"
     aria-label="1 user is watching this repository">
    1
  </a>

  </li>

  <li>
      <a href="/login?return_to=%2FMehrabGBari%2FPSI"
    class="btn btn-sm btn-with-count tooltipped tooltipped-n"
    aria-label="You must be signed in to star a repository" rel="nofollow">
    <svg aria-hidden="true" class="octicon octicon-star" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74z"/></svg>
    Star
  </a>

    <a class="social-count js-social-count" href="/MehrabGBari/PSI/stargazers"
      aria-label="0 users starred this repository">
      0
    </a>

  </li>

  <li>
      <a href="/login?return_to=%2FMehrabGBari%2FPSI"
        class="btn btn-sm btn-with-count tooltipped tooltipped-n"
        aria-label="You must be signed in to fork a repository" rel="nofollow">
        <svg aria-hidden="true" class="octicon octicon-repo-forked" height="16" version="1.1" viewBox="0 0 10 16" width="10"><path fill-rule="evenodd" d="M8 1a1.993 1.993 0 0 0-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 0 0 2 1a1.993 1.993 0 0 0-1 3.72V6.5l3 3v1.78A1.993 1.993 0 0 0 5 15a1.993 1.993 0 0 0 1-3.72V9.5l3-3V4.72A1.993 1.993 0 0 0 8 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"/></svg>
        Fork
      </a>

    <a href="/MehrabGBari/PSI/network" class="social-count"
       aria-label="0 users forked this repository">
      0
    </a>
  </li>
</ul>

    <h1 class="public ">
  <svg aria-hidden="true" class="octicon octicon-repo" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M4 9H3V8h1v1zm0-3H3v1h1V6zm0-2H3v1h1V4zm0-2H3v1h1V2zm8-1v12c0 .55-.45 1-1 1H6v2l-1.5-1.5L3 16v-2H1c-.55 0-1-.45-1-1V1c0-.55.45-1 1-1h10c.55 0 1 .45 1 1zm-1 10H1v2h2v-1h3v1h5v-2zm0-10H2v9h9V1z"/></svg>
  <span class="author" itemprop="author"><a href="/MehrabGBari" class="url fn" rel="author">MehrabGBari</a></span><!--
--><span class="path-divider">/</span><!--
--><strong itemprop="name"><a href="/MehrabGBari/PSI" data-pjax="#js-repo-pjax-container">PSI</a></strong>

</h1>

  </div>
  <div class="container">
    
<nav class="reponav js-repo-nav js-sidenav-container-pjax"
     itemscope
     itemtype="http://schema.org/BreadcrumbList"
     role="navigation"
     data-pjax="#js-repo-pjax-container">

  <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
    <a href="/MehrabGBari/PSI" class="js-selected-navigation-item selected reponav-item" data-hotkey="g c" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches /MehrabGBari/PSI" itemprop="url">
      <svg aria-hidden="true" class="octicon octicon-code" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M9.5 3L8 4.5 11.5 8 8 11.5 9.5 13 14 8 9.5 3zm-5 0L0 8l4.5 5L6 11.5 2.5 8 6 4.5 4.5 3z"/></svg>
      <span itemprop="name">Code</span>
      <meta itemprop="position" content="1">
</a>  </span>

    <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
      <a href="/MehrabGBari/PSI/issues" class="js-selected-navigation-item reponav-item" data-hotkey="g i" data-selected-links="repo_issues repo_labels repo_milestones /MehrabGBari/PSI/issues" itemprop="url">
        <svg aria-hidden="true" class="octicon octicon-issue-opened" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"/></svg>
        <span itemprop="name">Issues</span>
        <span class="counter">0</span>
        <meta itemprop="position" content="2">
</a>    </span>

  <span itemscope itemtype="http://schema.org/ListItem" itemprop="itemListElement">
    <a href="/MehrabGBari/PSI/pulls" class="js-selected-navigation-item reponav-item" data-hotkey="g p" data-selected-links="repo_pulls /MehrabGBari/PSI/pulls" itemprop="url">
      <svg aria-hidden="true" class="octicon octicon-git-pull-request" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M11 11.28V5c-.03-.78-.34-1.47-.94-2.06C9.46 2.35 8.78 2.03 8 2H7V0L4 3l3 3V4h1c.27.02.48.11.69.31.21.2.3.42.31.69v6.28A1.993 1.993 0 0 0 10 15a1.993 1.993 0 0 0 1-3.72zm-1 2.92c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zM4 3c0-1.11-.89-2-2-2a1.993 1.993 0 0 0-1 3.72v6.56A1.993 1.993 0 0 0 2 15a1.993 1.993 0 0 0 1-3.72V4.72c.59-.34 1-.98 1-1.72zm-.8 10c0 .66-.55 1.2-1.2 1.2-.65 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z"/></svg>
      <span itemprop="name">Pull requests</span>
      <span class="counter">0</span>
      <meta itemprop="position" content="3">
</a>  </span>

  <a href="/MehrabGBari/PSI/projects" class="js-selected-navigation-item reponav-item" data-selected-links="repo_projects new_repo_project repo_project /MehrabGBari/PSI/projects">
    <svg aria-hidden="true" class="octicon octicon-project" height="16" version="1.1" viewBox="0 0 15 16" width="15"><path fill-rule="evenodd" d="M10 12h3V2h-3v10zm-4-2h3V2H6v8zm-4 4h3V2H2v12zm-1 1h13V1H1v14zM14 0H1a1 1 0 0 0-1 1v14a1 1 0 0 0 1 1h13a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1z"/></svg>
    Projects
    <span class="counter">0</span>
</a>


  <a href="/MehrabGBari/PSI/pulse" class="js-selected-navigation-item reponav-item" data-selected-links="pulse /MehrabGBari/PSI/pulse">
    <svg aria-hidden="true" class="octicon octicon-pulse" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M11.5 8L8.8 5.4 6.6 8.5 5.5 1.6 2.38 8H0v2h3.6l.9-1.8.9 5.4L9 8.5l1.6 1.5H14V8z"/></svg>
    Pulse
</a>
  <a href="/MehrabGBari/PSI/graphs" class="js-selected-navigation-item reponav-item" data-selected-links="repo_graphs repo_contributors /MehrabGBari/PSI/graphs">
    <svg aria-hidden="true" class="octicon octicon-graph" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M16 14v1H0V0h1v14h15zM5 13H3V8h2v5zm4 0H7V3h2v10zm4 0h-2V6h2v7z"/></svg>
    Graphs
</a>

</nav>

  </div>
</div>

<div class="container new-discussion-timeline experiment-repo-nav">
  <div class="repository-content">

    

<a href="/MehrabGBari/PSI/blob/a7aadc8dc52a3a2b193f4d0f20633d1d3219a556/README.md" class="d-none js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:0def809bed0d99d9913b6bece9d1b29e -->

<div class="file-navigation js-zeroclipboard-container">
  
<div class="select-menu branch-select-menu js-menu-container js-select-menu float-left">
  <button class="btn btn-sm select-menu-button js-menu-target css-truncate" data-hotkey="w"
    
    type="button" aria-label="Switch branches or tags" tabindex="0" aria-haspopup="true">
    <i>Branch:</i>
    <span class="js-select-button css-truncate-target">master</span>
  </button>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax aria-hidden="true">

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <svg aria-label="Close" class="octicon octicon-x js-menu-close" height="16" role="img" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"/></svg>
        <span class="select-menu-title">Switch branches/tags</span>
      </div>

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Filter branches/tags" id="context-commitish-filter-field" class="form-control js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" data-filter-placeholder="Filter branches/tags" class="js-select-menu-tab" role="tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" data-filter-placeholder="Find a tag…" class="js-select-menu-tab" role="tab">Tags</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches" role="menu">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <a class="select-menu-item js-navigation-item js-navigation-open selected"
               href="/MehrabGBari/PSI/blob/master/README.md"
               data-name="master"
               data-skip-pjax="true"
               rel="nofollow">
              <svg aria-hidden="true" class="octicon octicon-check select-menu-item-icon" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M12 5l-8 8-4-4 1.5-1.5L4 10l6.5-6.5z"/></svg>
              <span class="select-menu-item-text css-truncate-target js-select-menu-filter-text">
                master
              </span>
            </a>
        </div>

          <div class="select-menu-no-results">Nothing to show</div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div>

    </div>
  </div>
</div>

  <div class="BtnGroup float-right">
    <a href="/MehrabGBari/PSI/find/master"
          class="js-pjax-capture-input btn btn-sm BtnGroup-item"
          data-pjax
          data-hotkey="t">
      Find file
    </a>
    <button aria-label="Copy file path to clipboard" class="js-zeroclipboard btn btn-sm BtnGroup-item tooltipped tooltipped-s" data-copied-hint="Copied!" type="button">Copy path</button>
  </div>
  <div class="breadcrumb js-zeroclipboard-target">
    <span class="repo-root js-repo-root"><span class="js-path-segment"><a href="/MehrabGBari/PSI"><span>PSI</span></a></span></span><span class="separator">/</span><strong class="final-path">README.md</strong>
  </div>
</div>

<include-fragment class="commit-tease" src="/MehrabGBari/PSI/contributors/master/README.md">
  <div>
    Fetching contributors&hellip;
  </div>

  <div class="commit-tease-contributors">
    <img alt="" class="loader-loading float-left" height="16" src="https://assets-cdn.github.com/images/spinners/octocat-spinner-32-EAF2F5.gif" width="16" />
    <span class="loader-error">Cannot retrieve contributors at this time</span>
  </div>
</include-fragment>

<div class="file">
  <div class="file-header">
  <div class="file-actions">

    <div class="BtnGroup">
      <a href="/MehrabGBari/PSI/raw/master/README.md" class="btn btn-sm BtnGroup-item" id="raw-url">Raw</a>
        <a href="/MehrabGBari/PSI/blame/master/README.md" class="btn btn-sm js-update-url-with-hash BtnGroup-item">Blame</a>
      <a href="/MehrabGBari/PSI/commits/master/README.md" class="btn btn-sm BtnGroup-item" rel="nofollow">History</a>
    </div>

        <a class="btn-octicon tooltipped tooltipped-nw"
           href="https://windows.github.com"
           aria-label="Open this file in GitHub Desktop"
           data-ga-click="Repository, open with desktop, type:windows">
            <svg aria-hidden="true" class="octicon octicon-device-desktop" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M15 2H1c-.55 0-1 .45-1 1v9c0 .55.45 1 1 1h5.34c-.25.61-.86 1.39-2.34 2h8c-1.48-.61-2.09-1.39-2.34-2H15c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1zm0 9H1V3h14v8z"/></svg>
        </a>

        <button type="button" class="btn-octicon disabled tooltipped tooltipped-nw"
          aria-label="You must be signed in to make or propose changes">
          <svg aria-hidden="true" class="octicon octicon-pencil" height="16" version="1.1" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M0 12v3h3l8-8-3-3-8 8zm3 2H1v-2h1v1h1v1zm10.3-9.3L12 6 9 3l1.3-1.3a.996.996 0 0 1 1.41 0l1.59 1.59c.39.39.39 1.02 0 1.41z"/></svg>
        </button>
        <button type="button" class="btn-octicon btn-octicon-danger disabled tooltipped tooltipped-nw"
          aria-label="You must be signed in to make or propose changes">
          <svg aria-hidden="true" class="octicon octicon-trashcan" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M11 2H9c0-.55-.45-1-1-1H5c-.55 0-1 .45-1 1H2c-.55 0-1 .45-1 1v1c0 .55.45 1 1 1v9c0 .55.45 1 1 1h7c.55 0 1-.45 1-1V5c.55 0 1-.45 1-1V3c0-.55-.45-1-1-1zm-1 12H3V5h1v8h1V5h1v8h1V5h1v8h1V5h1v9zm1-10H2V3h9v1z"/></svg>
        </button>
  </div>

  <div class="file-info">
      109 lines (71 sloc)
      <span class="file-info-divider"></span>
    12.2 KB
  </div>
</div>

  
  <div id="readme" class="readme blob instapaper_body">
    <article class="markdown-body entry-content" itemprop="text"><h1><a id="user-content-positive-synergy-index-psi" class="anchor" href="#positive-synergy-index-psi" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Positive Synergy Index (PSI)</h1>

<p>Feature selection method for gene expression microarray data.
Microarray gene expression data from 22 different tumor type were used for test PSI algorithm.</p>

<p>Please see <a href="http://compgenomics.utsa.edu/zgroup/PSI/download.html">http://compgenomics.utsa.edu/zgroup/PSI/download.html</a> to download the interested data set.</p>

<h3><a id="user-content-related-papers" class="anchor" href="#related-papers" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Related paper(s):</h3>

<p>[1]. Bari, M. G., Salekin, S. and Zhang, J. (2016), 
A Robust and Efficient Feature Selection Algorithm for Microarray Data. Mol. Inf.. doi:10.1002/minf.201600099</p>

<p>[2]. Salekin, S., Bari, M. G., Raphael, I., Forsthuber, T. G., &amp; Zhang, J. M. (2016, February). Early disease correlated protein detection using early response index (ERI). In 2016 IEEE-EMBS International Conference on Biomedical and Health Informatics (BHI) (pp. 569-572). IEEE.</p>

<p>[3]. ....</p>

<pre><code>                                                 ****
                                             ************
                                  ************************************
                                  ************************************               
                                             ************                                  
                                                 ****
</code></pre>

<h2><a id="user-content-introduction" class="anchor" href="#introduction" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Introduction</h2>

<p>We developed a new feature selection method, PSI, which based on the synergistic effects caused
when the features combined to each other and are used as input of a classifier. The idea is that, irrelevant
features, while combining other features are more likely to contribute negatively to classifier performance
in train set. On the other hand, when informative genes are used in panels, the synergistic effect of them
cause the classifier better learning, and this leads to better classification results. Our exprements show that,
ranking features based on their performance when they are combined, could provide a good feature set to
train a model to classify the unseen test set.</p>

<h2><a id="user-content-svm-vs-lr-in-developing-psi" class="anchor" href="#svm-vs-lr-in-developing-psi" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>SVM vs LR in developing PSI</h2>

<p>In the PSI algorithm, to compute the synergy scores of features, the individual and paired accuracy of preselected N features are needed, and it uses SVM classifier to do so. Here, we want to show the benefit of using SVM for the computation of accuracy of a feature or feature pairs, <em>Acc(F_i)</em> and <em>Acc(F_i, F_j)</em>, respectively.</p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486274/0ea5477a-cb77-11e6-90d4-c72e0aea755d.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486274/0ea5477a-cb77-11e6-90d4-c72e0aea755d.png" alt="figs1" style="max-width:100%;"></a>
<strong>Figure 1:</strong> Comparing PSI accuracy performance and time complicity using SVM and LR, a) Average accuracy over 22 datasets b) Boxplot of the average of averages running time</p>

<p>As SVM scales with number of samples and Logistic Regression (LR) with number of features, this should be preferable for large datasets. It is a good practice to use LR instead of SVM in PSI body to see whether on not LR would be more efficient. The Figure 1 shows the average accuracy and run time of PSI when using LR and SVM over all the datasets. In both cases the N=300, <em>alpha</em> = 0.29 and 10-fold cross validation scheme was used. When N=300, PSI is about 5 times faster than, when it uses LR instead of SVM. However, it causes very poor accuracy results as shown in the Figure Figure 1_a. Note that, we proposed N to be equal to 100 in the final PSI while using SVM, which is at lease 7 times faster than when N=300 and still has the same good average accuracies. The effect of N on PSI performance is represented in the next section.
Above results, convincing us to use SVM in PSI structure, and since we are using the original SVM function in MATLAB without any parameter setting, subsequently PSI uses SVM with the benefit of not having to select a cost parameters. </p>

<h2><a id="user-content-the-effect-of--n-on-average-performance" class="anchor" href="#the-effect-of--n-on-average-performance" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The effect of  N on average performance</h2>

<p>To find the best N for PSI, we examined the effect of N on the PSI's average performance and computational time. Since, bigger N makes PSI computationally expensive, the question is that how much a big N would increase the accuracy? As shown in the Figure Figure 2, we compared PSI's average running time and accuracy for N equal to 100, 200 and 300. The mixing parameter, <em>alpha</em>, was set to 0.29 for all cases and 10-fold outer and 5-fold inner cross validation were used. </p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486275/0ea56f66-cb77-11e6-9acf-a7d81a2eab10.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486275/0ea56f66-cb77-11e6-9acf-a7d81a2eab10.png" alt="figs2" style="max-width:100%;"></a>
<strong>Figure 2:</strong> Comparing the The effect of  N on average performance, a) Average accuracies, b) Average running time</p>

<p>The number of SVM classifiers need by PSI is equal to 10 * 5 * (N(N-1)/2) which is a function of N. The number 10 and 5 show the number of outer and inner cross validation. The number of SVM classifiers for N=100, 200 and 300 are 247500, 995000 and 2242500 for each dataset respectively. Although, PSI was developed using parallel processing technique, by increasing N, running time increases rapidly without any improvement over PSI's results when N is 100.  </p>

<p>Also for the datasets "Colon" and "CNS", which have 2000 and 7129 genes, we used all features to calculating the synergy scores. The number of classifiers are 99950000 and 1270400000 and the running time were 33 and 285 hours for "Colon" and "CNS" respectively, and in the both of the cases the accuracies were below than those of when N was equal to 100 (in average 2% less). </p>

<h2><a id="user-content-the-effect-of--alpha-on-average-performance" class="anchor" href="#the-effect-of--alpha-on-average-performance" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The effect of  <em>alpha</em> on average performance</h2>

<p>The ‘mixing’ parameter<em>alpha</em>, is a parameter of PSI along with N the number of features considered (Set to 100). It is selected to be 0.29 based on the average of the <em>alpha</em> cause best accuracy for each dataset in training step. 
Figure 3 shows the effect of changing <em>alpha</em> on PSI's average accuracy on datasets "CNS'', "GCM'', "GSE27854'' and "Prostate4'', when PSI applies on unseen test sets. PSI average accuracy in most of 22 cases show a peak when <em>alpha</em> is around 0.16 like the cases "GCM'' and "Prostate4''. Because <em>alpha</em>=0.16 was seen in the outmost loop of the double CV scheme, then PSI may have an unfair advantage over the other methods, then we report the results by using <em>alpha</em> = 0.29.</p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486273/0ea53190-cb77-11e6-86f1-9672abd28c08.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486273/0ea53190-cb77-11e6-86f1-9672abd28c08.png" alt="figs3" style="max-width:100%;"></a>
<strong>Figure 3:</strong> The effect of  <em>alpha</em> on average accuracy of PSI using 1 up to 50 top features in dataset, a) CNS, b) GCM, c) GSE27854, d) Prostate3</p>

<h2><a id="user-content-knn-classifier" class="anchor" href="#knn-classifier" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>KNN classifier</h2>

<p>Each of the 14 feature selection methods in this study, were applied to all 22 datasets and the 50 features reported by each method, used to train the SVM classifier. PSI shows best average accuracy over all other method while having 4th less computational times. PSI, also uses SVM to calculating the synergy scores. To make sure that PSI good performance is not because of classifier effect, we used top 50 features reported by all methods to train K-Nearest Neighbor (KNN) classifier, and then the trained KNN classifier were applied on test sets and the accuracy of each method were recorded. Figure Figure4} shows the average results over 22 datasets when top 1, 2, 10, 15, 25 and 50 features were used.
The parameter K for KNN classifier is a user-defined positive constant and a common used choice to assign a value for K is equal to the square root of the number of samples. It is a good starting point and given a dataset, we rounded its square root of the number of samples to the nearest odd number <em>(2 * round(sqrt{S-1}/2)+1)</em>, and that was selected as the final K.
As shown in the Figure 4, PSI has the best accuracies in general like what we can see when the SVM used as final classifier. SAM method as explained in the main paper, when the number of features are small, has the highest average accuracy but as the number of features used are increased, the synergistic based methods, PSI and k-TSP could provide more informative features to the classifier and cause better performances. However, this is not k-TSP in reality, because it is proposed as classifier, which is based on majority of voting of negatively correlated pairs. It has been shown that when the features extracted by k-TSP used to train SVM classifier, the achieved performance is pretty better than of k-TSP as classifier. Also, it shall be noted that the k-TSP is computationally is much more expensive the PSI. Our results show that, PSI in average is 35 times faster than k-TSP.</p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486278/0eacd2b0-cb77-11e6-9e7d-1aef0b24ea0c.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486278/0eacd2b0-cb77-11e6-9e7d-1aef0b24ea0c.png" alt="figs4" style="max-width:100%;"></a>
<strong>Figure 4:</strong> KNN classifier average 10-fold cross validation accuracy over 22 datasets using 1 in (a), 2 in (b), 10 in (c), 15 in (d), 25 in (e) and 50 in (f), features.</p>

<p>Also, Figure 5 shows box-plot of average accuracies achieved by using 1, 2, ...,50 top features when SVM and KNN used as final classifiers. The 14 methods ranked by the median of the average accuracies they produced and it is clear in both case PSI has the best results. There are slight changes in other method's rank when different classifiers are used and these spares changes are acceptable due to internal characteristics of different classifiers. PSI, k-TSP and SAM are the three best method using SVM or KNN, and CI, the other synergistic method is in the 4th rank when SVM was used. The k-TSP has received those good performance because in this exprement it uses SVM and KNN as classifiers and previous studies have shown than when k-TSP uses it own internal classifier, its performance will be lower than what were represented in this research, furthermore its time complexity is much more than PSI, since it uses combinations of two all features, while PSI needs to evaluate those of only N=100 preselected features for the same dataset.             </p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486370/29b9a75c-cb79-11e6-80fc-0365a96ae6ac.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486370/29b9a75c-cb79-11e6-80fc-0365a96ae6ac.png" alt="figs5" style="max-width:100%;"></a>
<strong>Figure 5:</strong> Boxplot of 10-fold cross validation accuracy results using top 10 features (SVM).</p>

<h2><a id="user-content-wilcoxon-test-to-examining-the-significance-in-accuracy-gain" class="anchor" href="#wilcoxon-test-to-examining-the-significance-in-accuracy-gain" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wilcoxon test to examining the significance in accuracy gain</h2>

<p>Figure 5 shows the box plot of accuracy results provided by 14 methods using top 10 features on 22 datasets, which are represented in the Table 3 in the main paper [1]. We want to evaluate the significance of the gain in accuracy listed in that Table. Wilcoxon test, is appropriate for evaluating the median difference in outcomes of two populations which are paired or dependent. The null hypothesis, H_0, which indicates that the median of changes in accuracy comparing PSI and all others is equal 0. Table 1 shows the alternative hypothesis H_1 as well as test statistic, confidence interval and p-value when PSI's results compared to those of other methods. In all the comparisons, H_0 is rejected by Wilcoxon test at significance level equal to 0.05, and the conclusion is that data available in the Table 3 in the main paper, provide sufficient evidence to conclude that PSI is grater than those of each other methods at significance level of 0.05.   </p>

<p><strong>Table 1:</strong> Wilcoxon signed rank test with continuity correction</p>

<table><thead>
<tr>
<th><em>H_1</em></th>
<th>95% confidence interval</th>
<th>(pseudo)median</th>
<th>Test statistic</th>
<th>p-value</th>
<th>-log2(p-value)</th>
</tr>
</thead><tbody>
<tr>
<td>PSI v.s. IA</td>
<td>True</td>
<td>(1.4 , 9.1)</td>
<td>4.73</td>
<td>198</td>
<td>0.0043</td>
</tr>
<tr>
<td>PSI v.s. k-TSP</td>
<td>True</td>
<td>(-0.5 , 2.6)</td>
<td>1.39</td>
<td>157</td>
<td>0.15</td>
</tr>
<tr>
<td>PSI v.s. SVM-R</td>
<td>True</td>
<td>(0.1 , 5.6)</td>
<td>2.64</td>
<td>176</td>
<td>0.037</td>
</tr>
<tr>
<td>PSI v.s. mRMR</td>
<td>True</td>
<td>(14.5 , 25.3)</td>
<td>19.57</td>
<td>252</td>
<td>4.93e-05</td>
</tr>
<tr>
<td>PSI v.s. SAM</td>
<td>True</td>
<td>(-0.9 , 2.5)</td>
<td>0.84</td>
<td>140</td>
<td>0.40</td>
</tr>
<tr>
<td>PSI v.s. IG</td>
<td>True</td>
<td>(-1 , 2.1)</td>
<td>0.90</td>
<td>151</td>
<td>0.22</td>
</tr>
<tr>
<td>PSI v.s. oneR</td>
<td>True</td>
<td>(9.1 , 21.4)</td>
<td>14.9</td>
<td>240</td>
<td>4.19e-05</td>
</tr>
<tr>
<td>PSI v.s. RF</td>
<td>True</td>
<td>(0.7 , 5.8)</td>
<td>3.27</td>
<td>188</td>
<td>0.012</td>
</tr>
<tr>
<td>PSI v.s. GR</td>
<td>True</td>
<td>(0.1 , 5.5)</td>
<td>2.70</td>
<td>179</td>
<td>0.028</td>
</tr>
<tr>
<td>PSI v.s. CS</td>
<td>True</td>
<td>(-1.1 , 2.9)</td>
<td>1.12</td>
<td>147</td>
<td>0.28</td>
</tr>
<tr>
<td>PSI v.s. SU</td>
<td>True</td>
<td>(0.01 , 2.4)</td>
<td>1.40</td>
<td>173</td>
<td>0.046</td>
</tr>
<tr>
<td>PSI v.s. CFS</td>
<td>True</td>
<td>(3.1 , 9.1)</td>
<td>6.39</td>
<td>206</td>
<td>0.0017</td>
</tr>
<tr>
<td>PSI v.s. CI</td>
<td>True</td>
<td>(-1.3 , 2.5)</td>
<td>0.44</td>
<td>150</td>
<td>0.45</td>
</tr>
</tbody></table>

<h2><a id="user-content-svm-knn-and-glm-classifiers-comparison" class="anchor" href="#svm-knn-and-glm-classifiers-comparison" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>SVM, KNN and GLM classifiers comparison</h2>

<p>Beside SVM and KNN classifiers we also used GLM classifier for comparison of 14 feature selection approaches. Figure 6 shows the boxplots of SVM,KNN, and GLM classifiers average performance over using 1 to 50 top features reported by all 14 methods on all 22 data sets in 10-fold cross-validation approach.  </p>

<p><a href="https://cloud.githubusercontent.com/assets/12883478/21486277/0eabf7fa-cb77-11e6-9da5-85ac78882099.png" target="_blank"><img src="https://cloud.githubusercontent.com/assets/12883478/21486277/0eabf7fa-cb77-11e6-9da5-85ac78882099.png" alt="figs6" style="max-width:100%;"></a>
<strong>Figure 6:</strong> Boxplot of SVM,KNN, and GLM classifiers performance using 1 to 50 top features reported by all 14 methods.</p>
</article>
  </div>

</div>

<button type="button" data-facebox="#jump-to-line" data-facebox-class="linejump" data-hotkey="l" class="d-none">Jump to Line</button>
<div id="jump-to-line" style="display:none">
  <!-- '"` --><!-- </textarea></xmp> --></option></form><form accept-charset="UTF-8" action="" class="js-jump-to-line-form" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
    <input class="form-control linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" aria-label="Jump to line" autofocus>
    <button type="submit" class="btn">Go</button>
</form></div>

  </div>
  <div class="modal-backdrop js-touch-events"></div>
</div>


    </div>
  </div>

    </div>

        <div class="container site-footer-container">
  <div class="site-footer" role="contentinfo">
    <ul class="site-footer-links float-right">
        <li><a href="https://github.com/contact" data-ga-click="Footer, go to contact, text:contact">Contact GitHub</a></li>
      <li><a href="https://developer.github.com" data-ga-click="Footer, go to api, text:api">API</a></li>
      <li><a href="https://training.github.com" data-ga-click="Footer, go to training, text:training">Training</a></li>
      <li><a href="https://shop.github.com" data-ga-click="Footer, go to shop, text:shop">Shop</a></li>
        <li><a href="https://github.com/blog" data-ga-click="Footer, go to blog, text:blog">Blog</a></li>
        <li><a href="https://github.com/about" data-ga-click="Footer, go to about, text:about">About</a></li>

    </ul>

    <a href="https://github.com" aria-label="Homepage" class="site-footer-mark" title="GitHub">
      <svg aria-hidden="true" class="octicon octicon-mark-github" height="24" version="1.1" viewBox="0 0 16 16" width="24"><path fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"/></svg>
</a>
    <ul class="site-footer-links">
      <li>&copy; 2017 <span title="0.16177s from github-fe155-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="https://github.com/site/terms" data-ga-click="Footer, go to terms, text:terms">Terms</a></li>
        <li><a href="https://github.com/site/privacy" data-ga-click="Footer, go to privacy, text:privacy">Privacy</a></li>
        <li><a href="https://github.com/security" data-ga-click="Footer, go to security, text:security">Security</a></li>
        <li><a href="https://status.github.com/" data-ga-click="Footer, go to status, text:status">Status</a></li>
        <li><a href="https://help.github.com" data-ga-click="Footer, go to help, text:help">Help</a></li>
    </ul>
  </div>
</div>



    

    <div id="ajax-error-message" class="ajax-error-message flash flash-error">
      <svg aria-hidden="true" class="octicon octicon-alert" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M8.865 1.52c-.18-.31-.51-.5-.87-.5s-.69.19-.87.5L.275 13.5c-.18.31-.18.69 0 1 .19.31.52.5.87.5h13.7c.36 0 .69-.19.86-.5.17-.31.18-.69.01-1L8.865 1.52zM8.995 13h-2v-2h2v2zm0-3h-2V6h2v4z"/></svg>
      <button type="button" class="flash-close js-flash-close js-ajax-error-dismiss" aria-label="Dismiss error">
        <svg aria-hidden="true" class="octicon octicon-x" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"/></svg>
      </button>
      You can't perform that action at this time.
    </div>


      
      <script crossorigin="anonymous" integrity="sha256-uzmufYSNQNbwHmc1XigpZPVPo5E3wOzJ/E7Dfn1GlQg=" src="https://assets-cdn.github.com/assets/frameworks-bb39ae7d848d40d6f01e67355e282964f54fa39137c0ecc9fc4ec37e7d469508.js"></script>
      <script async="async" crossorigin="anonymous" integrity="sha256-id/Y4xFDEtS/MbiBY7dj6y3+4hvA+gF+Pu0J87hfhDU=" src="https://assets-cdn.github.com/assets/github-89dfd8e3114312d4bf31b88163b763eb2dfee21bc0fa017e3eed09f3b85f8435.js"></script>
      
      
      
      
    <div class="js-stale-session-flash stale-session-flash flash flash-warn flash-banner d-none">
      <svg aria-hidden="true" class="octicon octicon-alert" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M8.865 1.52c-.18-.31-.51-.5-.87-.5s-.69.19-.87.5L.275 13.5c-.18.31-.18.69 0 1 .19.31.52.5.87.5h13.7c.36 0 .69-.19.86-.5.17-.31.18-.69.01-1L8.865 1.52zM8.995 13h-2v-2h2v2zm0-3h-2V6h2v4z"/></svg>
      <span class="signed-in-tab-flash">You signed in with another tab or window. <a href="">Reload</a> to refresh your session.</span>
      <span class="signed-out-tab-flash">You signed out in another tab or window. <a href="">Reload</a> to refresh your session.</span>
    </div>
    <div class="facebox" id="facebox" style="display:none;">
  <div class="facebox-popup">
    <div class="facebox-content" role="dialog" aria-labelledby="facebox-header" aria-describedby="facebox-description">
    </div>
    <button type="button" class="facebox-close js-facebox-close" aria-label="Close modal">
      <svg aria-hidden="true" class="octicon octicon-x" height="16" version="1.1" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M7.48 8l3.75 3.75-1.48 1.48L6 9.48l-3.75 3.75-1.48-1.48L4.52 8 .77 4.25l1.48-1.48L6 6.52l3.75-3.75 1.48 1.48z"/></svg>
    </button>
  </div>
</div>

  </body>
</html>

=======
  
>>>>>>> origin/master

%% =========================================================
% This is main code of PSI method written by: Mehrab Ghanat Bari. 
%Contact at:  <nzd004@my.utsa.edu> and <m.ghanatbari@gmail.com>
%The CopyRight is reserved by the author.
%Last modification: Sep 22, 2014
%More information can be found in the following papers.
%[1] 
%Bari, M. G., Salekin, S. and Zhang, J. (2016), 
%A Robust and Efficient Feature Selection Algorithm for Microarray Data. Mol. Inf.. doi:10.1002/minf.201600099
%[2]
%Salekin, Sirajul, Mehrab Ghanat Bari, Itay Raphael, Thomas G. Forsthuber, and Jianqiu Michelle Zhang. 
%"Early disease correlated protein detection using early response index (ERI)." 
%In 2016 IEEE-EMBS International Conference on Biomedical and Health Informatics (BHI), pp. 569-572. IEEE, 2016.
%========================================================
%% Load file
close all
clear all
clc
addpath % ~Code folder. i.e. C:\Users\nzd004\Desktop\MyDeask\Mehrab\FeatureSelection\Code\MainCodes
addpath % ~Data folder. i.e. C:\Users\nzd004\Desktop\MyDeask\Mehrab\FeatureSelection\Code\Data
load ('SRBCT_analysis.mat');

%% --------------------------- Training Part ------------------------------

for idx = 1%: number of runs 
    Data = DATA;
    SetParam2
    tic;[Data.Folds_c1,Data.Folds_c2] = fold_out(Data);Data.time.Folds = toc
    
    [Data.fold_TrainTest] = fold_in(Data); % dividind 90% to 50% training and 50% testing
    tic;Data.geneRank_ttest = ttest_fold (Data);Data.time.ttest = toc;
    %% -------------------- finding stable features ---------------------------
    tic;[Data.RepeatedGenes] = findrepeatedfeatures_ttest (Data.geneRank_ttest,Data.N);Data.time.findrepeatedfeatures = toc ;
    %% ----------------------------- Indvidual Accuracy SVM--------------------
    tic;[Data.IndAccSVMtrain] = IndAcc_svmtrain(Data);Data.time.IndAcc = toc;  
    %% ---------------------- Combinations of 2 Accuracy SVM ------------------
    tic;Comb2Acc_svmtrain(Data);Data.time.Comb2 = toc;
    ConCat
    save(['Data',num2str(idx)], 'Data')
end
%% %% --------------------- Computting ERI scores -----------------------
 % load (['Data',num2str(idx)])
[Data.ERI] = ERI(Data);




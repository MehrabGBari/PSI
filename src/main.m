%% =========================================================
% This is main code of PSI method written by: Mehrab Ghanat. 
%Contact at:  <nzd004@my.utsa.edu> and <m.ghanatbari@gmail.com>
%The CopyRight is reserved by the author.
%Last modification: Sep 22, 2014
%More information can be found in the following papers.
%[1] 
%Salekin, Sirajul, Mehrab Ghanat Bari, Itay Raphael, Thomas G. Forsthuber, and Jianqiu Michelle Zhang. 
%"Early disease correlated protein detection using early response index (ERI)." 
%In 2016 IEEE-EMBS International Conference on Biomedical and Health Informatics (BHI), pp. 569-572. IEEE, 2016.
%[2]
% ...
%========================================================
%% Load file
close all
clear all
clc
addpath % ~Code folder. i.e. C:\Users\nzd004\Desktop\MyDeask\Mehrab\FeatureSelection\Code\MainCodes
addpath % ~Data folder. i.e. C:\Users\nzd004\Desktop\MyDeask\Mehrab\FeatureSelection\Code\Data
load ('SRBCT_analysis.mat');
%% --------------------------- Training Part ------------------------------
for idx = 1:10  
    Data = DATA;
    Data.class1 = Data.class1(:,Data.labels_permc1{idx});
    Data.class2 = Data.class2(:,Data.labels_permc2{idx});
    SetParam
    tic;[Data.Folds_c1,Data.Folds_c2] = folds_4CV (Data);Data.time.Folds = toc;
    Data.Folds_c1.test{10} = [Data.class1(:,28:29) Data.class1(:,1)];
    Data.Folds_c1.train{10} = Data.class1(:,2:27);
    Data.Folds_c2.test = Data.Folds_c2.test(1,1:10);Data.Folds_c2.train = Data.Folds_c2.train(1,1:10);
    
    [Data.fold_TrainTest] = fold_2_tarintest(Data); % dividind 90% to 50% training and 50% testing
    tic;Data.geneRank_ttest = ttest_fold (Data);Data.time.ttest = toc;
    %% -------------------- finding stable features ---------------------------
    Numbfeatures = [];%300;% [];% 300 ; [] if we want all unique features
    tic;[Data.RepeatedGenes] = findrepeatedfeatures_ttest (Data.geneRank_ttest,Numbfeatures);Data.time.findrepeatedfeatures = toc ;
    %% ----------------------------- Indvidual Accuracy SVM--------------------
    tic;[Data.IndAccSVMtrain] = IndAcc_svmtrain(Data);Data.time.IndAcc = toc;  
    %% ---------------------- Combinations of 2 Accuracy SVM ------------------
    tic;Comb2Acc_svmtrain(Data);Data.time.Comb2 = toc;
    ConCat
    save(['Run',num2str(idx)], 'Data')
    
end
%% --------------------- Computting PS scores Com2------------------------
for idx = 1:10
    idx
    load (['Run',num2str(idx)])
    PSIw = 0:100;
    tic;[Data.PSIandIndAcc] = PSIs(Data,PSIw);toc;
    tic; Data.finalAccresults = finalAcc(Data);Data.time.finalAcc = toc;
    MaxAcc = zeros(1,102);
    for idy = 1:102
        MaxAcc(1,idy)=max(Data.finalAccresults{idy});
    end
    [v(idx),p(idx)]= max(MaxAcc)
    save(['Run',num2str(idx)], 'Data')
end

%% calculate top PSI
datafortable
%% --------------------- final acc using 5 10 15 .... fatures and PSI percent is 20% ------------------------

finalAcc_psi20per = zeros(10,10);
for idx = 1:10
    idx
    load (['Run',num2str(idx)])
    tic; finalAcc_psi20per(idx,:) = finalAcc_psi20percent(Data);Data.time.finalAcc = toc;
end

finalAcc_psi20per_10run = mean(finalAcc_psi20per)
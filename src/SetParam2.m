% This is where you can set the parameters, N, k for k-fold cross validation and etc. 

% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

Data.fold_out = 10;% k in k-fold cross validation
Data.fold_int = 2;% k for inner k-fold cross validation.  Traing set, further is divided to internal train and test.
Data.train_percent = (Data.fold_out - 1)/Data.fold_out;% percent of training data. (k-1)/k
Data.ttestPer = 0.80;% percent in tarining data used for ttest in the filtering step
Data.num_desired_features = 500;% Top features with higher p-value are kept in each itiration
Data.NumTrainReapet = 30;
Data.nchoos = 2;% number of combinations of per-selected features.
Data.N = 100;%[];% N pre-selected features; [] if all unique features after filtering step are needed.
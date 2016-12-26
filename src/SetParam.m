% This is where you can set the parameters, N, k for k-fold cross validation and etc. 

% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

Data.train_percent = 0.9;% percent of training data
Data.ttestPer = 0.80;% percent in tarining data used for ttest
Data.num_desired_features = 500;
Data.NumTrainReapet = 30;
Data.fold = 10;%10;% 0.9 of original data used for training part
Data.fold_int = 2;% 0.9 of data selected for traing, further divided to internal train and test
Data.nchoos = 2;% number of combinations of small selected features
Data.c1_sizeTrain = floor(Data.train_percent*Data.c1_size);
Data.c2_sizeTrain = floor(Data.train_percent*Data.c2_size)+1;

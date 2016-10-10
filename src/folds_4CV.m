function [Folds_C1,Folds_C2] = folds_4CV (InData)
% Summary; this function will divide data to k tarin and test sets (k from k_fold).
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
c1_sizeTest = InData.c1_size - InData.c1_sizeTrain;
c2_sizeTest = InData.c2_size - InData.c2_sizeTrain;

Folds_C1 = [];
for i = 1:floor(InData.c1_size/c1_sizeTest)
    idxTest = 1+(i-1)*c1_sizeTest :i*c1_sizeTest;
    idxTrain = setdiff(1:InData.c1_size, idxTest);
    test = InData.class1(:,idxTest);
    train = InData.class1(:,idxTrain);
    
    Folds_C1.test{i} = test;
    Folds_C1.train{i} = train;
    
end

Folds_C2 = [];
for i = 1:floor(InData.c2_size/c2_sizeTest)
    idxTest = 1+(i-1)*c2_sizeTest :i*c2_sizeTest;
    idxTrain = setdiff(1:InData.c2_size, idxTest);
    test = InData.class2(:,idxTest);
    train = InData.class2(:,idxTrain);
    
    Folds_C2.test{i} = test;
    Folds_C2.train{i} = train;
    
end

end




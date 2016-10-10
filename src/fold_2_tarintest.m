function [fold] = fold_2_tarintest(DataSet1)
% To specifiying the train and test folds.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

Ia = floor(DataSet1.c1_sizeTrain/DataSet1.fold_int);
Ib = floor(DataSet1.c2_sizeTrain/DataSet1.fold_int);

for crossValid = 1:DataSet1.fold
    
    for f = 1: DataSet1.fold_int
        
        IdxTest1  = (f-1)*Ia+1:f*Ia;
        IdxTrain1 = setdiff(1:DataSet1.c1_sizeTrain,IdxTest1);
        
        IdxTest2  = (f-1)*Ib+1:f*Ib;
        IdxTrain2 = setdiff(1:DataSet1.c2_sizeTrain,IdxTest2);
        
        fold{crossValid}.test{f} = [DataSet1.Folds_c1.train{crossValid}(:,IdxTest1) ...
            DataSet1.Folds_c2.train{crossValid}(:,IdxTest2)];
        
        fold{crossValid}.train{f} = [DataSet1.Folds_c1.train{crossValid}(:,IdxTrain1) ...
            DataSet1.Folds_c2.train{crossValid}(:,IdxTrain2)];
        
        fold1Label_test = [ones(1,length(IdxTest1)) 2*ones(1,length(IdxTest2))];
        fold1Label_train = [ones(1,length(IdxTrain1)) 2*ones(1,length(IdxTrain2))];
        
        fold{crossValid}.test{f}(end+1,:) = fold1Label_test;
        fold{crossValid}.train{f}(end+1,:) = fold1Label_train;
    end
end


end


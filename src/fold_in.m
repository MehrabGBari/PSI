function [fold] = fold_in(dat)
% To specifiying the train and test folds.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

for idx = 1:dat.fold_out
    tmp1 = dat.Folds_c1.train{idx};
    tmp2 = dat.Folds_c2.train{idx};
    
    F1 = testtrain(tmp1,dat.fold_int);
    F2 = testtrain(tmp2,dat.fold_int);
    
    for idy = 1: dat.fold_int
        fold{idx}.test{idy} = [F1.test{idy} F2.test{idy}];
        fold{idx}.train{idy} = [F1.train{idy} F2.train{idy}];
        
        fold1Label_test = [ones(1,size(F1.test{idy},2)) 2*ones(1,size(F2.test{idy},2))];
        fold1Label_train = [ones(1,size(F1.train{idy},2)) 2*ones(1,size(F2.train{idy},2))];
        
        fold{idx}.test{idy}(end+1,:) = fold1Label_test;
        fold{idx}.train{idy}(end+1,:) = fold1Label_train;
    end
end
end


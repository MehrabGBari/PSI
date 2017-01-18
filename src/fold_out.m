function [Folds_C1,Folds_C2] = fold_out (dat)
% Summary; this function will divide data to k tarin and test sets (k from k_fold).
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

Folds_C1 = testtrain(dat.class1,dat.fold_out);
Folds_C2 = testtrain(dat.class2,dat.fold_out);

end



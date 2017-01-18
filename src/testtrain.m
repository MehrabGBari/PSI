function [ f ] = testtrain( mat,kfold )
% Divides input data, mat, to the k train and test sets.
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
k = (1:kfold)';
S = size(mat,2);
id=repmat(k,1,S);
id=id(:)';
id=id(1:S);
id=id(randsample(S,S));
samples=(1:S)';
f = [];
for i=1:length(k)
    idxTest = samples(id == i);
    idxTrain = setdiff(1:S,idxTest);
    test = mat(:,idxTest);
    train = mat(:,idxTrain);
    f.test{i} = test;
    f.train{i} = train;
end
end




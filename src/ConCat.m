% the perfomances of all N(N-1)/2 pairs in each fold 
% are saved in working space and at the end all results 
% are concatinated using this function.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Data.Comb2Acc = cell(1,Data.fold_out);
for crossValid = 1:Data.fold_out
    filename = ['Comb2_fold_',num2str(crossValid),'.mat'];
    load (filename)
    Data.Comb2Acc{crossValid} = Comb2;
    delete (filename)
end


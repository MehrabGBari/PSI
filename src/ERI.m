function [Output] = ERI(dat)
%Summary: After having indvidual accuracy of all pais,
% this function computes the PSI scores for all genes
% which then goes to add to indvidual accuracy of those genes. 
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Output =cell(1,dat.fold_out);%[];

for idx = 1:dat.fold_out
    [nrow,ncol] = size(dat.Comb2Acc{idx});
    Comb2Acc = zeros(nrow,ncol+4);
    Comb2Acc(:,1:ncol) = dat.Comb2Acc{idx};
    IndAcc = dat.IndAccSVMtrain{idx}(:,[1 end]);
    IndAcc = sortrows(IndAcc,1);
    UniqComb2 = unique([Comb2Acc(:,1);Comb2Acc(:,2)]);
    PSIscores = zeros(length(UniqComb2),3);
    idCol1 = cell(1,length(UniqComb2));
    idCol2 = cell(1,length(UniqComb2));
    len_ucom2 = length(UniqComb2);
    
    for idy = 1:len_ucom2
        idCol1{idy} = (Comb2Acc(:,1) == UniqComb2(idy,1));
        idCol2{idy} = (Comb2Acc(:,2) == UniqComb2(idy,1));
        tempIndAcc = IndAcc(IndAcc(:,1) == UniqComb2(idy,1),2);
        Comb2Acc(idCol1{idy},ncol+1) = tempIndAcc;
        Comb2Acc(idCol2{idy},ncol+2) = tempIndAcc;
        PSIscores(idy,1) = UniqComb2(idy,1);
        PSIscores(idy,2) = IndAcc(IndAcc(:,1)==UniqComb2(idy,1),2);
    end
    
    MAX = max(Comb2Acc(:,ncol+2),Comb2Acc(:,ncol+1));
    Comb2Acc(:,ncol+3) = (Comb2Acc(:,ncol)) - MAX;
    Comb2Acc(:,ncol+4) = (Comb2Acc(:,ncol))- MAX;
    for idy = 1:len_ucom2
        id1 = Comb2Acc(:,1) == PSIscores(idy,1);
        id2 = Comb2Acc(:,2) == PSIscores(idy,1);
        PSIscores(idy,3) = (sum(Comb2Acc(id1,ncol+3)) + sum(Comb2Acc(id2,ncol+4)))/(len_ucom2);
    end
    
    PSIscores = flip(sortrows(PSIscores,3));
    Output{idx} = PSIscores;
end
end


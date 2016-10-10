function [Output] = PSIs(InData,Psw)
%Summary: After having indvidual accuracy of all pais,
% this function computes the PSI scores for all genes
% which then goes to add to indvidual accuracy of those genes. 
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Output =[];

for idx = 1:InData.fold
    
    [nrow,ncol] = size(InData.Comb2Acc{idx});
    Comb2Acc = zeros(nrow,ncol+4);
    Comb2Acc(:,1:ncol) = InData.Comb2Acc{idx};
    IndAcc = InData.IndAccSVMtrain{idx}(:,[1 end]);
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
    
%     %%MAX = max(Comb2Acc(:,ncol+1),Comb2Acc(:,ncol+2));
%     Comb2Acc(:,ncol+3) = Comb2Acc(:,ncol) - Comb2Acc(:,ncol+2);
%     Comb2Acc(:,ncol+4) = Comb2Acc(:,ncol) - Comb2Acc(:,ncol+1);
    
%     MAX = (Comb2Acc(:,ncol+2));
%     Comb2Acc(:,ncol+3) = (Comb2Acc(:,ncol)) - MAX;
%     Comb2Acc(:,ncol+4) = (Comb2Acc(:,ncol))- MAX;
%     
%     for idy = 1:len_ucom2
%         PSIscores(idy,3) = (sum(Comb2Acc(idCol1{idy},ncol+3)) + sum(Comb2Acc(idCol2{idy},ncol+4)))/len_ucom2;
%     end
    
    id = [2,1,3,5,4,6,7]; temp = Comb2Acc(:,id);Comb2Acc = [Comb2Acc;temp];
    MAX = (Comb2Acc(:,ncol+2));
    Comb2Acc(:,ncol+3) = (Comb2Acc(:,ncol)) - MAX;
    Comb2Acc(:,ncol+4) = (Comb2Acc(:,ncol))- MAX;
    for idy = 1:len_ucom2
        id1 = Comb2Acc(:,1) == PSIscores(idy,1);
        id2 = Comb2Acc(:,2) == PSIscores(idy,1);
        PSIscores(idy,3) = (sum(Comb2Acc(id1,ncol+3)) + sum(Comb2Acc(id2,ncol+4)))/(2*len_ucom2);
    end
    
    temp1 = zeros(len_ucom2,length(Psw));
    for t=1:length(Psw)
        maxPSI = Psw(t)/100;
        b_PSI = maxPSI/(max(PSIscores(:,3))-min(PSIscores(:,3)));
        a_PSI = maxPSI - b_PSI*max(PSIscores(:,3));
        b_Acc = 1;a_Acc = 0;
        
        temp = [PSIscores(:,1) (a_PSI+b_PSI*PSIscores(:,3))+(a_Acc+b_Acc*PSIscores(:,2))];
        temp = flip(sortrows(temp,2));
        temp1(:,t) = temp(:,1);
        if t == length(Psw)
            PSIscores = flip(sortrows(PSIscores,3));
            temp1(:,t+1) = PSIscores(:,1);
        end
    end
    Output.PSIscores{idx} = PSIscores;
    Output.AccAndPSI{idx} = temp1;
end
end


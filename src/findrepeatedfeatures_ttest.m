function [MostRepeated] = findrepeatedfeatures_ttest (POSs,NumF)
% This function find more stable genes after 500 ttest within each fold.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
%
% MostRepeated = cell(1,5);
Inicator = 0;
for fold = 1:length(POSs)
    M  = POSs{fold};
    Num = size(M,2);
    M1 = M(:);
    M1 = M1(M1~=0);
    M2 = unique(M1);
    for i = 1:length(M2)
        M2(i,2) = sum(M1 == M2(i,1));
        [xi,yi] = find((M == M2(i,1)));
        if length(xi) == Num
            M2(i,3) = sum(xi);
        else
            for Diff = 1:Num
                Lf(Diff,1) =  nnz(M(:,Diff));
            end
            Lf(yi) = [];
            Lf = Lf +1;
            M2(i,3) = sum(xi)+sum(Lf);
            clear Lf
        end
    end
    
    if isempty(NumF)
        NumF = size(M2,1);
        Inicator = 1;
    end
    
    M2(:,4) = M2(:,2)./M2(:,3);
    M2 = flip(sortrows(M2,4),1);
    MostRepeated{fold} = M2(1:NumF,:);

  
    if Inicator ==1
        NumF = [];
    end
end

end
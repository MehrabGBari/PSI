function Features  = ttest_fold (dat)
% Summary; this function will select significant features based on P_values scores.
% Given a G*S data matrix, N genes where N<<G will be selected. 
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Features = cell(1,dat.fold_out);
for i = 1:dat.fold_out
    CLASS1 = dat.Folds_c1.train{i};
    CLASS2 = dat.Folds_c2.train{i};
    [pvalues,~] = mattest(CLASS1, CLASS2);
    [Sortedpvalues , Generank]=sort(pvalues);
    Sortedpvalues =-log(Sortedpvalues);
    IDP05p = sum(Sortedpvalues >= -log(0.05));
    CLASS1 = CLASS1(Generank(1:IDP05p),:);
    CLASS2 = CLASS2(Generank(1:IDP05p),:);
    genelist = zeros(IDP05p,dat.NumTrainReapet);
    for j =1:dat.NumTrainReapet
        
        Index1 = randperm(size(CLASS1,2),floor(dat.ttestPer*size(CLASS1,2)));
        Index2 = randperm(size(CLASS2,2),floor(dat.ttestPer*size(CLASS2,2)));
        
        % T test
        [pvalues,~] = mattest(CLASS1(:,Index1), CLASS2(:,Index2));
        [temp1 , temp2]=sort(pvalues);
        temp1 =-log(temp1);
        IDP01p = sum(temp1 >= -log(0.01));
        temp3 = Generank(temp2(1:IDP01p));
        genelist(1:length(temp3),j) = temp3;
        
    end
    Features{i} = genelist;
end
end




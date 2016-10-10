function SaveAccSVM = finalAcc(InData)
% final classfication accuracy in k-folds after combining
% accuracy and PSI scores for each gene.
%  
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
nFeat = 50;
SaveAccSVM = cell(1,size(InData.PSIandIndAcc.AccAndPSI{1},2));
for id1 = 1:size(InData.PSIandIndAcc.AccAndPSI{1},2)
   
    for idx = 1: InData.fold
        finalfeatures = InData.PSIandIndAcc.AccAndPSI{idx}(1:nFeat,id1);
        train = [InData.Folds_c1.train{idx} InData.Folds_c2.train{idx}]';
        Ytrain = [ones(1,size(InData.Folds_c1.train{idx},2)) 2*ones(1,size(InData.Folds_c2.train{idx},2))]';
        test = [InData.Folds_c1.test{idx} InData.Folds_c2.test{idx}]';
        Ytest = [ones(1,size(InData.Folds_c1.test{idx},2)) 2*ones(1,size(InData.Folds_c2.test{idx},2))]';
        
        parfor idy = 1:length(finalfeatures)
            Xtrain = train(:,finalfeatures(1:idy,1));
            Xtest = test(:,finalfeatures(1:idy,1));
%              options = optimset('maxIter',17000);
%             SVMStruct1 = svmtrain(Xtrain,Ytrain,'Method','QP', 'quadprog_opts',options);
%             class_est1 = svmclassify(SVMStruct1,Xtest);
%             AccSVM(idx,idy) =  100*(sum(class_est1 == Ytest))/length(class_est1);
            
            SVMStruct1=fitcsvm(Xtrain,Ytrain);%,'KernelFunction','rbf','standardize',true); 
            class_est1 = predict(SVMStruct1,Xtest); 
            AccSVM(idx,idy)  = (sum(class_est1 == Ytest))/length(class_est1);
            
        end
    end
    SaveAccSVM{id1} = mean(AccSVM);
    %sprintf('itr no %d and max acc is %f',id1,max(mean(AccSVM)))
clear AccSVM
end

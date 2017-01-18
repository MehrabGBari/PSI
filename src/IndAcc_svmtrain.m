function Indvidual_accSVMTrain = IndAcc_svmtrain(dat)
% Summary: calcuates indvidual classfication accuracy using svmtrain.
% After filtering step and selecting N more stable features,
% this function computes indivdual accuracy for each of N genes.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Indvidual_accSVMTrain = cell(1,dat.fold_out);

for idx = 1:dat.fold_out
    features = dat.RepeatedGenes{idx};
    [L,~] = size(dat.RepeatedGenes{idx});
    AccSVMtrain = zeros(L,dat.fold_int);
    for idy = 1 : dat.fold_int
        
        Trainset = dat.fold_TrainTest{idx}.train{idy}(1:end-1,:)';
        Ytrain = dat.fold_TrainTest{idx}.train{idy}(end,:)';
        
        Testset = dat.fold_TrainTest{idx}.test{idy}(1:end-1,:)';
        Ytest = dat.fold_TrainTest{idx}.test{idy}(end,:)';
        
        for Idx = 1:length(features)
            
            Xtrain = Trainset(:,features(Idx,1));
            Xtest = Testset(:,features(Idx,1));
            
            
            %% SVM Acc
            %            options = optimset('MaxIter',20000);
            SVMStruct1 = svmtrain(Xtrain,Ytrain);%,'KERNEL_FUNCTION','polynomial','BOXCONSTRAINT',30,'Method','QP', 'quadprog_opts',options);
            class_est1 = svmclassify(SVMStruct1,Xtest);
            AccSVMtrain (Idx,idy)  = (sum(class_est1 == Ytest))/length(class_est1);
            
        end
        
    end
    
    Indvidual_accSVMTrain{idx} = [features mean(AccSVMtrain,2)];
    % Keep only top N based on indvidual accuracy
    Indvidual_accSVMTrain{idx} = flip(sortrows(Indvidual_accSVMTrain{idx},5));
    
end

end






function Indvidual_accSVMTrain = IndAcc_svmtrain(DataSet1)
% Summary: calcuates indvidual classfication accuracy using svmtrain.
% After filtering step and selecting N more stable features, 
% this function computes indivdual accuracy for each of N genes.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.
Indvidual_accSVMTrain = cell(1,5);

for crossValid = 1:DataSet1.fold
    features = DataSet1.RepeatedGenes{crossValid};
    [L,~] = size(DataSet1.RepeatedGenes{crossValid});
    AccSVMtrain = zeros(L,DataSet1.fold_int);
    for f = 1 : DataSet1.fold_int
        
        Trainset = DataSet1.fold_TrainTest{crossValid}.train{f}(1:end-1,:)';
        Ytrain = DataSet1.fold_TrainTest{crossValid}.train{f}(end,:)';
        
        Testset = DataSet1.fold_TrainTest{crossValid}.test{f}(1:end-1,:)';
        Ytest = DataSet1.fold_TrainTest{crossValid}.test{f}(end,:)';
                
        for Idx = 1:length(features)
            
            Xtrain = Trainset(:,features(Idx,1));
            Xtest = Testset(:,features(Idx,1));
            

            %% SVM Acc
            %            options = optimset('MaxIter',20000);
            SVMStruct1 = svmtrain(Xtrain,Ytrain);%,'KERNEL_FUNCTION','polynomial','BOXCONSTRAINT',30,'Method','QP', 'quadprog_opts',options);
            class_est1 = svmclassify(SVMStruct1,Xtest);
            AccSVMtrain (Idx,f)  = (sum(class_est1 == Ytest))/length(class_est1);
            
        end
        
    end
    
    Indvidual_accSVMTrain{crossValid} = [features mean(AccSVMtrain,2)];    
    % considering only top 50 based on indvidual accuracy
    Indvidual_accSVMTrain{crossValid} = flip(sortrows(Indvidual_accSVMTrain{crossValid},5));
%     Indvidual_accSVMTrain{crossValid} = Indvidual_accSVMTrain{crossValid}(1:100,:);
end

end






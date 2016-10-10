function Comb2Acc_svmtrain(DataSet1)
% To compute the accuracy score for all pairs. there are N(N-1)/2 pairs
% after preprocessing stpe. Given a pair from list, this function computs 
% its performance in all k folds. 
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

for crossValid = 1:DataSet1.fold
    disp (['Combinations of 2 in the fold: ', num2str(crossValid),'. total folds num: ', num2str(DataSet1.fold),' ...'])
    Comb2 = nchoosek(DataSet1.IndAccSVMtrain{crossValid}(:,1),DataSet1.nchoos);
    AccSVMtrain =zeros(length(Comb2),DataSet1.fold_int);
    
    for f=1:DataSet1.fold_int
        Trainset = DataSet1.fold_TrainTest{crossValid}.train{f}(1:end-1,:)';
        Ytrain = DataSet1.fold_TrainTest{crossValid}.train{f}(end,:)';
        
        Testset = DataSet1.fold_TrainTest{crossValid}.test{f}(1:end-1,:)';
        Ytest = DataSet1.fold_TrainTest{crossValid}.test{f}(end,:)';
        
        parfor Idx = 1:length(Comb2)
            
            % INFO
            Xtrain = Trainset(:,Comb2(Idx,:));
            Xtest = Testset(:,Comb2(Idx,:));
            %% fitcsvm or svmtrain
%             SVMStruct1=fitcsvm(Xtrain,Ytrain,'KernelFunction','rbf','standardize',true); 
%             class_est1 = predict(SVMStruct1,Xtest); 
%             AccSVMtrain (Idx,f)  = (sum(class_est1 == Ytest))/length(class_est1);
            options = optimset('maxIter',17000);

            SVMStruct1 = svmtrain(Xtrain,Ytrain);%,'KERNEL_FUNCTION','polynomial','BOXCONSTRAINT',30,'Method','QP', 'quadprog_opts',options);
            class_est1 = svmclassify(SVMStruct1,Xtest);
            AccSVMtrain(Idx,f) = (sum(class_est1 == Ytest))/length(class_est1);
        end
        
    end
    
    Comb2 = [Comb2 mean(AccSVMtrain,2)];
    save(['Comb2_fold_', num2str(crossValid)],'Comb2');
    

end

end


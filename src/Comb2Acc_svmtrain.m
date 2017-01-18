function Comb2Acc_svmtrain(dat)
% To compute the accuracy score for all pairs. there are N(N-1)/2 pairs
% after preprocessing stpe. Given a pair from list, this function computs
% its performance in all k folds.
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

for idx = 1:dat.fold_out
    disp (['Combinations of 2 of ',num2str(dat.N),' features in the fold: ', num2str(idx),'. ', num2str(dat.fold_out),' - fold cross validation. ......'])
    Comb2 = nchoosek(dat.IndAccSVMtrain{idx}(:,1),dat.nchoos);
    AccSVMtrain =zeros(length(Comb2),dat.fold_int);
    
    for idy=1:dat.fold_int
        Trainset = dat.fold_TrainTest{idx}.train{idy}(1:end-1,:)';
        Ytrain = dat.fold_TrainTest{idx}.train{idy}(end,:)';
        
        Testset = dat.fold_TrainTest{idx}.test{idy}(1:end-1,:)';
        Ytest = dat.fold_TrainTest{idx}.test{idy}(end,:)';
        
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
            AccSVMtrain(Idx,idy) = (sum(class_est1 == Ytest))/length(class_est1);
        end
        
    end
    
    Comb2 = [Comb2 mean(AccSVMtrain,2)];
    save(['Comb2_fold_', num2str(idx)],'Comb2');
    
    
end

end


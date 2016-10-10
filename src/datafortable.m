%Summary: 
%Summary: 
%
% By Mehrab Ghanat Bari (m.ghanatbari@gmail.com)
% September 2014.

clear
Numruns = 10;
mean_top5psi = 0;
for idx = 1:Numruns
    idx
    load (['Run',num2str(idx)])
    temp = [];
    for idy =1:Data.fold
        temp(:,idy) = Data.PSIandIndAcc.PSIscores{idy}(1:5,3);
    end
    mean_top5psi = mean_top5psi + 100*(mean(mean(temp,2))/Numruns);
    %% PSI improve upon Accuracy
    [v,p] = max(Data.finalAccresults{1});
    acc_best(idx) = v;
    acc_best_pos(idx) = p;
    %% PSI best acc, number of features PSI used and PSI percent
    for idy = 1:101
        [vpsi(idy),ppsi(idy)]=max(Data.finalAccresults{idy+1});
    end
    [v,p] = max(vpsi);
    psi_best_acc(idx) = v;
    psi_num_feat(idx) = ppsi(p);
    psi_percent(idx) = p;
end
%%
info.mean_top5psi = mean_top5psi;
info.psi_best_acc = mean(psi_best_acc);
info.psi_num_feat = mean(psi_num_feat);
info.psi_percent= mean(psi_percent);
info.acc_best = mean(acc_best);
info.acc_best_pos = mean(acc_best_pos);
info
%%
clearvars -except info
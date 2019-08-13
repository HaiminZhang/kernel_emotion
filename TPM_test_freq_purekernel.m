%%
%%
%  MAP 0.470959  C=3  tmp_arr.^(5/4);
%  MAP 0.464932        tmp_arr.^(5.5/4);
%  MAP 0.467123                  4.5/4
%  MAP 0.467123                  4.8/4
%              
%  MAP 0.476164 c=10   (tmp_arr+0.5).^(5/4);
% 
%  MAP 0.479452 C=10   tmp_arr = (2*tmp_arr+0.5).^(5/4);
%  MAP 0.481096 C=5    tmp_arr = (4*tmp_arr+0.5).^(5/4);
%  MAP 0.482466 C=4    tmp_arr = (4*tmp_arr+0.5).^(5/4);
%  MAP 0.479452 C=10   tmp_arr = (4*tmp_arr+1).^(5/4);
%  MAP 0.486301      (4*tmp_arr+0.5).^(5/4);




function TPM_FreqDom_test()
    clc;clear all;
    rng(2000);
    para_cost = 6;  % Cost parameter
     
    nRounds = 10;
    tr_num = 60;
    
    mem_block = 3000;
    addpath('Liblinear/matlab');
    

    dFea = 2048;%sum(nCodebook * pyramid);
    
    load('dictionary/feaDatabase_pure_avg_kernel.mat');
    feaDatabase_Freq = feaDatabase_pure_avg_kernel;
    nFea = length(feaDatabase_Freq.path);
    
    fprintf('Testing...\n');
    clabel = unique(feaDatabase_Freq.label);
    nclass = length(clabel);   
    accuracy = zeros(nRounds, 1 + nclass);
     acc = zeros(nclass, 1);
    
    for ii = 1:nRounds
        fprintf('Round %d...\n', ii);
        
        tr_idx = [];
        ts_idx = [];
        
        for jj = 1:nclass
            idx_label = find(feaDatabase_Freq.label == clabel(jj));
            num = length(idx_label);
            
            idx_rand = randperm(num);
            %idx_rand = [1: num];
            tr_num = round(num*2/3);
            if false,%jj == 7 || jj == 5 || jj == 4,
                tr_idx = [tr_idx; idx_label(idx_rand(randperm(tr_num, 70)))];
            else
                tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
            end
            ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:end))];
        end
        
        %% train classifier
        fprintf('Training number: %d\n', length(tr_idx));
        fprintf('Testing number:%d\n', length(ts_idx));
            
        tr_fea = zeros(length(tr_idx), dFea);
        tr_label = zeros(length(tr_idx), 1);
            
        for jj = 1:length(tr_idx)
            fpath = feaDatabase_Freq.path{tr_idx(jj)};
            load(fpath, 'fea', 'label');
           
            tr_fea(jj, :) = fea;
            tr_label(jj) = label;
        end
            
        options = ['-c ' num2str(para_cost)]
        model = train(double(tr_label), sparse(tr_fea), options);
        %clear tr_fea;
        %% train over
            
        %% test begin
            ts_num = length(ts_idx);
            ts_label = [];
            
            ts_fea = zeros(length(ts_idx), dFea);
            ts_label = zeros(length(ts_idx), 1);
            
            for jj = 1:length(ts_idx)
                fpath = feaDatabase_Freq.path{ts_idx(jj)};
                load(fpath, 'fea', 'label');
             
                ts_fea(jj, :) = fea;
                ts_label(jj) = label;
            end
            [C,acc, prob] = predict(tr_label, sparse(tr_fea), model);
            [C, overall_acc, ~] = predict(ts_label, sparse(ts_fea), model);
        %%
        %% calculate accuracy
       
        for jj = 1:nclass
            c = clabel(jj);
            idx = find(ts_label == c);
            current_pred_label = C(idx);
            current_gnd_label = ts_label(idx);
            acc(jj) = length(find(current_pred_label == current_gnd_label))/length(idx);
        end
        %%
        accuracy(ii, 1) =  (overall_acc(1))*0.01;
        accuracy(ii, 2:end) = acc';
    end
    Ravg = mean(accuracy(:, 1));
    Rstd = std(accuracy(:, 1));
    fprintf('===============================================\n');
    fprintf('Average classification accuracy: %f %f %f %f %f %f %f %f\n',...
        mean(accuracy(:,2)), mean(accuracy(:,3)), mean(accuracy(:,4)), ...
        mean(accuracy(:,5)), mean(accuracy(:,6)), mean(accuracy(:,7)), ...
        mean(accuracy(:,8)), mean(accuracy(:,9)));
    fprintf('MAP %f\n', Ravg);
    fprintf('Standard deviation:%f %f %f %f %f %f %f %f %f\n', ...
        std(accuracy(:,2)), std(accuracy(:,3)), std(accuracy(:,4)), ...
        std(accuracy(:,5)), std(accuracy(:,6)), std(accuracy(:,7)), ...
        std(accuracy(:,8)), std(accuracy(:,9)));   
    fprintf('MAstd %f\n', Rstd);
    fprintf('===============================================\n');
end
    


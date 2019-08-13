%%
%%
% 3262565
function [] = getCNNFeaForGMM()
    fea_num_choosed = 256000; % 1 M
    DEEP_fea_forkmeans = zeros(fea_num_choosed, 2048);
    %pm = pm(1:fea_num_choosed); % choose 800000 features for kmeans
    num_fea = 700*1098;
    pm = randperm(num_fea, fea_num_choosed);
    pm = sort(pm, 2);
    %pm = [1:fea_num_choosed];
    
    load('dictionary/videoDatabase_resnet.mat');
    database = videoDatabase_resnet;
    clear videoDatabase_resnet;
    nImg = length(database.path);
    
    base_num = 0;
    k = 1;
    tic;
    for i = 1:nImg
        
        fpath = database.path{i};
        load(fpath);
        num = size(feaSet.domFeaArrLLC, 1);
         
        over = 0;
        while true
            if k > fea_num_choosed
                over = 1;
                break;
            end
            
            if pm(k) <= base_num + num                
                DEEP_fea_forkmeans(k, :) = feaSet.domFeaArrLLC(pm(k)-base_num, :);
                %DEEP_fea_forkmeans = [DEEP_fea_forkmeans; feaSet.feaArrNorm(:, pm(k)-base_num)'];
                k = k + 1;            
            
                
                if ~mod(k,1000)
                    k
                    toc;
                end
            else
                break;
            end         
                    
        end
        if over == 1
            break;
        end
       base_num = base_num + num;        
    end
    %path = fullfile('dictionary', [fea_forkmean]);
    %save('dictionary/DEEP_fea_forkmeans', 'DEEP_fea_forkmeans');
     DEEP_KernelSC_fea_forGMM = DEEP_fea_forkmeans;
    save('dictionary/DEEP_KernelSC_fea_forGMM', 'DEEP_KernelSC_fea_forGMM');
end
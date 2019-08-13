%%
%%
% 3262565
function [] = getCnnfeaGMM()
    fea_num_choosed = 256000*2; % 1 M
    DEEP_fea_forkmeans = zeros(fea_num_choosed, 2048);
    %pm = pm(1:fea_num_choosed); % choose 800000 features for kmeans
    num_fea = 700*1098;
    pm = randperm(num_fea, fea_num_choosed);
    pm = sort(pm, 2);
    
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
        feaArr = feaSet.feaArr(:,:,3);
        num = size(feaArr, 1);
         
        over = 0;
        while true
            if k > fea_num_choosed
                over = 1;
                break;
            end
            
            if pm(k) <= base_num + num                
                DEEP_fea_forkmeans(k, :) = feaArr(pm(k)-base_num, :);
                k = k + 1;            
            
                
                if ~mod(k,100)
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
    DEEP_fea_forkmeans_Freq = DEEP_fea_forkmeans;
    save('dictionary/DEEP_fea_forkmeans_Freq', 'DEEP_fea_forkmeans');
end
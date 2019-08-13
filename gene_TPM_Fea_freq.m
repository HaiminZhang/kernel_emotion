%%
%% Haimin ZHANG 13 OCT 2015
%%
function  gene_TPM_Fea()

    clear all; close all; clc;

    fea_dir = 'features_avg_freq';



    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    nFea = length(videoDatabase.path);

    feaDatabase = struct;
    feaDatabase.path = cell(nFea, 1);
    feaDatabase.label = zeros(nFea, 1);


    tic;
    for iter1 = 1:nFea
        %iter1
        if ~mod(iter1, 10)
            fprintf('%d video clips processed', iter1);
            toc;
        end
        fpath = videoDatabase.path{iter1};
        flabel = videoDatabase.label(iter1);
        load(fpath);
        [rtpath, fname] = fileparts(fpath);

        feaPath = fullfile(fea_dir, num2str(flabel), [fname '.mat']);

        fea = mean(feaSet.domFeaArr);%TPM_pooling(feaSet, B, pyramid);
        fea = fea/norm(fea);
%         fea2 = mean(feaSet.feaArrNorm, 2);
%         fea2 = fea2/norm(fea2)/3;
%         fea = [fea fea2'];
%         fea = fea.*3./sqrt(5);
%         %%
%          feaFreqDom = TPM_FreqDom_pooling(feaSet, [1], [1]);
%          feaFreqDom = feaFreqDom.*2./sqrt(5);
%          
%          fea = [fea; feaFreqDom];
        %%


        if ~isdir(fullfile(fea_dir, num2str(flabel)))
            mkdir(fullfile(fea_dir, num2str(flabel)))
        end
        label = videoDatabase.label(iter1);
        save(feaPath, 'fea', 'label');
        
        feaDatabase.path{iter1} = feaPath;
        feaDatabase.label(iter1) = flabel;
    end
    feaDatabase_freq_avg = feaDatabase;
    save('dictionary/feaDatabase_freq_avg', 'feaDatabase_freq_avg');
end
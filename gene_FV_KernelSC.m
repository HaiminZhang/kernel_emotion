%%
%% Haimin ZHANG 13 OCT 2015
%%
function [] = gene_FV_Fea_Freq()

    clear all; close all; clc;
    run('vlfeat-0.9.20/toolbox/vl_setup');
    fea_dir = 'featuresFreqDom';

    pyramid = [1 ];

    dictPath = 'dictionary/GMM_para_KernelSC';

    load(dictPath);
  

    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    clear videoDatabase_resnet;
    
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

        %fea = TPM_pooling(feaSet, B, pyramid);
        fea = vl_fisher(feaSet.domFeaArrLLC', means, covariances, priors);
        %fea = fea/norm(fea);
        
        fea = fea/norm(fea);
        %fea = fea/norm(fea);
%         feaFreqDom = TPM_FreqDom_pooling(feaSet, [1], [1]);
%         feaFreqDom = feaFreqDom/norm(feaFreqDom)/3;
        
        %fea = [fea; feaFreqDom];
        
        if ~isdir(fullfile(fea_dir, num2str(flabel)))
            mkdir(fullfile(fea_dir, num2str(flabel)))
        end
        label = videoDatabase.label(iter1);
        save(feaPath, 'fea', 'label');
        
        feaDatabase.path{iter1} = feaPath;
        feaDatabase.label(iter1) = flabel;
    end
    feaDatabaseKernelSC = feaDatabase;
    save('dictionary/feaDatabaseKernelSC', 'feaDatabaseKernelSC');
end
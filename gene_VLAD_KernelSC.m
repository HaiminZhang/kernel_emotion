%%
%% Haimin ZHANG 13 OCT 2015
%%
function [] = gene_FV_Fea_Freq()

    clear all; close all; clc;

    fea_dir = 'featuresFreq_vladfreq';
    run('./vlfeat-0.9.20/toolbox/vl_setup.m');
    pyramid = [1 ];
    dictPath = 'dictionary/DEEP_CodeBook_FreqDom_16.mat';

    load(dictPath);
    centers = DEEP_CodeBook_FreqDom_16;
  

    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    nFea = length(videoDatabase.path);

    feaDatabase_Freq = struct;
    feaDatabase_Freq.path = cell(nFea, 1);
    feaDatabase_Freq.label = zeros(nFea, 1);


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
        kdtree = vl_kdtreebuild(centers) ;
        nn = vl_kdtreequery(kdtree, centers, (real(feaSet.domFeaArrLLC))');
        
        assignments = zeros( size(centers, 2), size(feaSet.domFeaArrLLC, 1));
        assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
        
        fea = vl_vlad((real(feaSet.domFeaArrLLC))',centers,assignments, 'NormalizeComponents' );  %, 'NormalizeComponents'
        %fea = fea / norm(fea);
        
        %feaFreqDom = TPM_FreqDom_pooling(feaSet, [1], [1]);
        
        if ~isdir(fullfile(fea_dir, num2str(flabel)))
            mkdir(fullfile(fea_dir, num2str(flabel)))
        end
        label = videoDatabase.label(iter1);
        save(feaPath, 'fea', 'label');
        
        feaDatabase_Freq.path{iter1} = feaPath;
        feaDatabase_Freq.label(iter1) = flabel;
    end
    feaDatabase_Freq_vlad = feaDatabase_Freq;
    save('dictionary/feaDatabase_Freq_vlad', 'feaDatabase_Freq_vlad');
end
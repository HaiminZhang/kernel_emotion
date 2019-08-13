%%
%% Haimin ZHANG 13 OCT 2015
%%
function  gene_TPM_Fea()

    clear all; close all; clc;

    
    knn = 5;
    addpath('LLC/');

    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    clear  videoDatabase_resnet;
    nFea = length(videoDatabase.path);

    load('dictionary/DEEP_CodeBook_FreqDom_1024.mat');
    B = DEEP_CodeBook_FreqDom_1024;

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

     

        llc_codes = LLC_coding_appr(B', feaSet.domFeaArr, knn);
        domFeaArrLLC = llc_codes * B';
        
        feaSet.domFeaArrLLC = domFeaArrLLC;
        
        save(fpath, 'feaSet');


   
    end

end
%%
%% Haimin ZHANG 13 OCT 2015
%%
function  gene_TPM_Fea()

    clear all; close all; clc;

    fea_dir = 'featuresAvg';
  


    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    clear  videoDatabase_resnet;
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
        
        %
%         nFea = size(feaSet.feaArrNorm, 1);
%         start = 1;
%         if nFea >100,
%             start = nFea - 100;
%         end
        fea = mean(feaSet.feaArrNorm, 1);
       
        fea = fea/norm(fea);
        
        
        
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
    feaDatabase_avg = feaDatabase;
    save('dictionary/feaDatabase_avg', 'feaDatabase_avg');
end
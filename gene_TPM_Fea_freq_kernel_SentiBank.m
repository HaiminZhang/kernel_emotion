%%
%% Haimin ZHANG 13 OCT 2015
%%
function  gene_TPM_Fea()

    clear all; close all; clc;

    fea_dir = 'features_avg_freq_kernel';

    converted_idx = convert_video_index();
    sentibankfeaset = importdata('handcraftedFeatures/SentiBank.txt');


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
        %tmp_arr = feaSet.domFeaArrLLC;
        %tmp_arr = (4*tmp_arr+0.5).^(5/4);
        tmp_arr = feaSet.kernel_domFeaArr;
        fea = mean(tmp_arr(:,:));%TPM_pooling(feaSet, B, pyramid);
        fea = fea/norm(fea);
        fea_sentib = sentibankfeaset(converted_idx(iter1), :);
        fea = [fea(:); fea_sentib(:)];
        %fea = abs(trans(fea));
        %fea = fea/norm(fea);
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
    feaDatabase_freq_avg_kernel_cm_Sentibank = feaDatabase;
    save('dictionary/feaDatabase_freq_avg_kernel_cm_Sentibank', 'feaDatabase_freq_avg_kernel_cm_Sentibank');
end



function [v] = trans(src)
    pos = [1.6:1:2048+0.6];
    %pos = [1:0.1:2048];
    %v = zeros(1,length);
    for ii = 1:length(pos),
        v(ii) = calc(pos(ii), src);
    end
end

function [v] =  calc(idx, src)
  base = fft(src);
  t = 0;
  len = length(base);

  for ii = 1:len,
    t = t + base(ii)*exp(2i*pi*(ii-1)*(idx-1)/len)/len;
  end
  v = t;

end


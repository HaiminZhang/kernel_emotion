function [  ] = genedata_matcaffe_crop(  )
%GENEDATA Summary of this function goes here
%   Detailed explanation goes here
    clear;clc;
    load('dictionary/videoDatabase_resnet.mat');

    tic;
    nVid = length(videoDatabase_resnet.path);
    
    for ii = 1:nVid,
        if ~mod(ii,1),
            fprintf('%d\n', ii);
            toc;
        end
        fpath = videoDatabase_resnet.path{ii};
        load(fpath);
        
        %feaSet.domFeaArr = [feaSet.domFeaArr5A; feaSet.domFeaArr5B; feaSet.domFeaArr5C];
        t = extract(feaSet.cp_P, [1:1950]);
        t = full(t);
        t = t.data;
        
        feaSet.feaArr = t;
        %tFea = tensor(feaSet.domFeaArr);
        %P = cp_als(tFea, 2000);
        %fP = full(P);
        %feaSet.cp_P = P;
        %s = sum((tFea(:)-fP(:)).^2);
        %fprintf('distance-----------%f\n', s);
        save(fpath, 'feaSet');
    end
    

end

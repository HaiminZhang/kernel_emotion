function [  ] = genedata_matcaffe_crop(  )
%GENEDATA Summary of this function goes here
%   Detailed explanation goes here
    clear;clc;
    load('dictionary/videoDatabase_resnet.mat');

    
    nVid = length(videoDatabase_resnet.path);
    
    for ii = 1:nVid,
        if ~mod(ii,10),
            fprintf('%d\n', ii);
        end
        fpath = videoDatabase_resnet.path{ii};
        load(fpath);
        
        %feaSet.domFeaArr = [feaSet.domFeaArr5A; feaSet.domFeaArr5B; feaSet.domFeaArr5C];
        
        tFea = tensor(feaSet.domFeaArr);
        P = cp_als(tFea, 2000);
        %fP = full(P);
        feaSet.cp_P = P;
        %s = sum((tFea(:)-fP(:)).^2);
        %fprintf('distance-----------%f\n', s);
        save(fpath, 'feaSet');
    end
    

end

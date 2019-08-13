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
        d1 = size(feaSet.domFeaArr5A, 1);
        d2 = size(feaSet.domFeaArr5A, 2);
        
        
        feaSet.domFeaArr = zeros(d1, d2, 3);
        feaSet.domFeaArr(:,:,1) = feaSet.domFeaArr5A; %feaSet.domFeaArr5B; feaSet.domFeaArr5C];
        feaSet.domFeaArr(:,:,2) = feaSet.domFeaArr5B;
        feaSet.domFeaArr(:,:,3) = feaSet.domFeaArr5C;
        save(fpath, 'feaSet');
        
        
    end
    

end

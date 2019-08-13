function [  ] = genedata_matcaffe_crop(  )
%GENEDATA Summary of this function goes here
%   Detailed explanation goes here
    clear;clc;
    load('dictionary/videoDatabase_resnet.mat');

    nVid = length(videoDatabase_resnet.path);
    
    for ii = 1:nVid,
        load(videoDatabase_resnet.path{ii});
        feaSet.domFeaArr = [feaSet.feaArrNorm5A; feaSet.feaArrNorm5B; feaSet.feaArrNorm5C];
    end
    

end

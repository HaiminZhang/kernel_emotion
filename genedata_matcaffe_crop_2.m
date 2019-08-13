function [  ] = genedata_matcaffe_crop(  )
%GENEDATA Summary of this function goes here
%   Detailed explanation goes here
    img_dir = 'Frames_strd8';
    data_dir = 'data';

    
    addpath('/home/hmzhang/disk4t/zhanghm/caffe_zhanghm/caffe-master/matlab');
    
    weights = '/home/hmzhang/disk4t/user_gene_video/user_gene_resnet/resnetmodel/ResNet-152-model.caffemodel';
    model = '/home/hmzhang/disk4t/user_gene_video/user_gene_resnet/resnetmodel/ResNet-152-deploy.prototxt';
    

    caffe.set_mode_gpu();
    caffe.set_device(0);
    net = caffe.Net(model, weights, 'test');
    
%     im = imread('Frames_strd8/VideoEmotionDataset1-Anger/10AnnoyingThingsCarPassengersDo[Part1]/frame_00001.jpg');
%     input_data = {prepare_image(im)};
%     scores = net.forward(input_data);
    %net.blobs('data').reshape([224 224 3 1]);
    %A = fscanf(fid, );
    
    emotionSet = dir(img_dir);
    for iter1 = 9:length(emotionSet),
        emotionName = emotionSet(iter1).name;
        if ~strcmp(emotionName, '.') && ~strcmp(emotionName, '..'),
            videoSet = dir(fullfile(img_dir, emotionName));

            for jj = 1:length(videoSet),
                if mod(jj, 10) == 0
                    fprintf('%d %d\n', iter1, jj);
                end
                videoname = videoSet(jj).name;
                if ~strcmp(videoname, '.') && ~strcmp(videoname, '..'),
                    frames = dir(fullfile(img_dir, emotionName, videoname, '*.jpg'));
                    nF = length(frames);
                    A = zeros(nF, 2048);
                    
                    for kk=1:nF,
                        im_path = fullfile(img_dir, emotionName, videoname, frames(kk).name);
                        %im_data = caffe.io.load_image(im_path);
                        im_data = imread(im_path);
                        
                        tmp_fea = zeros(10, 2048);
                        for it = 1:size(tmp_fea, 1),
                            crop_img = prepare_image(im_data);
                            input_data = {crop_img(:,:,:, it)};

                            res = net.forward(input_data); 
                            pool5_feat = net.blobs('pool5').get_data();
                            %pool5_feat = net.blobs('prob').get_data();
                            pool5_feat = pool5_feat(:);
                            %pool5_feat = pool5_feat / norm(pool5_feat);
                            tmp_fea(it,:) = pool5_feat;
                        end
                        feat = mean(tmp_fea);
                        feat = feat/norm(feat);
                        %fc7_feat = mean(fc7_feat, 2);
                        %fc7_feat = fc7_feat / norm(fc7_feat);
                        A(kk, :) = feat;
                    end
                    
                    if ~isdir(fullfile(data_dir,emotionName)),
                        mkdir(fullfile(data_dir,emotionName));
                    end  
                    path = fullfile(data_dir, emotionName, [videoname '.mat']);
                    
%                     for kk = 1:size(A,2),
%                         A(:, kk) = A(:, kk) / norm(A(:, kk));
%                     end
                    feaSet.feaArrNorm = A;
                    save(path, 'feaSet');
                    %A = A';
                end
            end
        end
    end
    
    

end

function crops_data = prepare_image(im)
% ------------------------------------------------------------------------
% caffe/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat contains mean_data that
    % is already in W x H x C with BGR channels
    %d = load('./matlab/+caffe/imagenet/ilsvrc_2012_mean.mat');
    mean_data = caffe.io.read_mean('./resnetmodel/ResNet_mean.binaryproto'); %BGR channels
    %mean_data = d.mean_data;
    IMAGE_DIM = 256;
    CROPPED_DIM = 224;

    % Convert an image returned by Matlab's imread to im_data in caffe's data
    % format: W x H x C with BGR channels
    im_data = im(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
    im_data = permute(im_data, [2, 1, 3]);  % flip width and height
    im_data = single(im_data);  % convert from uint8 to single
    
%    im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % resize im_data
    [hight, width, chan] = size(im_data);
    min = hight;
    if width < min,
        min = width;
    end
    scale = 256/min;
    im_data = imresize(im_data, scale, 'bilinear');  % resize im_data
    [hight, width, chan] = size(im_data);
    start_row = int32(floor((hight-IMAGE_DIM)/2)) + 1;
    start_col = int32(floor((width-IMAGE_DIM)/2)) + 1;
    
    crops_data = zeros(CROPPED_DIM, CROPPED_DIM, 3, 10, 'single');
    
    im_center = im_data(start_row:start_row+256-1, start_col:start_col+256-1, :);
    
    
    %im_data = im_data - mean_data;  % subtract mean_data (already in W x H x C, BGR)

    % oversample (4 corners, center, and their x-axis flips)
    
    indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;
    n = 1;

    center = floor(indices(2) / 2) + 1;
    margin = indices(2);
    crops_data(:,:,:,1) = ...
      im_center(center:center+CROPPED_DIM-1,center:center+CROPPED_DIM-1,:) - mean_data;
    crops_data(:,:,:,2) = ...
      crops_data(end:-1:1,:,:,1);

   
    im_left = im_data(1:IMAGE_DIM,1:IMAGE_DIM,:);
    crops_data(:,:,:,3) = ...
      im_left(1:1+CROPPED_DIM-1,1:1+CROPPED_DIM-1,:) - mean_data;
    crops_data(:,:,:,4) = ...
      crops_data(end:-1:1,:,:,3);
  
  
  
    im_right = im_data(1:IMAGE_DIM,width-IMAGE_DIM+1:end,:);
    crops_data(:,:,:,5) = ...
      im_right(1:1+CROPPED_DIM-1,margin:end,:) - mean_data;
    crops_data(:,:,:,6) = ...
      crops_data(end:-1:1,:,:,5);
  
  
    im_leftdown = im_data(hight-IMAGE_DIM+1:end,1:IMAGE_DIM,:);
    crops_data(:,:,:,7) = ...
      im_leftdown(margin:end,1:1+CROPPED_DIM-1,:) - mean_data;
    crops_data(:,:,:,8) = ...
      crops_data(end:-1:1,:,:,7);
  
    im_rightdown = im_data(hight-IMAGE_DIM+1:end,width-IMAGE_DIM+1:end,:);
    crops_data(:,:,:,9) = ...
      im_rightdown(margin:end, margin:end,:) - mean_data;
    crops_data(:,:,:,10) = ...
      crops_data(end:-1:1,:,:,9);
  
end


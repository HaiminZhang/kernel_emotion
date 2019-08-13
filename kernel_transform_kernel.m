function [] = fft_feature()
    FreqDomSmpNum = 700;
    
    load('dictionary/videoDatabase_resnet.mat');
    videoDatabase = videoDatabase_resnet;
    clear videoDatabase_resnet;
    nVideo = length(videoDatabase.path);
    tic;
    for ii = 1:nVideo
        
        if ~mod(ii, 5)
            fprintf('%d of total %d processed\n', ii, nVideo);
            toc;
        end
        fpath = videoDatabase.path{ii};
        
        load(fpath);
        
       
        
        FeaNum = size(feaSet.validFeaArr, 1);
        FeaDim = size(feaSet.validFeaArr, 2);
       
        %FreqDomSmpNum = FeaNum;
        %feaSet.domFeaArr =[];
        
        %for jj = 1:FeaDim
            %xx = feaSet.validFeaArr(:, jj);
            %xx = fft(xx);
            %xx = imresize(xx, [FreqDomSmpNum 1]);
            %xx = xx(5:round(length(xx)*0.1));
            %xxAbs = abs(xx);

            %feaSet.domFeaArr(:, jj) = xxAbs;
%             if length(xxAbs) > 1000
%                 xxAbs = xxAbs(1:1000);
%             end
%             if norm(xxAbs)==0,
%                 fprintf('stop\n');
%             end
        tmp_arr = feaSet.domFeaArrLLC;
        tmp_arr = (4*tmp_arr+0.5).^(5/4);
        feaSet.kernel_domFeaArr = tmp_arr;
 %       end
 
        save(fpath, 'feaSet');
        
    end

end
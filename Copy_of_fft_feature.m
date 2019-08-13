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
        %%%%    5A
        validFeaArr = feaSet.feaArrNorm5C;
        
        FeaNum = size(validFeaArr, 1);
        FeaDim = size(validFeaArr, 2);
       
        %FreqDomSmpNum = FeaNum;
        feaSet.domFeaArr5A =[];
        
        for jj = 1:FeaDim
            xx = validFeaArr(:, jj);
            xx = fft(xx);
            xx = imresize(xx, [FreqDomSmpNum 1]);
            %xx = xx(5:round(length(xx)*0.1));
            xxAbs = abs(xx);

            %feaSet.domFeaArr(:, jj) = xxAbs;
%             if length(xxAbs) > 1000
%                 xxAbs = xxAbs(1:1000);
%             end
%             if norm(xxAbs)==0,
%                 fprintf('stop\n');
%             end
            feaSet.domFeaArr5A(:, jj) = xxAbs(1:end);
        end
        
        %%%%    5B
        validFeaArr = feaSet.feaArrNorm5B;
        
        FeaNum = size(validFeaArr, 1);
        FeaDim = size(validFeaArr, 2);
       
        %FreqDomSmpNum = FeaNum;
        feaSet.domFeaArr5B =[];
        
        for jj = 1:FeaDim
            xx = validFeaArr(:, jj);
            xx = fft(xx);
            xx = imresize(xx, [FreqDomSmpNum 1]);
            %xx = xx(5:round(length(xx)*0.1));
            xxAbs = abs(xx);

            %feaSet.domFeaArr(:, jj) = xxAbs;
%             if length(xxAbs) > 1000
%                 xxAbs = xxAbs(1:1000);
%             end
%             if norm(xxAbs)==0,
%                 fprintf('stop\n');
%             end
            feaSet.domFeaArr5B(:, jj) = xxAbs(1:end);
        end
        
        %%%%    5C
        validFeaArr = feaSet.feaArrNorm5C;
        
        FeaNum = size(validFeaArr, 1);
        FeaDim = size(validFeaArr, 2);
       
        %FreqDomSmpNum = FeaNum;
        feaSet.domFeaArr5C =[];
        
        for jj = 1:FeaDim
            xx = validFeaArr(:, jj);
            xx = fft(xx);
            xx = imresize(xx, [FreqDomSmpNum 1]);
            %xx = xx(5:round(length(xx)*0.1));
            xxAbs = abs(xx);

            %feaSet.domFeaArr(:, jj) = xxAbs;
%             if length(xxAbs) > 1000
%                 xxAbs = xxAbs(1:1000);
%             end
%             if norm(xxAbs)==0,
%                 fprintf('stop\n');
%             end
            feaSet.domFeaArr5C(:, jj) = xxAbs(1:end);
        end
        
 
        save(fpath, 'feaSet');
        
    end

end
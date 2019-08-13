%%
%%
% 3262565
function learncodebook_FreqDom()
    %run('D:\E_zhanghm\vlfeat-0.9.18\toolbox\vl_setup');
    run('vlfeat-0.9.20/toolbox/vl_setup.m');
%     load('dictionary\videoDatabase.mat');
%     X = [];
%     SmpNum = 1024 * 1024;
%     SmpIdx = randperm(3262565);
%     SmpIdx = SmpIdx(1:SmpNum);
%     SmpIdx = sort(SmpIdx, 2);
%     videonum = length(videoDatabase.path);
%     for i = 1:videonum
%         load(videoDatabase.path{i});
%         X = [X feaSet.validFeaArr'];
%     end
    load('dictionary/DEEP_fea_forkmeans_Freq.mat');
    X = DEEP_fea_forkmeans';
    
    clear DEEP_fea_forkmeans;
    %pm = randperm(1024*1024, 1024*512);
    %X=X(:,pm);
    
    
    %pm = randperm(1048576, 200000);
    %X = X(:, pm);
    tic;
    [DEEP_CodeBook_FreqDom_16, IDX] = vl_kmeans(X, 2, 'verbose', 'algorithm', 'elkan', 'MaxNumIterations', 1000);
    toc;
    save('dictionary/DEEP_CodeBook_FreqDom_16', 'DEEP_CodeBook_FreqDom_16');
    fprintf('generate Cood Book DEEP_CodeBook_FreqDom_16 over!\n');
end
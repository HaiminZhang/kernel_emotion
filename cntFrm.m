clear;clc;

load('dictionary/videoDatabase_resnet.mat');
videoDB = videoDatabase_resnet;
nVid = size(videoDB.path, 1);

cnt = 0;
for ii = 1:nVid,
    %videoDB.path{ii}
    if ~mod(ii, 10),
        fprintf('ii %d\n', ii);
    end
    load(videoDB.path{ii});
    cnt = cnt + size(feaSet.feaArrNorm, 1);
end
fprintf('cnt %d\n', cnt);
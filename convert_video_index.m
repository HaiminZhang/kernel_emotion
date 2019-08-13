%
%

function [converted_idx] = convert_video_index()
    vidset = importdata('dictionary/video_idx_set.dat');
    
    nvid = length(vidset);
    temp = {};
    
    for ii = 1:nvid,
        vidname = vidset{ii, 1};
        [pathstr,name,ext] = fileparts(vidname);
        temp{ii, 1} = name;
    
    end 
    videonameset = temp;
    test = [];
    load('dictionary/videoDatabase_resnet.mat');
    npath = length(videoDatabase_resnet.path);
    for ii = 1:npath,
        videoname = videoDatabase_resnet.path{ii, 1};
        [pathstr,name,ext] = fileparts(videoname);
        [logidx, loc] = ismember(name, videonameset);
        if logidx == 0,
            fprintf('could not find %s\n', name);
        end
%         if loc == 309,
%             fprintf('i %d %s %s\n', ii, name, videonameset{loc, 1});
%         end
        %fprintf('%d\n', loc);
        test = [test, loc];
    end
    converted_idx = test;
end
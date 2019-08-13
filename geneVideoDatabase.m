function geneVideoDatabase()
    rt_data_dir = 'data/';
    
    videoDatabase = [];
    videoDatabase.videonum = 0;
    videoDatabase.cname = {};
    videoDatabase.label = [];
    videoDatabase.path = {};
    videoDatabase.nclass = 0;
    
    subfolders = dir(rt_data_dir);
   
    for i = 1:length(subfolders)
        subname = subfolders(i).name;
        
        if ~strcmp(subname, '.') && ~strcmp(subname, '..')
            videoDatabase.nclass = videoDatabase.nclass + 1;
            videoDatabase.cname{videoDatabase.nclass} = subname;
            frm = dir(fullfile(rt_data_dir, subname, '*.mat'));
            videoDatabase.videonum = videoDatabase.videonum + length(frm);
            videoDatabase.label = [videoDatabase.label; ones(length(frm), 1)*videoDatabase.nclass];
            
            for jj = 1:length(frm)
                fname = frm(jj).name;
               
                videoDatabase.path = [videoDatabase.path; fullfile(rt_data_dir, subname, fname)];
                fullfile(rt_data_dir, subname, fname)
            end
     
        end
        
    end
    videoDatabase_resnet = videoDatabase;
    save('dictionary/videoDatabase_resnet.mat', 'videoDatabase_resnet');
    fprintf('gene video database over!\n size: %d\n', videoDatabase.videonum);
end

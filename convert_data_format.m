clear; clc;

rt_dir = 'data';
dst_dir = 'data_txt';

classes = dir(rt_dir);

for ii = 1:size(classes, 1),
    if ~strcmp(classes(ii).name, '.') && ~strcmp(classes(ii).name ,'..')
        %fprintf('%d %s\n', i, classes(i).name)
        vids = dir(fullfile(rt_dir, classes(ii).name));
        for jj = 1:size(vids, 1),
            if ~strcmp(vids(jj).name, '.') && ~strcmp(vids(jj).name, '..'),
                fprintf('%s\n', fullfile(classes(ii).name, vids(jj).name));
                load(fullfile(rt_dir, classes(ii).name, vids(jj).name));
                tmpDir = fullfile(fullfile(dst_dir, classes(ii).name));
                if ~isdir(tmpDir),
                    mkdir(tmpDir);
                end     
                [pathstr, fname, ext] = fileparts(vids(jj).name);
                fid = fopen(fullfile(tmpDir, [fname '.fea']), 'w+');
                if fid == -1,
                    fprintf('fopen error %s', fullfile(tmpDir, vids(jj).name));
                    
                end
                fprintf(fid, '%d %d\n', size(feaSet.feaArrNorm, 1), size(feaSet.feaArrNorm, 2));
                for row = 1:size(feaSet.feaArrNorm, 1),
                    for col = 1:size(feaSet.feaArrNorm, 2),
                        fprintf(fid, '%f ', feaSet.feaArrNorm(row, col));
                    end
                    fprintf(fid, '\n');
                end
                fclose(fid);
            end
        end
    end
end
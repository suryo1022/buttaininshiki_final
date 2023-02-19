addpath('.');

% BoFベクトルを作っておく（ない場合）
fpath_BoFs = "data/bofs.mat";
if exist(fpath_BoFs, 'file') == 0
    BoFs = make_BoFs(fname_imglist);
    save(fpath_BoFs, 'BoFs');
else
    fprintf("BoFs exists.\n");
    load("data/bofs.mat");
end

size(BoFs)
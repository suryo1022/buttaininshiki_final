% （注意）このファイルはfinal/1/scriptsにあり、
% final/1/dataからURLリストを取ってくることを前提としている
urllist_sel = textread('../data/urllist.txt', '%s');

urllist_sel
size(urllist_sel)


% 画像を読み込み、imgdirに保存
% （注意）imgdirは、final/1/にあり、このmファイルは
% final/1/scriptsにある事を前提としている
BASEDIR = '../imgdir/';
SUBDIRs = {'katsudon/', 'soba/', 'gyudon/'};
mkdir(BASEDIR);
itr_dir = 1;
for i = 1:size(urllist_sel, 1)
    % URLリストのコメントは飛ばす（#で始まる）
    % サブディレクトリを作っておく
    if startsWith(urllist_sel{i}, '#')
        OUTDIR = strcat(BASEDIR, SUBDIRs{itr_dir});
        mkdir(OUTDIR);
        itr_dir = itr_dir + 1;
        continue;
    end

    fname = strcat(OUTDIR, num2str(i, '%04d'), '.jpg');
    websave(fname, urllist_sel{i});
end
% 課題2の実験を行う

addpath('./scripts')

% 画像のディレクトリがあるかチェックする
% （注意）すでにReadImageを用いて画像をfinal/2/imgdirに保存した状態で実行することが想定されている
imgpathdir0 = "images/";
imgdirs = {'positive', 'negative', 'test'};
for i = 1:size(imgdirs, 2)
    % 7 ... ディレクトリが存在する
    if exist(strcat(imgpathdir0, imgdirs{i}), 'dir') == 7
        fprintf("%s exists.\n", imgdirs{i})
    end
end


% -------- データ作成（読み込み） -------
% 画像のファイル名リストを作成する（ある場合は抜かす）
% リストの変数名は'fname_trainimglist'
% fname_imglist = {positive, negative, test}であり、
% katsudon = {~.jpg, ~.jpg; ...}, negative, testも同様

fpath_trainimglist = "data/trainimglist.mat";
traindirs = {'positive', 'negative'};
if exist(fpath_trainimglist, 'file') == 0
    % arguments("images/", "{'positive', ...}", "data/imglist.txt")
    fname_trainimglist = make_imglist(imgpathdir0, traindirs);
    save(fpath_trainimglist, 'fname_trainimglist');
else
    fprintf("Train Filename list exists.\n");
    load(fpath_trainimglist);
    fname_trainimglist
end

% リストの変数名は'fname_testimglist'
fpath_testimglist = "data/testimglist.mat";
testdirs = {'test'};
if exist(fpath_testimglist, 'file') == 0
    fname_testimglist = make_imglist(imgpathdir0, testdirs);
    save(fpath_testimglist, 'fname_testimglist');
else
    fprintf("Test Filename list exists.\n");
    load(fpath_testimglist);
    fname_testimglist
end

% 学習画像に対して、AlexNetを用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_trainalexdcnn = "data/trainalexdcnn.mat";
if exist(fpath_trainalexdcnn, 'file') == 0
    trainalexdcnn = make_dcnn(alexnet, 'fc7', fname_trainimglist);
    save(fpath_trainalexdcnn, 'trainalexdcnn');
    size(trainalexdcnn)
else
    fprintf("Train AlexNet DCNN exists.\n");
    load("data/trainalexdcnn.mat");
end

% テスト画像に対して、AlexNetを用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_testalexdcnn = "data/testalexdcnn.mat";
if exist(fpath_testalexdcnn, 'file') == 0
    testalexdcnn = make_dcnn(alexnet, 'fc7', fname_testimglist);
    save(fpath_testalexdcnn, 'testalexdcnn');
    size(testalexdcnn)
else
    fprintf("Test AlexNet DCNN exists.\n");
    load("data/testalexdcnn.mat");
end


% リランキングを行う（２５枚）
fpath_25sortedimglist = "data/25sortedimglist.mat"
train_data = [trainalexdcnn(1:25, :); trainalexdcnn(51:1050, :)];
sortedimglist_25 = reranking(train_data, testalexdcnn, 25, 1000, fname_testimglist);
save(fpath_25sortedimglist, 'sortedimglist_25');

% リランキングを行う（５０枚）
fpath_50sortedimglist = "data/50sortedimglist.mat"
train_data = [trainalexdcnn(1:50, :); trainalexdcnn(51:1050, :)];
sortedimglist_50 = reranking(train_data, testalexdcnn, 50, 1000, fname_testimglist);
save(fpath_50sortedimglist, 'sortedimglist_50');

% リランキング結果を表示
showresult(sortedimglist_25, fname_testimglist, 100, "result/25/");
showresult(sortedimglist_50, fname_testimglist, 100, "result/50/");


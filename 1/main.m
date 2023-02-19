% 課題1の実験を行う

addpath('./scripts')

% 画像のディレクトリがあるかチェックする
% （注意）すでにReadImageを用いて画像をfinal/1/imgdirに保存した状態で実行することが想定されている
imgpathdir0 = "imgdir/";
imgdirs = {'katsudon', 'soba', 'gyudon'};
for i = 1:size(imgdirs, 2)
    % 7 ... ディレクトリが存在する
    if exist(strcat(imgpathdir0, imgdirs{i}), 'dir') == 7
        fprintf("%s exists.\n", imgdirs{i})
    end
end


% -------- データ作成（読み込み） -------
% 画像のファイル名リストを作成する（ある場合は抜かす）
% リストの変数名は'fname_imglist'
% fname_imglist = {katsudon, soba, gyudon}であり、
% katsudon = {~.jpg, ~.jpg; ...}, soba, gyudonも同様

fpath_imglist = "data/imglist.mat";
if exist(fpath_imglist, 'file') == 0
    % arguments("imgdir/", "{'katsudon', ...}", "data/imglist.txt")
    fname_imglist = make_imglist(imgpathdir0, imgdirs);
    save(fpath_imglist, 'fname_imglist');
else
    fprintf("Filename list exists.\n");
    load(fpath_imglist);
    fname_imglist
end


% カラーヒストグラムを作っておく（ない場合）
fpath_colorhistogram = "data/colorhistogram.mat";
if exist(fpath_colorhistogram, 'file') == 0
    colorhistograms = make_colorhistograms(fname_imglist);
    save(fpath_colorhistogram, 'colorhistograms');
else
    fprintf("Color histogram exists.\n");
    load(fpath_colorhistogram);
end


% BoFベクトルを作っておく（ない場合）
fpath_BoFs = "data/bofs.mat";
if exist(fpath_BoFs, 'file') == 0
    BoFs = make_BoFs(fname_imglist);
    save(fpath_BoFs, 'BoFs');
else
    fprintf("BoFs exists.\n");
    load("data/bofs.mat");
end


% AlexNetを用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_alexdcnn = "data/alexdcnn.mat";
if exist(fpath_alexdcnn, 'file') == 0
    alexdcnn = make_dcnn(alexnet, 'fc7', fname_imglist);
    save(fpath_alexdcnn, 'alexdcnn');
    size(alexdcnn)
else
    fprintf("AlexNet DCNN exists.\n");
    load("data/alexdcnn.mat");
end


% VGG16を用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_vgg16dcnn = "data/vgg16dcnn.mat";
if exist(fpath_vgg16dcnn, 'file') == 0
    vgg16dcnn = make_dcnn(vgg16, 'fc7', fname_imglist);
    save(fpath_vgg16dcnn, 'vgg16dcnn');
    size(vgg16dcnn)
else
    fprintf("VGG16 DCNN exists.\n");
    load("data/vgg16dcnn.mat");
end


% ResNet50を用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_resnet50dcnn = "data/resnet50dcnn.mat";
if exist(fpath_resnet50dcnn, 'file') == 0
    resnet50dcnn = make_dcnn(resnet50(), 'avg_pool', fname_imglist);
    save(fpath_resnet50dcnn, 'resnet50dcnn');
    size(resnet50dcnn)
else
    fprintf("ResNet50 DCNN exists.\n");
    load("data/resnet50dcnn.mat");
end


% DenseNet201を用いたDCNN特徴量ベクトルを作っておく（ない場合）
fpath_dense201dcnn = "data/dense201dcnn.mat";
if exist(fpath_dense201dcnn, 'file') == 0
    dense201dcnn = make_dcnn(densenet201, 'avg_pool', fname_imglist);
    save(fpath_dense201dcnn, 'dense201dcnn');
    size(dense201dcnn)
else
    fprintf("DenseNet201 DCNN exists.\n");
    load("data/dense201dcnn.mat");
end


% ---------------かつ丼とそばの組合せ------------------
% ------ 課題1-1 カラーヒストグラムと最近傍分類 --------
crate_histNN = calculate_classify_rate(1, 2, colorhistograms, 0, fname_imglist);
% ------ 課題1-2 BoFベクトルと非線形SVM --------
crate_BoFRBFSVM = calculate_classify_rate(1, 2, BoFs, 1, fname_imglist);
% ------ 課題1-3 DCNN特徴量と線形SVM ------
crate_alexdcnnSVM = calculate_classify_rate(1, 2, alexdcnn, 2, fname_imglist);


%%%%%%%%% 関数定義群 %%%%%%%%%%%
% (1, 2, colorhistograms, 1, fname_imglist)の場合、カラーヒストグラム、NNで分類
% typeの意味
% 0 : 最近傍分類による分類
% 1 : 非線形SVMによる分類
% 2 : 線形SVMによる分類
function crate = calculate_classify_rate(i_pos, i_neg, data, type, fname_imglist)
    num_pos = size(fname_imglist{i_pos}, 2);
    positive = data((i_pos-1)*num_pos+1:i_pos*num_pos, :);
    negative = data((i_neg-1)*num_pos+1:i_neg*num_pos, :);
    % ポジティブ画像、ネガティブ画像からそれぞれ学習データ、テストデータを作成する
    % 5-fold cross validation
    % (positive, negative, n個に分割, そのうちi番目の実験, ファイル名リストか否か)
    [train_data, class_data, train_label, class_label] = n_fold_cross_validation(positive, negative, 5, 1, 0);
    %ismember(train_data, class_data)

    % 分類率を求める
    switch type
        case 0
            crate = classify_with_colorhist_NN(train_data, class_data, train_label, class_label);
        case 1
            crate = classify_with_RBFSVM(train_data, class_data, train_label, class_label, 1);
        case 2
            crate = classify_with_LinearSVM(train_data, class_data, train_label, class_label, 1);
    end
end
% ---------------かつ丼とそばの組合せ------------------
% ------ 課題1-1 カラーヒストグラムと最近傍分類 --------
function crate_histNN = colorhistogram_NN(i_pos, i_neg, colorhistograms, fname_imglist)
    num_pos = size(fname_imglist{i_pos}, 2);
    positive = colorhistograms((i_pos-1)*num_pos+1:i_pos*num_pos, :);
    negative = colorhistograms((i_neg-1)*num_pos+1:i_neg*num_pos, :);
    % ポジティブ画像、ネガティブ画像からそれぞれ学習データ、テストデータを作成する
    % 5-fold cross validation
    % (positive, negative, n個に分割, そのうちi番目の実験, ファイル名リストか否か)
    [train_data, class_data, train_label, class_label] = n_fold_cross_validation(positive, negative, 5, 1, 0);
    %ismember(train_data, class_data)

    % 分類率を求める
    crate_histNN = classify_with_colorhist_NN(train_data, class_data, train_label, class_label)
end


% ------ 課題1-2 BoFベクトルと非線形SVM --------
function crate_BoFRBFSVM = BoF_RBFSVM(i_pos, i_neg, BoFs, fname_imglist)
    num_pos = size(fname_imglist{1}, 2);
    positive = BoFs((i_pos-1)*num_pos+1:i_pos*num_pos, :);
    negative = BoFs((i_neg-1)*num_pos+1:i_neg*num_pos, :);
    % ポジティブ画像、ネガティブ画像からそれぞれ学習データ、テストデータを作成する
    % 5-fold cross validation
    [train_data, class_data, train_label, class_label] = n_fold_cross_validation(positive, negative, 5, 1, 0);
    %ismember(train_data, class_data)

    % 分類率を求める
    crate_BoFRBFSVM = classify_with_RBFSVM(train_data, class_data, train_label, class_label, 0)
end


% ------ 課題1-3 DCNN特徴量と線形SVM ------
% ポジティブ画像、ネガティブ画像のファイル名リスト
function crate_alexdcnnSVM = alexdcnn_SVM(i_pos, i_neg, alexdcnn, fname_imglist)
    num_pos = size(fname_imglist{1}, 2);
    positive = alexdcnn((i_pos-1)*num_pos+1:i_pos*num_pos, :);
    negative = alexdcnn((i_neg-1)*num_pos+1:i_neg*num_pos, :);
    % ポジティブ画像、ネガティブ画像からそれぞれ学習データ、テストデータを作成する
    % 5-fold cross validation
    [train_data, class_data, train_label, class_label] = n_fold_cross_validation(positive, negative, 5, 1, 0);
    %ismember(train_data, class_data)

    % 分類率を求める
    crate_alexdcnnSVM = classify_with_LinearSVM(train_data, class_data, train_label, class_label, 1)
end
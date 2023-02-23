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
% 第１引数、第２引数はそれぞれ、ポジティブ画像とネガティブ画像のグループ番号
% 1 ... かつ丼, 2 ... そば, 3 ... 牛丼
fprintf("Katsudon - Soba\n");
% ------ 課題1-1 カラーヒストグラムと最近傍分類 --------
crate_histNN = calculate_classify_rate(1, 2, colorhistograms, 0, fname_imglist, "result_histNN1")
% ------ 課題1-2 BoFベクトルと非線形SVM --------
crate_BoFRBFSVM = calculate_classify_rate(1, 2, BoFs, 3, fname_imglist, "result_BoFRBFSVM1")
% ------ 課題1-3 AlexNetDCNN特徴量と線形SVM ------
crate_alexdcnnSVM = calculate_classify_rate(1, 2, alexdcnn, 2, fname_imglist, "result_alexdcnnSVM1")
% ------ その他 ---------
% ------ VGG16と線形SVM ------
crate_VGG16LinearSVM = calculate_classify_rate(1, 2, vgg16dcnn, 2, fname_imglist, "result_VGG16LinearSVM1")
% ------ BoFベクトルと線形SVM --------
crate_BoFLinearSVM = calculate_classify_rate(1, 2, BoFs, 4, fname_imglist, "result_BoFLinearSVM1")
% ------ ResNet50と線形SVM -------
crate_ResNet50LinearSVM = calculate_classify_rate(1, 2, resnet50dcnn, 2, fname_imglist, "result_ResNet50LinearSVM1")
% ------ DenseNet201と線形SVM ------
crate_DenseNet201LinearSVM = calculate_classify_rate(1, 2, dense201dcnn, 2, fname_imglist, "result_DenseNet201LinearSVM1")
% ------ VGG16と非線形SVM ------
crate_VGG16RBFSVM = calculate_classify_rate(1, 2, vgg16dcnn, 1, fname_imglist, "result_VGG16RBFSVM1")
% ------ ResNet50と非線形SVM -------
crate_ResNet50RBFSVM = calculate_classify_rate(1, 2, resnet50dcnn, 1, fname_imglist, "result_ResNet50RBFSVM1")
% ------ DenseNet201と非線形SVM ------
crate_DenseNet201RBFSVM = calculate_classify_rate(1, 2, dense201dcnn, 1, fname_imglist, "result_DenseNet201RBFSVM1")


% ---------------かつ丼と牛丼の組合せ------------------
% 第１引数、第２引数はそれぞれ、ポジティブ画像とネガティブ画像のグループ番号
% 1 ... かつ丼, 2 ... そば, 3 ... 牛丼
fprintf("Katsudon - Gyudon\n");
% ------ 課題1-1 カラーヒストグラムと最近傍分類 --------
crate_histNN = calculate_classify_rate(1, 3, colorhistograms, 0, fname_imglist, "result_histNN2")
% ------ 課題1-2 BoFベクトルと非線形SVM --------
crate_BoFRBFSVM = calculate_classify_rate(1, 3, BoFs, 3, fname_imglist, "result_BoFRBFSVM2")
% ------ 課題1-3 AlexNetDCNN特徴量と線形SVM ------
crate_alexdcnnSVM = calculate_classify_rate(1, 3, alexdcnn, 2, fname_imglist, "result_alexdcnnSVM2")
% ------ その他 ---------
% ------ VGG16と線形SVM ------
crate_VGG16LinearSVM = calculate_classify_rate(1, 3, vgg16dcnn, 2, fname_imglist, "result_VGG16LinearSVM2")
% ------ BoFベクトルと線形SVM --------
crate_BoFLinearSVM = calculate_classify_rate(1, 3, BoFs, 4, fname_imglist, "result_BoFLinearSVM2")
% ------ ResNet50と線形SVM -------
crate_ResNet50LinearSVM = calculate_classify_rate(1, 3, resnet50dcnn, 2, fname_imglist, "result_ResNet50LinearSVM2")
% ------ DenseNet201と線形SVM ------
crate_DenseNet201LinearSVM = calculate_classify_rate(1, 3, dense201dcnn, 2, fname_imglist, "result_DenseNet201LinearSVM2")
% ------ VGG16と非線形SVM ------
crate_VGG16RBFSVM = calculate_classify_rate(1, 3, vgg16dcnn, 1, fname_imglist, "result_VGG16RBFSVM2")
% ------ ResNet50と非線形SVM -------
crate_ResNet50RBFSVM = calculate_classify_rate(1, 3, resnet50dcnn, 1, fname_imglist, "result_ResNet50RBFSVM2")
% ------ DenseNet201と非線形SVM ------
crate_DenseNet201RBFSVM = calculate_classify_rate(1, 3, dense201dcnn, 1, fname_imglist, "result_DenseNet201RBFSVM2")



%%%%%%%%% 関数定義群 %%%%%%%%%%%
% (1, 2, colorhistograms, 1, fname_imglist)の場合、カラーヒストグラム、NNで分類
% typeの意味
% 0 : 最近傍分類による分類
% 1 : 非線形SVMによる分類(データはDCNN特徴量)
% 2 : 線形SVMによる分類(データはDCNN特徴量)
% 3 : 非線形SVMによる分類(データはDCNN特徴量以外)
% 4 : 線形SVMによる分類(データはDCNN特徴量以外)
function crate = calculate_classify_rate(i_pos, i_neg, data, type, fname_imglist, fname_result)
    num_pos = size(fname_imglist{i_pos}, 2);
    positive = data((i_pos-1)*num_pos+1:i_pos*num_pos, :);
    negative = data((i_neg-1)*num_pos+1:i_neg*num_pos, :);

    % n-fold cross validationによる分類率の計算
    crates = [];
    for i = 1:5
        % ポジティブ画像、ネガティブ画像からそれぞれ学習データ、テストデータを作成する
        % 5-fold cross validation
        % (positive, negative, n個に分割, そのうちi番目の実験, ファイル名リストか否か）
        fname_poslist = fname_imglist{i_pos};
        fname_neglist = fname_imglist{i_neg};
        [train_data, class_data, train_label, class_label, fname_classlist] = n_fold_cross_validation(positive, negative, fname_poslist, fname_neglist, 5, i);
        %ismember(train_data, class_data)
    
        % 分類率を求める
        switch type
            case 0
                [crate, plabel] = classify_with_colorhist_NN(train_data, class_data, train_label, class_label);
            case 1
                [crate, plabel] = classify_with_RBFSVM(train_data, class_data, train_label, class_label, 1);
            case 2
                [crate, plabel] = classify_with_LinearSVM(train_data, class_data, train_label, class_label, 1);
            case 3
                [crate, plabel] = classify_with_RBFSVM(train_data, class_data, train_label, class_label, 0);
            case 4
                [crate, plabel] = classify_with_LinearSVM(train_data, class_data, train_label, class_label, 0);
        end

        crates = [crates, crate];
    end

    % 分類された画像の一部を表示する
    fpath_resultdir = "result/";
    fpath_resultpos = fpath_resultdir + fname_result + "pos.jpg";
    fpath_resultneg = fpath_resultdir + fname_result + "neg.jpg";
    show_save_result(fname_classlist, plabel, fpath_resultpos, fpath_resultneg);

    crate = mean(crates);
end

% 5-fold cross validationに基づき、学習データ、テストデータを作成する

% positive ... ポジティブ画像データ（ヒストグラムやBoFベクトルなど）, negativeも同様
% (positive, negative) -> {train_data, class_data, train_label, class_label}
function [train_data, class_data, train_label, class_label, fname_classlist] = n_fold_cross_validation(positive, negative, fname_poslist, fname_neglist, n, ibanme)
    % テストデータと学習データの添え字を作成
    fname_class_index = sort( find(mod([1:size(fname_poslist, 2)], n) == ibanme-1) );

    class_index = sort( find(mod([1:size(positive, 1)], n) == ibanme-1) );
    train_index = find(~ismember([1:size(positive, 1)], class_index));


    % 学習データとテストデータを作成
    class_data = [positive(class_index, :); negative(class_index, :)];
    train_data = [positive(train_index, :); negative(train_index, :)];


    % ラベルを作成
    train_label = [ones( size(train_data, 1)/2, 1 ); (-1)*ones( size(train_data, 1)/2, 1 )];
    class_label = [ones( size(class_data, 1)/2, 1 ); (-1)*ones( size(class_data, 1)/2, 1 )];

    % 分類画像のファイル名リストを作成
    fname_classlist = { fname_poslist{ fname_class_index }, fname_neglist{ fname_class_index } };
    
end
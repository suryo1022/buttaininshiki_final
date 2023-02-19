% 5-fold cross validationに基づき、学習データ、テストデータを作成する

% positive ... ポジティブ画像データ（ヒストグラムやBoFベクトルなど）, negativeも同様
% (positive, negative) -> {train_data, class_data, train_label, class_label}
function [train_data, class_data, train_label, class_label] = n_fold_cross_validation(positive, negative, n, ibanme, isFilename)
    % テストデータと学習データの添え字を作成
    if isFilename == 1
        class_index = sort( find(mod([1:size(positive, 2)], n) == ibanme-1) );
        train_index = find(~ismember([1:size(positive, 2)], class_index));
    else
        class_index = sort( find(mod([1:size(positive, 1)], n) == ibanme-1) );
        train_index = find(~ismember([1:size(positive, 1)], class_index));
    end

    % 学習データとテストデータを作成
    % ファイル名リスト形式でデータが渡されたのか
    % それともヒストグラムやBoFベクトルが渡されたのか
    if isFilename == 1
        class_data = {positive{class_index}, negative{class_index}};
        train_data = {positive{train_index}, negative{train_index}};
    else
        class_data = [positive(class_index, :); negative(class_index, :)];
        train_data = [positive(train_index, :); negative(train_index, :)];
    end

    % ラベルを作成
    if isFilename == 1
        train_label = [ones( size(train_data, 2)/2, 1 ); (-1)*ones( size(train_data, 2)/2, 1 )];
        class_label = [ones( size(class_data, 2)/2, 1 ); (-1)*ones( size(class_data, 2)/2, 1 )];
    else
        train_label = [ones( size(train_data, 1)/2, 1 ); (-1)*ones( size(train_data, 1)/2, 1 )];
        class_label = [ones( size(class_data, 1)/2, 1 ); (-1)*ones( size(class_data, 1)/2, 1 )];
    end
    
end
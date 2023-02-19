% 線形SVM
% vec = カラーヒストグラムやBoFなど様々
% label = 学習データのポジティブ(1)、ネガティブ(-1)のラベル
function classify_rate = classify_with_LinearSVM(train_data, class_data, train_label, class_label, isDCNN)
    %tic;

    % 3倍拡張データを求める（DCNN特徴量の場合のみ）
    if isDCNN == 1
        % 学習データに対して
        sqrt_of_data = repmat( sqrt(abs(train_data)) .* sign(train_data), [1 3] );
        vector_of_data = [0.8*ones(size(train_data)) 0.6*cos(0.6*log( abs(train_data) + eps )) 0.6*sin(0.6*log( abs(train_data) + eps))];
        train_data = sqrt_of_data .* vector_of_data;

        % テストデータに対して
        sqrt_of_data = repmat( sqrt(abs(class_data)) .* sign(class_data), [1 3] );
        vector_of_data = [0.8*ones(size(class_data)) 0.6*cos(0.6*log( abs(class_data) + eps )) 0.6*sin(0.6*log( abs(class_data) + eps))];
        class_data = sqrt_of_data .* vector_of_data;
    end

    model = fitcsvm(train_data, train_label, 'KernelFunction', 'linear');
    [predicted_label, scores] = predict(model, class_data);
    %toc;
    classify_rate = numel(find(class_label == predicted_label)) / numel(class_label);
end
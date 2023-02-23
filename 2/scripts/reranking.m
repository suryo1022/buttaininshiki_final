% リランキングを行う
function sortedimglist = reranking(train_data, class_data, pos_num, neg_num, fname_testimglist)
    % 3倍拡張データを求める
    % 学習データに対して
    sqrt_of_data = repmat( sqrt(abs(train_data)) .* sign(train_data), [1 3] );
    vector_of_data = [0.8*ones(size(train_data)) 0.6*cos(0.6*log( abs(train_data) + eps )) 0.6*sin(0.6*log( abs(train_data) + eps))];
    train_data = sqrt_of_data .* vector_of_data;

    % テストデータに対して
    sqrt_of_data = repmat( sqrt(abs(class_data)) .* sign(class_data), [1 3] );
    vector_of_data = [0.8*ones(size(class_data)) 0.6*cos(0.6*log( abs(class_data) + eps )) 0.6*sin(0.6*log( abs(class_data) + eps))];
    class_data = sqrt_of_data .* vector_of_data;

    % ラベルを作成
    train_label = [ones(pos_num, 1); ones(neg_num, 1)*(-1)];


    model = fitcsvm(train_data, train_label, 'KernelFunction', 'linear');
    [predicted_label, scores] = predict(model, class_data);

    % 降順 ('descent') でソートして，ソートした値とソートインデックスを取得する
    [sorted_score,sorted_idx] = sort(scores(:,2),'descend');
    
    % list{:} に画像ファイル名が入っているとして，
    % sorted_idxを使って画像ファイル名，さらに
    % sorted_score[i](=score[sorted_idx[i],2])の値を出力します．
    sortedimglist = {};
    fname_testimglist{1}{sorted_idx(1)}
    for i=1:numel(sorted_idx)
        sortedimglist = {sortedimglist{:}, fname_testimglist{1}{sorted_idx(i)}};
    end

end
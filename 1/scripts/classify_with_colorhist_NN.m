function [classify_rate, predicted_label] = classify_with_colorhist_NN(train_data, class_data, train_label, class_label)
    % 全ての画像に対して、類似度を求める。
    num = size(class_data, 1);
    % 類似度と、正しく分類されたかの結果を入れる配列
    % 1行目、分類結果が正しい=1、正しくない=0
    % 2行目、類似する画像のインデックス
    sims = zeros(2, num);
    for i = 1:num
        index = calc_sim(train_data, class_data(i, :));
        judge = (train_label(index) == class_label(i));
        sims(1, i) = judge;
        sims(2, i) = index;
    end

    % 分類率を求める
    sum_of_judge = sum(sims, 2);
    predicted_label = sims;
    classify_rate = sum_of_judge(1) / num;

    index_missinpos = find(sims(1, 1:num/2) == 0);
    index_missinneg = find(sims(1, num/2+1:num) == 0);
    index_rightinneg = find(sims(1, num/2+1:num) == 1);
    sims(1, index_missinpos) = -1;
    sims(2, index_missinneg) = 1;
    sims(2, index_rightinneg) = -1;
    predicted_label = sims(1, :)';
end

% 最も似ている画像のインデックスを求める
% ユークリッド距離
function index = calc_sim(train_data, vec);
    n = size(train_data, 1);
    A1 = repmat(vec, n, 1);
    A2 = train_data;
    A = sqrt(sum((A1 - A2).^2, 2))';
    [m idx] = min(A);
    index = idx;
end
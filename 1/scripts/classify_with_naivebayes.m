% ナイーブベイズ法による分類
% vec = カラーヒストグラムやBoFなど様々
% label = 学習データのポジティブ(1)、ネガティブ(-1)のラベル
function [classify_rate, predicted_label] = classify_with_naivebayes(train_data, class_data, train_label, class_label)
    % 学習データのポジティブ画像、手酢とデータのポジティブ画像の枚数
    num_train_pos = size(train_data, 1)/2
    num_class_pos = size(class_data, 1)/2

    % positive 画像の出現確率(のlogの値の)テーブルを作成
    pr_pos = sum( train_data(1:num_train_pos, :) ) + 1;
    pr_pos = pr_pos/sum(pr_pos);
    pr_pos = log(pr_pos);
     
    % negative 画像の出現確率(のlogの値の)テーブルを作成
    pr_neg = sum( train_data(num_train_pos+1:num_train_pos*2, :) ) + 1;
    pr_neg = pr_neg/sum(pr_neg);
    pr_neg = log(pr_neg);
     
    pcount=0; % 正解数
    ncount=0; % 不正解数
     
    for t=1:num_class_pos %ポジティブ画像の分類
            im = class_data(t, :);
            
            max0 = max(im); 
            idx=[];
              for i=1:max0
                idx=[idx find(im>=i)];
              end
            % positive, negative 毎に 単語の出現確率値のlogの和を計算
            pr_im_pos=sum(pr_pos(idx));
            pr_im_neg=sum(pr_neg(idx));
     
            % ポジティブになれば正解
            if pr_im_pos>pr_im_neg
                pcount=pcount+1;
            else
                ncount=ncount+1;
            end
    end
     
    for t=num_class_pos+1:num_class_pos*2 %ネガティブ画像の分類
            im = class_data(t,:);
            
            max0=max(im); 
            idx=[];
              for i=1:max0
                idx=[idx find(im>=i)];
              end
            pr_im_pos=sum(pr_pos(idx));
            pr_im_neg=sum(pr_neg(idx));
            % positive, negative 毎に 単語の出現確率値のlogの和を計算
     
            % ネガティブになれば正解
            if pr_im_neg>pr_im_pos
                pcount=pcount+1;
            else
                ncount=ncount+1;
            end
    end
    
    classify_rate = double(pcount) / double(pcount+ncount);
end
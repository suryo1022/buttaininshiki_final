% リランキング結果を表示する

% （注意）ソート前とソート後の画像の枚数が等しいことを前提としている
function showresult(sortedimglist, beforeimglist, shownum, dirpath)
    num_imgpath = size(sortedimglist, 1);

    % リランキングされた画像の表示（２０枚毎にまとめる、１０枚がリランキング、１０枚がソート前）
    for i_path = 1:shownum
        if mod(i_path, 10) == 1
            %figure;
        end

        % ２０枚のまとめのうち、i_pos番目の画像という意味
        i_pos = mod(i_path, 10);
        if i_pos == 0
            i_pos = 15;
        elseif i_pos > 5
            i_pos = i_pos + 5;
        end

        % 画像を表示
        im_after = imread(sortedimglist{i_path});
        subplot(4, 5, i_pos);
        imshow(im_after);
        title('After Sort '+string(i_path));

        im_before = imread(beforeimglist{1}{i_path});
        subplot(4, 5, i_pos + 5);
        imshow(im_before);
        title('Before Sort '+string(i_path));

        % 画像を保存
        if mod(i_path, 10) == 0
            fpath = dirpath + string(i_path) + '.jpg';
            saveas(gcf, fpath);
        end
    end
end
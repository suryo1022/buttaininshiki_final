function show_save_result(fname_classlist, plabel, fpath_resultpos, fpath_resultneg)    
    % 分類された画像の一部を表示する
    size(plabel);
    boundary = size(plabel, 1)/2;
    index_missinpos = find(plabel(1:boundary) < 0);
    index_missinneg = find(plabel(boundary+1:boundary*2) > 0) + boundary;

    index_missinneg
    index_missinpos


    % 間違えてネガティブ画像として判定されてしまった画像を保存
    index_last = min(10, size(index_missinpos, 1));
    for i_img = 1:index_last

        % i_pos ... subplotで表示する際の何枚目の画像かを表す
        i_pos = i_img;

        im = imread(fname_classlist{index_missinpos(i_img)});
        subplot(2, 5, i_img);
        imshow(im);

        if i_img == index_last
            saveas(gcf, fpath_resultpos);
            fprintf("result saved\n");
        end
    end

    % 間違えてポジティブ画像として判定されてしまった画像を保存
    index_last = min(10, size(index_missinneg, 1));
    for i_img = 1:index_last

        % i_pos ... subplotで表示する際の何枚目の画像かを表す
        i_pos = i_img;

        im = imread(fname_classlist{index_missinneg(i_img)});
        subplot(2, 5, i_img);
        imshow(im);

        if i_img == index_last
            saveas(gcf, fpath_resultneg);
            fprintf("result saved\n");
        end
    end
end
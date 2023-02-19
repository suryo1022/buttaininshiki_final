% カラーヒストグラムを返す
function hists = make_colorhistograms(fname_imglist)
    hists = [];
    for i_dir = 1:size(fname_imglist, 2)
        for i_img = 1:size(fname_imglist{i_dir}, 2)
            X = imread(fname_imglist{i_dir}{i_img});

            % RGBごとに分ける
            RED = X(:,:,1);
            GREEN = X(:,:,2);
            BLUE = X(:,:,3);

            % 画素値を0~63の範囲で表現
            X64 = floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
            % X64の横ベクトル生成
            X64_vec = reshape(X64, 1, numel(X64));

            % ヒストグラム生成
            hists = [hists; histc(X64_vec, [0:63])];
            % ヒストグラムを表示
            %histogram(X64_vec, [0:63]);
        end
    end
end
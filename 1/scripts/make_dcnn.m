function dcnnf = make_dcnn(net, layer, fname_imglist)
    IM = [];
    for i_dir = 1:size(fname_imglist, 2)
        for i_img = 1:size(fname_imglist{i_dir}, 2)
            img = imread( fname_imglist{i_dir}{i_img} );
            reimg = imresize(img, net.Layers(1).InputSize(1:2));
            IM = cat(4, IM, reimg);
        end
    end

    % 中間特徴量を抽出する
    dcnnf = activations(net, IM, layer);

    % ベクトル化する
    dcnnf = squeeze(dcnnf)';

    % 正規化する、画像特徴量として利用する
    dcnnf = dcnnf / norm(dcnnf);
end
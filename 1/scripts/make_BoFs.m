% BoFベクトルを作成する

function BoFs = make_BoFs(fname_imglist)
    % コードブックを作成する（なければ）
    fpath_codebook = "data/codebook.mat";
    if exist(fpath_codebook, 'file') == 0
        codebook = make_codebook(fname_imglist);
        save(fpath_codebook, 'codebook');
    else
        load(fpath_codebook);
    end

    % BoFベクトルの作成
    n_hor = size(codebook, 1);
    n_ver = size(fname_imglist, 2) * size(fname_imglist{1}, 2);
    % サイズ(画像数)×(コードブックの領域数)の零行列
    bof = zeros(n_ver, n_hor);
    size(bof)


    num = 2000;
    for i_dir = 1:size(fname_imglist, 2)
        for i_img = 1:size(fname_imglist{i_dir}, 2)
            % 画像を読み込む
            I = rgb2gray( imread(fname_imglist{i_dir}{i_img}) );
            % 特徴を抽出(createRandomPoints)
            p = createRandomPoints(I, num);
            [f, p2] = extractFeatures(I, p);

            for i = 1:size(p2, 1)
                % コードブック中の最も似ているベクトルのindexを求める
                hor_index = vect_dist(codebook, f(i, :));
                % 投票
                ver_index = (i_dir-1)*size(fname_imglist{i_dir}, 2) + i_img;
                bof(ver_index, hor_index) = bof(ver_index, hor_index) + 1;
            end
        end
    end
    
    BoFs = bof ./ sum(bof,2);
end


% createRandomPoints関数
function PT=createRandomPoints(I,num)
    [sy sx]=size(I);
    sz=[sx sy];
    for i=1:num
        s=0;
        while s<1.6
            s=randn()*3+3;
        end
        p=ceil((sz-ceil(s)*2).*rand(1,2)+ceil(s));
        if i==1
            PT=[SURFPoints(p,'Scale',s)];
        else
            PT=[PT; SURFPoints(p,'Scale',s)];
        end
    end
end


% 第1回練習問題5の高速距離演算を行う関数（改造）
function index = vect_dist(codebook, feature)
    n = size(codebook, 1);
    % 二つのベクトルの差分をとるための行列を生成
    Cal1 = repmat(feature, n, 1);
    Cal2 = codebook;
    B2 = sqrt(sum((Cal1 - Cal2).^2, 2))';
    [m ind] = min(B2);
    index = ind;
end
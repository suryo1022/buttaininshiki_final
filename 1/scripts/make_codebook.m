% コードブックを作成

function codebook = make_codebook(fname_imglist)
    % 全画像のSURF特徴を抽出
    % 1枚につき300個ずつ
    num = 300;
    Features = [];
    for i_dir = 1:size(fname_imglist, 2)
        for i_img = 1:size(fname_imglist{i_dir}, 2)
            % グレースケール変換
            I = rgb2gray(imread(fname_imglist{i_dir}{i_img}));
            % SURF特徴を抽出
            %p = createRandomPoints(I, num);
            p = detectSURFFeatures(I);
            [f, p2] = extractFeatures(I, p);
            Features = [Features; f];

            if i_img == 1
                figure; imshow(I); hold on;
                plot(p2.selectStrongest(15), 'showOrientation', true);
            end
        end
    end

    % 5万個の特徴点をランダムに選ぶ
    sel = randperm(size(Features, 1), 50000);
    Features_random = Features(sel, :);

    % k-means法(k = 500)を実行し、コードブックを作成
    k = 500;
    [idx, codebook] = kmeans(Features_random, 500);
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
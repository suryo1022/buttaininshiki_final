% 画像ファイル名のリストを作成する
% fname_imglist = {katsudon, soba, gyudon}であり、
% katsudon = {~.jpg, ~.jpg; ...}, soba, gyudonも同様
function fname_imglist = make_imglist(imgpathdir0, imgdirs)
    n = 0; fname_imglist = {};

    for i = 1:length(imgdirs)
        fname_ingroup = {};
        DIR = strcat(imgpathdir0, imgdirs(i), '/')
        W = dir(DIR{:});

        for j = 1:size(W)
            if (strfind(W(j).name, '.jpg'))
                fn = strcat(DIR{:}, W(j).name);
                n = n+1;
                fprintf('[%d] %s\n', n, fn);
                fname_ingroup = {fname_ingroup{:}, fn};
            end
        end

        fname_imglist = {fname_imglist{:}, fname_ingroup};
    end
end
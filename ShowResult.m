function ShowResult()
global InputPath;
global OutputPath;

Cats =dir(InputPath);
Cats =Cats(3:end);
global outimgpath;
global flabel;
outimgpath=['../Result/Result_img/' flabel '/'];

for cc =1:length(Cats)
    cpath = [InputPath Cats(cc).name '/imgs/'];
     %gt path
    gtcpath = [InputPath Cats(cc).name '/' Cats(cc).name '_gt.txt'];
    fid= fopen(gtcpath,'r');
    GT=fscanf(fid,'%f');
    GT = reshape(GT,[5,length(GT)/5]);
    GTidx = GT(1,:);
    GT =GT(2:end,:);
    fclose(fid);
    salcpath = [OutputPath Cats(cc).name '/'];
    FrameEnum =dir([cpath '*.png']);
    if isempty(FrameEnum)
        FrameEnum =dir([cpath '*.jpg']);
    end
    if isempty(FrameEnum)
        FrameEnum =dir([cpath '*.bmp']);
    end
    if isempty(FrameEnum)
        FrameEnum =dir([cpath '*.tif']);
    end
    
    outimgcpath = [outimgpath Cats(cc).name '/'];
    if ~exist(outimgcpath)
        mkdir(outimgcpath);
    end
    nFrame =length(GT);
    scale=1;
    img =double(imresize(imread([cpath FrameEnum(1).name]),scale));
    
    overlap_ratio=[];
    CLE = [];
    for ff =2:length(GTidx)
        fidx= GTidx(ff);
%         fprintf('%d th frame\n',ff);
        if ~exist([salcpath num2str(fidx,'%04d') '.mat'],'file')
            continue;
        end
        img =double(imresize(imread([cpath FrameEnum(fidx).name]),scale));
        
        load([salcpath num2str(fidx,'%04d') '.mat']);
           
        bcy =(bbox(1)+bbox(3))/2;
        bcx =(bbox(2)+bbox(4))/2;
        gcy =(GT(2,ff)+GT(4,ff))/2;
        gcx =(GT(1,ff)+GT(3,ff))/2;
        CLE =[CLE;sqrt((bcy-gcy)^2 + (bcx-gcx)^2)];
        
%         figure(1);
%         subplot(2,1,1);
%         imshow(uint8(img));
%         title('img');
%         subplot(2,1,2);
%         imshow(BasicSal,[]);
%         title('Basic Sal');
%         hold on;
%         plot([bbox(2), bbox(2), bbox(4), bbox(4) ,bbox(2)],[bbox(1), bbox(3), bbox(3), bbox(1) ,bbox(1)],'r-');
%         plot([GT(1,ff), GT(3,ff), GT(3,ff), GT(1,ff) ,GT(1,ff)],[GT(2,ff), GT(2,ff), GT(4,ff), GT(4,ff) ,GT(2,ff)],'g-');
%         hold off;
%         drawnow();
        result_binary = zeros(size(img,1),size(img,2));
        result_binary(bbox(1):bbox(3), bbox(2):bbox(4))=1;
        gt_binary= zeros(size(img,1),size(img,2));
        gt_binary(GT(2,ff):GT(4,ff), GT(1,ff):GT(3,ff))=1;
        overlap_ratio = [overlap_ratio; sum(sum(result_binary & gt_binary))./sum(sum(result_binary | gt_binary))];
        imwrite(uint8(BasicSal>0)*255,[outimgcpath num2str(ff,'%04d') '.jpg']);
%         combimg(1:size(img,1),:,:) = uint8(img);
%         combimg(1+size(img,1):end,:,:) = repmat(uint8(BasicSal*255), [1 1 3]);
%         resvideo(:,:,:,ff) =uint8( combimg);
%         pause;
        
    end
    if ~exist([OutputPath Cats(cc).name '/'],'dir')
        mkdir([OutputPath Cats(cc).name '/'])
    end
    
    fprintf('%s %.1f\n', Cats(cc).name, mean(overlap_ratio)*100);
    save([OutputPath Cats(cc).name '/' Cats(cc).name '_BB_overlap.mat'], 'overlap_ratio','CLE');
%      writerObj = VideoWriter('./diving_org.avi');
%      open(writerObj);
%      writeVideo(writerObj,uint8(resvideo))
%      close(writerObj);
%      clear writerObj;
end
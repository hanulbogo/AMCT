function ShowResult_Seg_NRD()
global InputPath;
global OutputPath;
global GTPath;
Cats =dir(InputPath);
Cats =Cats(3:end);
global outimgpath;

    
sf =[0 0 0 1 1 0 1 0 0 0 0];
sf = 1-sf;
% 8 cliff-dive1 0
% 9 cd2 0
% 1 diving 0
% 2 gym 0
% 3 hj 0
% 10 mc1 0
% 11 mc2 0
% 4 MB 1
% 5 ski gt는 1로 되어있음
% 6 trans 0
% 7 volley1

for cc =1:length(Cats)
    cpath = [InputPath Cats(cc).name '/imgs/'];
    gtcpath = [InputPath Cats(cc).name '/' Cats(cc).name '_gt.txt'];
    fid= fopen(gtcpath,'r');
    GT=fscanf(fid,'%f');
    GT = reshape(GT,[4,length(GT)/4]);
    GT=GT(~isnan(GT));
    GT= reshape(GT, [4,length(GT)/4]);
    fclose(fid);
    
    gtcpath= [GTPath Cats(cc).name '/masks/'];
    salcpath = [OutputPath Cats(cc).name '/'];
    
    GTEnum =dir([gtcpath '*.png']);
    if isempty(GTEnum)
        GTEnum =dir([gtcpath '*.jpg']);
    end
    if isempty(GTEnum)
        GTEnum =dir([gtcpath '*.tif']);
    end
    if isempty(GTEnum)
        GTEnum =dir([gtcpath '*.bmp']);
    end
   sumoverlap=0;sumunion =0;
           overlap_ratio=[];
    for ff =1: length(GTEnum)
        gtimg = imread([gtcpath GTEnum(ff).name]);
        if size(gtimg,3)==3
            gtimg =rgb2gray(gtimg);
        end
        if ~islogical(gtimg)
            gtimg(gtimg<128)=0;
            gtimg(gtimg>=128)=1;
        end
        gtimg =double(gtimg);
        
        %
        idx =str2num(GTEnum(ff).name(end-7:end-4))+sf(cc);
        if idx==1 || idx>length(GT)
            continue;
        end
        
        if ~exist([salcpath num2str(idx,'%04d') '.mat'],'file')
            continue;
        end
        load([salcpath num2str(idx,'%04d') '.mat']);
        segimg= double(BasicSal>0);
        overlapimg =(segimg .* gtimg);
        sumimg = double((segimg+gtimg)>0);
        
        %         figure(2);imshow(overlapimg);
        %         figure(3);imshow(sumimg);
        sumoverlap =sum(overlapimg(:));
        sumunion = sum(sumimg(:));
        
        overlap_ratio = [overlap_ratio; sumoverlap/ (sumunion+eps)];
        imwrite(uint8(segimg*255), [outimgpath Cats(cc).name '/' num2str(idx,'%04d') '.jpg']);
%         
%         figure(1);
%         subplot(2,1,1);
%         imshow(segimg,[]);
%         subplot(2,1,2);
%         imshow(gtimg,[]);
%         drawnow()
% % %         pause;
    end
    if ~exist([OutputPath Cats(cc).name '/'],'dir')
        mkdir([OutputPath Cats(cc).name '/'])
    end
    
    fprintf('%s %.1f \n', Cats(cc).name, mean(overlap_ratio)*100);
    save([salcpath,Cats(cc).name '_seg_overlap.mat'], 'overlap_ratio');
    
%      writerObj = VideoWriter('./diving_org.avi');
%      open(writerObj);
%      writeVideo(writerObj,uint8(resvideo))
%      close(writerObj);
%      clear writerObj;
end
fprintf('\n\n');
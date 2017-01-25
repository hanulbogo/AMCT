function ShowResult_Seg_DAVIS()
global InputPath;
global OutputPath;
global GTPath;
global outimgpath;
Cats =dir(InputPath);
Cats =Cats(3:end);
% global outimgpath;
% outimgpath=['./Result_img/' flabel '/'];

for cc =1:length(Cats)
    cpath = [InputPath Cats(cc).name '/imgs/'];
    gtcpath= [GTPath Cats(cc).name '/'];
    salcpath = [OutputPath Cats(cc).name '/'];
    outimgcpath =[outimgpath Cats(cc).name '/'];
    
    if ~exist(outimgcpath,'dir')
        mkdir(outimgcpath);
    end
    
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
        idx =str2num(GTEnum(ff).name(1:end-4));
%         if idx==1
%             continue;
%         end
        
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
        
%         figure(1);
%         subplot(2,1,1);
%         imshow(segimg,[]);
%         subplot(2,1,2);
%         imshow(gtimg,[]);
%         drawnow();
%         imwrite(uint8(BasicSal>0)*255,[outimgcpath num2str(idx,'%04d') '.jpg']);
%         pause;
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
function TrackingMain_SaliencyDataset()
global SupFlag;
global InputPath;
global OutputPath;
global OFroot;
global K;
global flabel;
global Ncol;
Cats =dir(InputPath);
Cats =Cats(3:end);
global ff;
global oimgcpath;

global rowind;
global colind;

global CenterPosition;

global bsize;
global csize;
global cmask;

global outimgpath;
global outimgcpath;
global GTPath;
global KK;
global st;
% global outimgpath;
% csize =0.65;
% bsize =0.6;
csize =0.5;
bsize =0.45;


%For each Category
% hgamma = vision.GammaCorrector(2.0,'Correction','De-gamma');
for cc =1:length(Cats)%[1:6 8:9]%10:length(Cats)]
    %video path
    cpath = [InputPath Cats(cc).name '/imgs/'];
    %gt path
    gtcpath = [GTPath Cats(cc).name '/'];
    %saliency map path
    %     salcpath = [OutputPath Cats(cc).name '/'];
    %optical flow path
    OFcpath = [OFroot Cats(cc).name '/'];
    
    if ~exist(OFcpath,'dir')
        mkdir(OFcpath);
    end
    K=KK;
    FrameEnum =dir([cpath '*.jpg']);
    if isempty(FrameEnum)
        FrameEnum =dir([cpath '*.png']);
    end
    if isempty(FrameEnum)
        FrameEnum =dir([cpath '*.bmp']);
    end
    nFrame =length(FrameEnum);
    
    %% For the first frame
    
    
    
    st=1;
    ff=st;
    
    fprintf('%s %d /%d frame\n', Cats(cc).name, ff,nFrame);
    
    img =double(imread([cpath FrameEnum(ff).name]));
%     next_img= single(imread([cpath FrameEnum(ff+1).name]));
    orgrow = size(img,1);
    orgcol = size(img,2);
    salcpath = [OutputPath Cats(cc).name '/'];
    oimgcpath=salcpath;
    outimgcpath= [outimgpath Cats(cc).name '/'];
    
    if ~exist(outimgcpath,'dir')
        mkdir(outimgcpath);
    end
    if ~exist(salcpath ,'dir')
        mkdir(salcpath);
    end
    if ~exist(salcpath ,'dir')
        mkdir(salcpath);
    end
    
    GTEnum = dir([gtcpath  '*.jpg']);
    if isempty(GTEnum)
        GTEnum =dir([gtcpath  '*.png']);
    end
    if isempty(GTEnum)
        GTEnum =dir([gtcpath  '*.bmp']);
    end
    if isempty(GTEnum)
        GTEnum =dir([gtcpath  '*.tif']);
    end
    gtimg = imread([gtcpath GTEnum(ff).name]);
     if size(img,3)==1
        img = repmat(img,[1 1 3]);
    end
    [xx, yy]= meshgrid(1:size(gtimg,2),1:size(gtimg,1));
    if size(gtimg,3)==3
        gtimg = rgb2gray(gtimg);
    end
    xs =xx(gtimg>0);
    ys =yy(gtimg>0);
    GT= [min(xs); min(ys); max(xs); max(ys)];
    
   
%     fid= fopen([InputPath Cats(cc).name '/' Cats(cc).name '_gt.txt'],'w');
%     fprintf(fid, '%e %e %e %e\n', GT(1,ff), GT(2,ff), GT(3,ff), GT(4,ff));
%     fclose(fid);
%     
    boxw= GT(3,ff)- GT(1,ff)+1;
    boxh= GT(4,ff)-GT(2,ff)+1;
    CenterPosition =[boxh/2, boxw/2];
    PriorSal = zeros(size(img(:,:,1)));
    PriorSal(GT(2,ff):GT(4,ff), GT(1,ff):GT(3,ff))=1;
    
    rowind = max(GT(2,ff)-floor(boxh*0.25),1):min(GT(4,ff) + floor(boxh*0.25),size(img,1));
    colind = max(GT(1,ff)-floor(boxw*0.25),1):min(GT(3,ff) + floor(boxw*0.25),size(img,2));
    
    bcolind = max(GT(1,ff)-floor(boxw*0),1):min(GT(3,ff) + floor(boxw*0),size(img,2));
    browind = max(GT(2,ff)-floor(boxh*0),1):min(GT(4,ff) + floor(boxh*0),size(img,1));
    Params.corgimg=img;
    cmask= zeros(size(img,1), size(img,2));
    cmask(rowind, colind)=1;
    cmask(browind, bcolind)=0;
    cmask =cmask(rowind, colind);
    img = img(rowind, colind,:);
    PriorSal =PriorSal(rowind,colind);
    %Visualize optical flow
    %     [ OFImg ] = flow_visualization( wx, wy );
    
    %%Original Color Saliency and Superpixel Computation
    [Label, SupCol, ConPix, ConPixDouble, EdgSupORG]=InitialGraphConstruction(double(img),K,Ncol,SupFlag);
    
    Params.img=img;
    %     Params.PriorOFSalpix=OFSalpix;
    
    Params.PriorSal= PriorSal;
    Params.Label =Label;
    %     Params.OFImg =OFImg;
    Params.salcpath=salcpath;
    Params.ff =ff;
    Params.flabel=flabel;
    Params.SupCol=SupCol;
    Params.EdgSup= EdgSupORG;
    Params.Ncol=Ncol;
    Params.orgrow= orgrow;
    Params.orgcol= orgcol;
    
    
    [Salpix,Sal,bbox]=InitialSegmentation(Params);
 
    
    PP.img=img;
    PP.pK=max(Label(:))+1;
    PP.ConPix=ConPix;
    PP.ConPixDouble=ConPixDouble;
    PP.SupCol=SupCol;
    PP.Label=Label;
    PP.Saliency= Sal; % Superpixel Saliency not pixels
    PP.K=K;
    PP.Ncol=Ncol;
    %     PriorSal(PP.bbox(1):PP.bbox(3), PP.bbox(2):PP.bbox(4))=1;
    PP.bbox=[GT(2,ff);GT(1,ff);GT(4,ff); GT(3,ff)];
    PP.rowind =rowind;
    PP.colind=colind;
    PP.orgrow=orgrow;
    PP.orgcol=orgcol;
    PP.Salpix = Salpix;
    PP.Priorbbox = PP.bbox;
    sff=ff;
    
    for ff =sff+1: nFrame
       
        fprintf('%s %d /%d frame\n', Cats(cc).name, ff,nFrame);
        prev_img= single(imread([cpath FrameEnum(ff-1).name]));
        img=single(imread([cpath FrameEnum(ff).name]));
        
        if size(img,3)==1
            img = repmat(img,[1 1 3]);
            prev_img=repmat(prev_img,[1,1,3]);
        end
        
        %load or compute optical flow
        if ~exist([OFcpath num2str(ff-1) '_' num2str(ff)  '.mat'],'file')
            uv = EPPM(uint8(prev_img),uint8(img));
            if sum(sum(uv(:,:,1)>1000))
                uv=-EPPM(uint8(img),uint8(prev_img));
            end
            wx = imresize(uv(:,:,1),[size(prev_img,1), size(prev_img,2)]);
            wy = imresize(uv(:,:,2),[size(prev_img,1), size(prev_img,2)]);
            save([OFcpath num2str(ff-1) '_' num2str(ff)  '.mat'],'wx','wy');
        else
            
            load([OFcpath num2str(ff-1) '_' num2str(ff)  '.mat']);
            
        end
        OF_PC.wx = wx;
        OF_PC.wy = wy;
        clear wx wy;
        
        PriorSal=PropPrevSal(PP.Salpix, OF_PC.wx,OF_PC.wy);
        [xx, yy]= meshgrid(1:size(img,2),1:size(img,1));
        xs =xx(PriorSal>0);
        ys =yy(PriorSal>0);
        Priorbbox = [min(ys); min(xs); max(ys); max(xs)];
        if isempty(Priorbbox)
            Priorbbox= bbox;
        end
    
        boxh= Priorbbox(3)- Priorbbox(1)+1;
        boxw= Priorbbox(4)-Priorbbox(2)+1;
        boxh = max(20, boxh);
        boxw = max(20, boxw);
        
        Priorbbox(3)= min(floor((Priorbbox(3)+ Priorbbox(1)+boxh)/2), size(img,1));
        Priorbbox(1)= max(floor((Priorbbox(3)+ Priorbbox(1)-boxh)/2), 1);
        
        Priorbbox(4)= min(floor((Priorbbox(4)+ Priorbbox(2)+boxw)/2), size(img,2));
        Priorbbox(2)= max(floor((Priorbbox(4)+ Priorbbox(2)-boxw)/2), 1);
        
        CenterPosition =[boxh/2, boxw/2];
        colind = max(Priorbbox(2,1)-floor(boxw*csize),1):min(Priorbbox(4,1) + floor(boxw*csize),size(img,2));
        rowind = max(Priorbbox(1,1)-floor(boxh*csize),1):min(Priorbbox(3,1) + floor(boxh*csize),size(img,1));
        bcolind = max(Priorbbox(2,1)-floor(boxw*bsize),1):min(Priorbbox(4,1) + floor(boxw*bsize),size(img,2));
        browind = max(Priorbbox(1,1)-floor(boxh*bsize),1):min(Priorbbox(3,1) + floor(boxh*bsize),size(img,1));
        PP.bbox = Priorbbox;
  
        orgimg=img;
        PP.corgimg =orgimg;
        img = img(rowind, colind,:);
        cmask= zeros(size(orgimg,1), size(orgimg,2));
        cmask(rowind, colind)=1;
        cmask(browind, bcolind)=0;
        cmask =cmask(rowind, colind);
        
        rowtrans = PP.rowind(1)- rowind(1);
        coltrans = PP.colind(1)- colind(1);
        OF_PC.wx= OF_PC.wx(PP.rowind,PP.colind)+coltrans;
        OF_PC.wy =OF_PC.wy(PP.rowind,PP.colind)+rowtrans;
        OF_CP.wx= -OF_PC.wx;
        OF_CP.wy =-OF_PC.wy;
        PP.K=floor(KK/ ((GT(4,1)-GT(2,1))*(GT(3,1)- GT(1,1)))*(PP.bbox(4,1)-PP.bbox(2,1))*(PP.bbox(3,1)-PP.bbox(1,1)));
        
        if PP.K>KK
            PP.K=KK;
        end
        PP.Priorbbox = Priorbbox;
        
        [BasicSal, PP]=PropAMC_OneDirection(img,PP,OF_PC,OF_CP,SupFlag);

        bbox = PP.bbox;

        save([salcpath num2str(ff,'%04d') '.mat'], 'BasicSal','bbox');
    end
end



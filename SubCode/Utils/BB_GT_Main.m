function BB_GT_Main()

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
    fpath = [InputPath Cats(cc).name '/' Cats(cc).name '_gt.txt'];
    fid =fopen(fpath,'w');
    for ff =1: length(GTEnum)
       
        GT= zeros(length(GTEnum),4);
        gtimg = imread([gtcpath GTEnum(ff).name]);

        [xx, yy]= meshgrid(1:size(gtimg,2),1:size(gtimg,1));
        if size(gtimg,3)==3
            gtimg = rgb2gray(gtimg);
        end
        xs =xx(gtimg>0);
        ys =yy(gtimg>0);
%         [min(xs); min(ys); max(xs); max(ys)];
        fprintf(fid,'%f %f %f %f\n',min(xs), min(ys), max(xs), max(ys));
    end
    fclose(fid);
end



function [Salpix ,PP]=PropAMC_OneDirection(img,PP,OF_PC,OF_CP,SupFlag)
%PP.img;
%PP.pK;
%PP.ConPixDouble;
%PP.SupCol;
%PP.Label;
%PP.Saliency; % Superpixel Saliency not pixels
% OF_PC.wx;
% OF_PC.wy;
%OF_CP.wx;
%OF_CP.wy;

global rowind;
global colind;

global oldCol;
global oldLabel;

global lastcol;
global lastlabel;

global ldamodel;
global ff;

global meanval ;
global stdval
global st;

%1 현재 frame의 superpixel을 구함.
[ height,width ] = size(img(:,:,1));

cK=PP.K;
if height*width<cK
    cK=floor((min(height,width)^2)/2);
end
if max(height,width)>cK
    cK = max(height,width);
end

[Label,Sup1, Sup2 ,Sup3, cK] = SLIC_SupPix(double(img), cK);

%2 현재 frame의 그래프를 형성
[ConPix, ConPixDouble,SP.cEdgSup]=ACM_Init_Simple(Label,cK,height,width);

Ncol=PP.Ncol;
SLICCol =[Sup1';Sup2';Sup3'];

SupCol= SupColor(uint8(img), Label,Ncol,SLICCol,ConPix);

% SupCol= SupHist(uint8(img), Label,Ncol,SLICCol);

SP.Ncol=Ncol;

%%%%%%%%%% optical flow edge connection
PC_Conpix = OFConpix_Tracking(PP.pK, cK, PP.Label, Label, OF_PC);
CP_Conpix =PC_Conpix';

global multiplier;

SP.OF_PC = OF_PC;
SP.OF_CP = OF_CP;

SP.pSaliency =PP.Saliency;

%imgs
SP.cimg =img;
SP.pimg =PP.img;

%Labels
SP.pLabel=PP.Label;
SP.cLabel=Label;

% # of sups
SP.K =cK + PP.pK;
SP.pK = PP.pK;
SP.cK = cK;

%conpix
SP.ConPixAll =[[PP.ConPixDouble, PC_Conpix] ; [CP_Conpix, ConPixDouble]];

SP.pConPix = PP.ConPix;
SP.cConPix = ConPix;

SP.cConPixDouble =ConPixDouble;
SP.pConPixDouble =PP.ConPixDouble;

%superpixel color
SP.SupCol = cellfun(@horzcat,PP.SupCol, SupCol,'UniformOutput',0);

SP.pSupCol =PP.SupCol;
SP.cSupCol =SupCol;

Salpix= zeros(PP.orgrow,PP.orgcol);



EdgCol =SP.cSupCol{1}(:,SP.cEdgSup==1)';

if ff>st+1
    labels = [oldLabel;lastlabel;zeros(size(EdgCol,1),1)];
    labels(labels==0) = -1;
    meanval = mean([oldCol;lastcol;EdgCol],1);
    stdval =std([oldCol;lastcol;EdgCol],1);
    ldamodel = svmtrain(double(labels),svmnormalize([oldCol;lastcol;EdgCol]),'-s 3 -t 2 -c 10 -g 1 -h 0 -q');
else
    meanval = mean([oldCol;EdgCol],1);
    stdval =std([oldCol;EdgCol],1);
    labels = [oldLabel;zeros(size(EdgCol,1),1)];
    labels(labels==0) = -1;
    ldamodel = svmtrain(double(labels),svmnormalize([oldCol;EdgCol]),'-s 3 -t 2 -c 10 -g 1 -h 0 -q');
end

[Salpix(rowind, colind),cSal]=VAMC_TargetSegmentation(SP);

global targethist;

sth =mean(cSal)*multiplier;
Salpix(Salpix<sth)=0;
PP.orgSalpix= Salpix>0;
cSal(cSal<sth)=0;

Aff =ConPixDouble;
Aff(cSal==0, :)=0;
Aff(:,cSal==0)=0;

[nseg, CC]=graphconncomp(sparse(Aff>0));
nnseg =0;
Clist = zeros(nseg,1);
global nbins;

for ii = 1: nseg
    if sum(cSal(CC==ii)>0)>0
        nnseg = nnseg+1;
        Clist(nnseg)=ii;
    end
end
if nnseg==0
    bbox= PP.bbox;
    cSal= ones(size(cSal));
    Salpix(rowind, colind)=sup2pixel2(cSal,SP.cLabel);
    
else
    Clist=Clist(1:nnseg);
    [xx, yy]= meshgrid(1:PP.orgcol,1:PP.orgrow);
    
    pSal = cell(nnseg,1);
    pSalpix = cell(nnseg,1);
    bbox = cell(nnseg,1);
    phist= cell(nnseg,1);
    bval = zeros(nnseg,1);

    for ii = 1: nnseg
        pSal{ii} = zeros(size(cSal));
        pSal{ii}(CC== Clist(ii))=cSal(CC== Clist(ii));
        pSalpix{ii} = zeros(PP.orgrow,PP.orgcol);
        pSalpix{ii}(rowind, colind)=sup2pixel2(pSal{ii},SP.cLabel);
        
        xs =xx(pSalpix{ii}>0);
        ys =yy(pSalpix{ii}>0);
        bbox{ii} = [min(ys); min(xs); max(ys); max(xs)];
        
        if sum(sum(pSalpix{ii}>0))>100
            phist{ii} = rgbhist_fast(SP.cimg,pSalpix{ii}(rowind,colind),nbins,1);
            bval(ii) = sum(sqrt(targethist.*phist{ii}));
        else
            phist{ii} =targethist;
            bval(ii) =0;
        end
    end
    
  
    [mval, midx]=max(bval);
    if mval==0
        xs =xx(Salpix>0);
        ys =yy(Salpix>0);
        bbox = [min(ys); min(xs); max(ys); max(xs)];
    else
        
        bbox =bbox{midx};
        cSal = pSal{midx};
        Salpix = pSalpix{midx};
        newhist = phist{midx};
        targethist = (newhist*0.1+targethist*0.9);
    end
end


lastlabel = cSal>sth;
lastcol = SP.cSupCol{1}';

figure(101);
subplot(2,1,1);
imshow(Salpix>0);
hold on;
plot([bbox(2), bbox(2), bbox(4), bbox(4) ,bbox(2)],[bbox(1), bbox(3), bbox(3), bbox(1) ,bbox(1)],'r-');
hold off;
subplot(2,1,2);
imshow(uint8(PP.corgimg));
hold on;
plot([bbox(2), bbox(2), bbox(4), bbox(4) ,bbox(2)],[bbox(1), bbox(3), bbox(3), bbox(1) ,bbox(1)],'r-');
hold off;
drawnow();
% % pause;
% if ff==280
%     ff;
% end
% %     targethist = (newhist*0.3+targethist*0.7);


% fprintf('Total Saliency : %f\n ',ttt);
Salpix = Salpix>0;
PP.img = img;
PP.pK = cK;
PP.ConPix = ConPix;
PP.ConPixDouble= ConPixDouble;
PP.SupCol = SupCol;
PP.Label = Label;
PP.Saliency = cSal;
PP.Salpix = Salpix;
PP.bbox=bbox(1:4);
PP.rowind = rowind;
PP.colind = colind;
PP.orgimg = PP.corgimg;

% pause;

end


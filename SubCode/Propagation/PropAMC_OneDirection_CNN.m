function [Salpix ,PP]=PropAMC_OneDirection_CNN(img,cnnfeat,PP,OF_PC,OF_CP,SupFlag)

[ height,width ] = size(img(:,:,1));

cK=PP.K;
if height*width<cK
    cK=floor((min(height,width)^2)/2);
end
if max(height,width)>cK
    cK = max(height,width);
end

% global SupFlag;
if SupFlag==1
    [Label,Sup1, Sup2 ,Sup3, cK] = SLIC_SupPix(double(img), cK);
elseif SupFlag==4
    [Label,Sup1, Sup2 ,Sup3, cK] = MMLP_SupPix(double(img), cK);
end


%2 현재 frame의 그래프를 형성
[ConPix, ConPixDouble,SP.cEdgSup]=AMC_Init_Simple(Label,cK,height,width);

Ncol=PP.Ncol;
SLICCol =[Sup1';Sup2';Sup3'];

SupCol= SupColor_CNN(cnnfeat, Label,Ncol,SLICCol);


SP.Ncol=Ncol;

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


for cc=1:Ncol
    EdgCol =SP.cSupCol{cc}(:,SP.cEdgSup==1)';
    if ff>st+1
        labels = [oldLabel;lastlabel;zeros(size(EdgCol,1),1)];
        labels(labels==0) = -1;
        meanval{cc} = mean([oldCol{cc}';lastcol{cc}';EdgCol],1);
        stdval{cc} =std([oldCol{cc}';lastcol{cc}';EdgCol],1);
        if cc==1
            ldamodel{cc} = svmtrain(double(labels),svmnormalize_CNN([oldCol{cc}';lastcol{cc}';EdgCol],cc),'-s 3 -t 2 -c 10 -g 1 -h 0 -q');
        else
            ldamodel{cc} = svmtrain(double(labels),([oldCol{cc}';lastcol{cc}';EdgCol]),'-s 3 -h 0 -q');
        end
    else
        meanval{cc} = mean([oldCol{cc}';EdgCol],1);
        stdval{cc} =std([oldCol{cc}';EdgCol],1);
        labels = [oldLabel;zeros(size(EdgCol,1),1)];
        labels(labels==0) = -1;
        if cc==1
            ldamodel{cc}= svmtrain(double(labels),svmnormalize_CNN([oldCol{cc}';EdgCol],cc),'-s 3 -t 2 -c 10 -g 1 -h 0 -q');
        else
            ldamodel{cc} = svmtrain(double(labels),[oldCol{cc}';EdgCol],'-s 3 -q');
        end
    end
end

[Salpix(rowind, colind),cSal]=VAMC_TargetSegmentation_CNN(SP);

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


lastlabel = cSal>sth;
lastcol = SP.cSupCol;

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

end


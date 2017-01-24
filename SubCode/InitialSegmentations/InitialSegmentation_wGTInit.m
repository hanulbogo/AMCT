function [BasicSal,Sal,bbox] =InitialSegmentation_wGTInit(Params)
global supth;
se = strel('sphere',floor(sqrt(size(Params.gtimg,1)*size(Params.gtimg,2)/max(Params.Label(:)))));
priorsal =double(imdilate(Params.gtimg,se ));
priorsal =normalize(priorsal);

priorSal = Pix2SupTh((priorsal), Params.Label,supth);
EdgSup =zeros(size(priorSal));
EdgSup(priorSal==0) = 1;
[L, Sal]=AMCSegmentation(double(Params.img), Params.Label, Params.SupCol,EdgSup, Params.Ncol);

global multiplier;
global rowind;
global colind;

BasicSal= zeros(Params.orgrow,Params.orgcol);
BasicSal(rowind, colind)=imgnormalize(L);
sth =mean(BasicSal(:))*multiplier;
BasicSal(BasicSal<sth) =0;
Sal(Sal<sth)=0;

global oldCol;
global oldLabel;

% oldCol =Params.SupCol{1}';
oldCol =Params.SupCol;

oldLabel = double(Sal>0);
global targethist;
global nbins;
targethist = rgbhist_fast(Params.img,sup2pixel2((oldLabel),Params.Label),nbins,1);

figure(1);
subplot(2,1,1);
imshow(uint8(Params.img));
subplot(2,1,2);
imshow(BasicSal(rowind,colind)>0);
drawnow();

[xx, yy]= meshgrid(1:Params.orgcol,1:Params.orgrow);
xs =xx(BasicSal>0);
ys =yy(BasicSal>0);
bbox = [min(ys); min(xs); max(ys); max(xs)];

save([Params.salcpath num2str(Params.ff,'%04d') '.mat'], 'BasicSal','bbox');

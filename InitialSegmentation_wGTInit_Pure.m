function [BasicSal,Sal,bbox] =InitialSegmentation_wGTInit_Pure(Params)
global supth;
L =Params.gtimg;
Sal= Pix2SupTh(Params.gtimg, Params.Label,supth);

global rowind;
global colind;

BasicSal= zeros(Params.orgrow,Params.orgcol);
BasicSal(rowind, colind)=double(L);

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

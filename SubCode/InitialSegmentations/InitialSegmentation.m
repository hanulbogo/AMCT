function [BasicSal,Sal,bbox] =InitialSegmentation(Params)

global supth;
SeedSup = Pix2SupTh(Params.PriorSal, Params.Label,supth);

EdgSup =zeros(size(SeedSup));
EdgSup(SeedSup==0) = 1;
[L, Sal]=AMCSegmentation(double(Params.img), Params.Label, Params.SupCol,EdgSup, Params.Ncol);

global multiplier;
global rowind;
global colind;

BasicSal= zeros(Params.orgrow,Params.orgcol);
BasicSal(rowind, colind)=imgnormalize(L);
figure(3);
subplot(2,1,1);
imshow(BasicSal,[]);
subplot(2,1,2);
imshow(BasicSal,[]);
drawnow();

% sth=0.1;
sth = mean(BasicSal(:))*1;
% sth = mean(L(:))*multiplier;
% sth =mean(Sal);
BasicSal(BasicSal<sth) =0;
BasicSal(BasicSal>=sth) =1;
Sal(Sal<sth)=0;

global oldCol;
global oldLabel;


oldCol =Params.SupCol{1}';
oldLabel = Sal>0;
global targethist;

global nbins;
targethist = rgbhist_fast(Params.img,sup2pixel2(double(oldLabel),Params.Label),nbins,1);
% 
figure(1);
subplot(2,1,1);
imshow(uint8(Params.img));
subplot(2,1,2);
imshow(BasicSal(rowind,colind),[]);
drawnow();

figure(2);
subplot(2,1,1);
imshow(BasicSal,[]);
subplot(2,1,2);
imshow(BasicSal,[]);
drawnow();
% pause;
[xx, yy]= meshgrid(1:Params.orgcol,1:Params.orgrow);
xs =xx(BasicSal>0);
ys =yy(BasicSal>0);
bbox = [min(ys); min(xs); max(ys); max(xs)];


save([Params.salcpath num2str(Params.ff,'%04d') '.mat'], 'BasicSal','bbox');

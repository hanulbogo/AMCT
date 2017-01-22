function bmapimg =drawbmap(img, Label)

if isempty(img)
    img = repmat(Label,[1 1 3]);
%     img(:,:,2) = max(img(:,:,2)-255,0);
end
bmapimg = img;
img1=img(:,:,1);
img2=img(:,:,2);
img3=img(:,:,3);

bmap =  seg2bmap(Label,size(Label,2),size(Label,1));

img1(bmap)=255;
img2(bmap)=255;
img3(bmap)=255;

bmapimg(:,:,1)=img1;
bmapimg(:,:,2)=img2;
bmapimg(:,:,3)=img3;
% bmapimg = (bmapimg);
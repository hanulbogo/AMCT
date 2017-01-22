function DrawSimilarity(pimg, cimg, Wcon,ConpixAll, pLabel,cLabel)

[row col nc]= size(pimg);
[crow ccol nc]= size(cimg);
mrow =max([row,crow]);
mcol = max([col, ccol]);
timg = zeros(mrow*2, col+ccol, nc);

timg(1:row,1:col,:)=drawbmap(pimg, pLabel);
timg(1:crow,1+col:end,:)=drawbmap(cimg, cLabel);

pblack=drawbmap(zeros(row,col,nc), pLabel);
cblack =drawbmap(zeros(crow,ccol,nc), cLabel);
timg(1+mrow:mrow+row,1:col,:)=pblack;
timg(1+mrow:mrow+crow,1+col:end,:)=cblack;

figure(99);
imshow(uint8(timg));
hold on;
x=0;
y=0;
pmapimg = drawbmap(pimg, pLabel);
cmapimg = drawbmap(cimg, cLabel);
pK=max(pLabel(:))+1;
cK=max(cLabel(:))+1;
K=pK+cK;
plabels = 0: pK;
clabels = 0: cK;
        
        
while ~isempty(x)
    [x y] =ginput(1);
    if isempty(x)
        break;
    end
        pimg1= pmapimg(:,:,1);
        pimg2= pmapimg(:,:,2);
        pimg3= pmapimg(:,:,3);
        
        cimg1= cmapimg(:,:,1);
        cimg2= cmapimg(:,:,2);
        cimg3= cmapimg(:,:,3);
        
    
        pbimg1= pblack(:,:,1);
        pbimg2= pblack(:,:,2);
        pbimg3= pblack(:,:,3);
        
        cbimg1= cblack(:,:,1);
        cbimg2= cblack(:,:,2);
        cbimg3= cblack(:,:,3);
        
        
    if x<col %Previous sups
        
        pp =pLabel(int32(y),int32(x));
        
        pWcon= Wcon(pp+1,:);
        fprintf('previous label : %f \n',pp);
        
        
        plist =plabels(logical(ConpixAll(pp+1,1:pK)));
        clist =clabels(logical(ConpixAll(pp+1,1+pK:end)));
        
                   
       
        for pp=plist
            pimg1(pLabel==pp)=(pimg1(pLabel==pp)+255)/2;
            pimg2(pLabel==pp)=(pimg2(pLabel==pp)+255)/2;
            pimg3(pLabel==pp)=(pimg3(pLabel==pp)+255)/2;
            
            pbimg1(pLabel==pp)=pWcon(pp+1)*255;
            pbimg2(pLabel==pp)=pWcon(pp+1)*255;
            pbimg3(pLabel==pp)=pWcon(pp+1)*255;
            
        end
        
        for cc=clist
            cimg1(cLabel==cc)=(cimg1(cLabel==cc)+255)/2;
            cimg2(cLabel==cc)=(cimg2(cLabel==cc)+255)/2;
            cimg3(cLabel==cc)=(cimg3(cLabel==cc)+255)/2;
            
            cbimg1(cLabel==cc)=pWcon(pK+cc+1)*255;
            cbimg2(cLabel==cc)=pWcon(pK+cc+1)*255;
            cbimg3(cLabel==cc)=pWcon(pK+cc+1)*255;
        end
           
    else
        
        cc =cLabel(int32(y),int32(x-col));
        
        cWcon= Wcon(cc+pK+1,:);
        fprintf('current label : %f \n',cc);
        
        
        plist =plabels(logical(ConpixAll(cc+pK+1,1:pK)));
        clist =clabels(logical(ConpixAll(cc+pK+1,1+pK:end)));
        
                   
       
        for pp=plist
            pimg1(pLabel==pp)=(pimg1(pLabel==pp)+255)/2;
            pimg2(pLabel==pp)=(pimg2(pLabel==pp)+255)/2;
            pimg3(pLabel==pp)=(pimg3(pLabel==pp)+255)/2;
            
            pbimg1(pLabel==pp)=cWcon(pp+1)*255;
            pbimg2(pLabel==pp)=cWcon(pp+1)*255;
            pbimg3(pLabel==pp)=cWcon(pp+1)*255;
            
        end
        
        for cc=clist
            cimg1(cLabel==cc)=(cimg1(cLabel==cc)+255)/2;
            cimg2(cLabel==cc)=(cimg2(cLabel==cc)+255)/2;
            cimg3(cLabel==cc)=(cimg3(cLabel==cc)+255)/2;
            
            cbimg1(cLabel==cc)=cWcon(pK+cc+1)*255;
            cbimg2(cLabel==cc)=cWcon(pK+cc+1)*255;
            cbimg3(cLabel==cc)=cWcon(pK+cc+1)*255;
        end
        
    end

       
    timg(1:row,1:col,1)=pimg1;
    timg(1:row,1:col,2)=pimg2;
    timg(1:row,1:col,3)=pimg3;

    
        
    timg(1:crow,1+col:end,1)=cimg1;
    timg(1:crow,1+col:end,2)=cimg2;
    timg(1:crow,1+col:end,3)=cimg3;
    
    
    timg(1+mrow:mrow+row,1:col,1)=pbimg1;
    timg(1+mrow:mrow+row,1:col,2)=pbimg2;
    timg(1+mrow:mrow+row,1:col,3)=pbimg3;
    
    timg(1+mrow:mrow+crow,1+col:end,1)=cbimg1;
    timg(1+mrow:mrow+crow,1+col:end,2)=cbimg2;
    timg(1+mrow:mrow+crow,1+col:end,3)=cbimg3;
    
    
    imshow(uint8(timg));
    
    
end
hold off;
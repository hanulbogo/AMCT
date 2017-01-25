function DrawSimilarityOneFrame(img, ConpixAll, Label)

[row col nc]= size(img);
timg=drawbmap(img, Label);

figure(99);
imshow(uint8(timg));
hold on;
x=0;
y=0;
mapimg = drawbmap(img, Label);
K=max(Label(:))+1;
Labels = 0: K-1;
        
while ~isempty(x)
    [x y] =ginput(1);
    if isempty(x)
        break;
    end
        img1= mapimg (:,:,1);
        img2= mapimg (:,:,2);
        img3= mapimg (:,:,3);
        
    if x<col %Previous sups
        
        pp =Label(int32(y),int32(x));
        
%         pWcon= Wcon(pp+1,:);
        fprintf('Clicked label : %f \n',pp);
        
        plist =Labels(logical(ConpixAll(pp+1,1:K)));
       
        for pp=plist
            img1(Label==pp)=(img1(Label==pp)+255)/2;
            img2(Label==pp)=(img2(Label==pp)+255)/2;
            img3(Label==pp)=(img3(Label==pp)+255)/2;
            
        end
        
    end

       
    timg(1:row,1:col,1)=img1;
    timg(1:row,1:col,2)=img2;
    timg(1:row,1:col,3)=img3;
  
    imshow(uint8(timg));
    
    
end
hold off;
function SupCol= SupColor_CNN(cnnfeat,Label,Ncol,SLICCol)

if Ncol==1
    SupCol{1} = SLICCol;
elseif Ncol==2
    SupCol = cell(Ncol,1);
    SupCol{1}=SLICCol;
    
    
    [xx, yy]= meshgrid(1:size(Label,2),1:size(Label,1));
    xxpixs=regionprops(Label+1, xx,'PixelValues');
    yypixs=regionprops(Label+1, yy,'PixelValues');
    Xmean= floor (cellfun(@mean,struct2cell(xxpixs))');
    Ymean = floor(cellfun(@mean,struct2cell(yypixs))');
    idx=(Xmean-1)*size(Label,1) +Ymean;
    cnnarr= reshape(permute(cnnfeat,[3,1,2]),[size(cnnfeat,3),size(Label,1)*size(Label,2)]);
    
    % load and reshape CNN features
    SupCol{2} = cnnarr(:,idx);%img2SupCol(double(cnnfeat), Label);
end
end

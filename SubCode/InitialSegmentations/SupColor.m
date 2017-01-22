function SupCol= SupColor(img, Label,Ncol,SLICCol,ConPix)
% global CenterPosition;
% global nbins;
global cnncpath;
global ff;
if Ncol==1
    %     [xx, yy]= meshgrid(1:size(Label,2),1:size(Label,1));
    %     xx= xx/size(Label,2);
    %     yy= yy/size(Label,1);
    %     img1=floor(double(img(:,:,1))/(256/nbins))+1;
    %     img2=floor(double(img(:,:,2))/(256/nbins))+1;
    %     img3=floor(double(img(:,:,3))/(256/nbins))+1;
    %
    %     bin1=regionprops(Label+1, img1,'PixelValues');
    %     bin2=regionprops(Label+1, img2,'PixelValues');
    %     bin3=regionprops(Label+1, img3,'PixelValues');
    %
    %
    %     suphist= cellfun(@histmine,struct2cell(bin1),struct2cell(bin2),struct2cell(bin3),'UniformOutput',0)';
    %     suphist=cell2mat(suphist);
    %     SupCol{1}= zeros(size(suphist,2)*2,size(suphist,1));
    %     SupCol{1} = [SLICCol;SLICCol;SLICCol];
    %     for ll =1:size(SupCol{1},2)
    %         histsup = SLICCol(:,ll);
    %         histcontext =mean(SLICCol(:,ConPix(ll,:)>0),2);
    %         SupCol{1}(:,ll) = [histsup; histcontext;histsup-histcontext];
    %     end
   %%
   %   Original
    SupCol{1} = SLICCol;
%     [xx, yy]= meshgrid(1:size(Label,2),1:size(Label,1));
%     cx= ceil(cellfun(@mean,struct2cell(regionprops(Label+1, xx,'PixelValues'))));
%     cy = ceil(cellfun(@mean,struct2cell(regionprops(Label+1, yy,'PixelValues'))));
%         
%     [hogs] =hog_feature_vector_sup(img,cx,cy);
%       
%     SupCol{1} = [SLICCol;hogs'*0];
%     
%     lx;
    %%
    
%     hsi_image = rgbtohsi(img);
%     SupCol{1} = img2SupCol(double(hsi_image), Label);
    %RGB,HSV,MatlabLAB,Oppenent
    %     SupCol = cell(Ncol,1);
    % %     %extract each channel
    % %     R  = double(img(:,:,1));
    % %     G  = double(img(:,:,2));
    % %     B  = double(img(:,:,3));
    %     lab_image = RGB2LAB(double(img));
    %     SupCol{1} = img2SupCol(double(lab_image), Label);
    %RGB
    %     SupCol{1} = img2SupCol(double(img), Label);
    %     SupCol{1}=RGB2LAB_sup(SupCol{1});
    %     SupCol{1}=[SupCol{1};0.1*SupStd(lab_image,Label)];
    %     SLICCol;
    %HSV
    %     hsv_image = rgb2hsv(uint8(img));
    %     SupCol{1} = img2SupCol(double(hsv_image), Label);
    
    
    %LAB
    
    %     cform = makecform('srgb2lab');
    %     lab_image = applycform(uint8(img),cform);
    %     SupCol{1} = img2SupCol(double(lab_image), Label);
    %     SupCol{3} = SLICCol;
    
    %Oppenent
    %     O1 = (R-G)./sqrt(2);
    %     O2 = (R+G-2*B)./sqrt(6);
    %     O3 = (R+G+B)./sqrt(3);
    %     Oimg = zeros(size(img));
    %     Oimg(:,:,1) = O1;
    %     Oimg(:,:,2) = O2;
    %     Oimg(:,:,3) = O3;
    %     SupCol{4}= img2SupCol(double(Oimg), Label);
    %  [xx, yy]= meshgrid(1:size(Label,2),1:size(Label,1));
    %  xxpixs=regionprops(Label+1, xx,'PixelValues');
    %  yypixs=regionprops(Label+1, yy,'PixelValues');
    %  Xmean= cellfun(@mean,struct2cell(xxpixs))';
    %  Ymean = cellfun(@mean,struct2cell(yypixs))';
    % SupCol{1} = [SLICCol; (Ymean'-CenterPosition(1))/(CenterPosition(1)*2); Xmean'-CenterPosition(2)/(CenterPosition(2)*2)];
    %         SupCol{1} = SLICCol;
    
elseif Ncol==2
    SupCol = cell(Ncol,1);
    SupCol{1}=SLICCol;
    % load and reshape CNN features
    cnnSave = [cnncpath sprintf('/%05d.mat',ff)];
    load(cnnSave); 
    [wd, ht ,~] =size(img);
    
    %     %% parameters
% para.level = 15;
% para.rangeS = 1;
% para.rangeL = 0;
% para.rangeSearch = 3.5;
% para.rangeSearchEst = 3;
% para.K = 5;

    para.layers = [3, 6, 10, 14, 18];
    para.scales = [1, 2, 4, 8, 16];
    cnnFeat = reshapeCNNFeature(feats,pad,wd,ht,para.layers,para.scales);
    
 
    
elseif Ncol==4
    SupCol = cell(Ncol,1);
    %     %extract each channel
    R  = double(img(:,:,1));
    G  = double(img(:,:,2));
    B  = double(img(:,:,3));
    %     lab_image = RGB2LAB(double(img));
    %     SupCol{1} = SLICCol;%img2SupCol(double(lab_image), Label);
    %     RGB
    SupCol{1} = img2SupCol(double(img), Label);
    %     HSV
    hsv_image = rgb2hsv(uint8(img));
    SupCol{2} = img2SupCol(double(hsv_image), Label);
    
    
    %     LAB
    
    cform = makecform('srgb2lab');
    lab_image = applycform(uint8(img),cform);
    SupCol{1} = img2SupCol(double(lab_image), Label);
    SupCol{3} = SLICCol;
    
    %     Oppenent
    O1 = (R-G)./sqrt(2);
    O2 = (R+G-2*B)./sqrt(6);
    O3 = (R+G+B)./sqrt(3);
    Oimg = zeros(size(img));
    Oimg(:,:,1) = O1;
    Oimg(:,:,2) = O2;
    Oimg(:,:,3) = O3;
    SupCol{4}= img2SupCol(double(Oimg), Label);
    %     [xx, yy]= meshgrid(1:size(Label,2),1:size(Label,1));
    %     xxpixs=regionprops(Label+1, xx,'PixelValues');
    %     yypixs=regionprops(Label+1, yy,'PixelValues');
    %     Xmean= cellfun(@mean,struct2cell(xxpixs))';
    %     Ymean = cellfun(@mean,struct2cell(yypixs))';
    %
    %     SupCol{Ncol} = [SLICCol; Ymean'-CenterPosition(1); Xmean'-CenterPosition(2)];
    SupCol{Ncol} = SLICCol;
    
    
    
    %     hsv_image = rgb2hsv(uint8(img));
    %     SupCol{Ncol} = img2SupCol(double(hsv_image), Label);
    
end
end

function SupCol=img2SupCol(img, Label)
nSup =max(Label(:))+1;
SupCol = zeros(size(img,3),nSup);

SupCol(1,:)= double(cellfun(@mean,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
SupCol(2,:) = double(cellfun(@mean,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
SupCol(3,:) = double(cellfun(@mean,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));
% SupCol(4,:)= double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
% SupCol(5,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
% SupCol(6,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));

end

function SupCol=SupStd(img, Label)
nSup =max(Label(:))+1;
SupCol = zeros(size(img,3),nSup);

SupCol(1,:)= double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
SupCol(2,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
SupCol(3,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));
% SupCol(4,:)= double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
% SupCol(5,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
% SupCol(6,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));

end

function SupCol=SupSum(img, Label)
nSup =max(Label(:))+1;
SupCol = zeros(size(img,3),nSup);

SupCol(1,:)= double(cellfun(@sum,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
SupCol(2,:) = double(cellfun(@sum,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
SupCol(3,:) = double(cellfun(@sum,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));
% SupCol(4,:)= double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,1),'PixelValues'))));
% SupCol(5,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,2),'PixelValues'))));
% SupCol(6,:) = double(cellfun(@std,struct2cell(regionprops(Label+1, img(:,:,3),'PixelValues'))));

end
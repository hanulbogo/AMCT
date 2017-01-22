function [Label,Sup1, Sup2, Sup3, k] = SLIC_SupPix(img, k)

    [ height,width ] = size(img(:,:,1));
    PixNum = height*width;
    ImgVecR = reshape( img(:,:,1)', PixNum, 1);
    ImgVecG = reshape( img(:,:,2)', PixNum, 1);
    ImgVecB = reshape( img(:,:,3)', PixNum, 1);
    % m is the compactness parameter, k is the super-pixel number in SLIC algorithm
%     cmpness = 50;      
    cmpness = 20;      
    ImgAttr=[ height ,width, k, cmpness, PixNum ];
    % obtain superpixel from SLIC algorithm: LabelLine is the super-pixel label vector of the imgage,
    % Sup1, Sup2, Sup3 are the mean L a b colour value of each superpixel,
    %  k is the number of the super-pixel.
    [ LabelLine, Sup1, Sup2, Sup3, k ] = SLIC( ImgVecR, ImgVecG, ImgVecB, ImgAttr );
%     [Label, k] = slicmex(uint8(img),k,20);
%     Label= double(Label);
    k=double(k);
    Label=reshape(LabelLine,width,height)';
function [Label, SupCol, ConPix, ConPixDouble, EdgSupORG]=InitialGraphConstruction(im,k,Ncol,SupFlag)
[ height,width ] = size(im(:,:,1));


if SupFlag==1
    [Label, Sup1,Sup2,Sup3, k] = SLIC_SupPix(double(im), k);
elseif SupFlag==0
    [Label, Sup1, Sup2, Sup3, k] =ERS_SupPix(im,k);
elseif SupFlag==2
    [Label, Sup1, Sup2, Sup3, k] =SEEDS_SupPix(im,k);
else
    [Label, Sup1, Sup2, Sup3, k] =SEEDS_SupPix(im,k);
end

[ConPix, ConPixDouble, EdgSup]=AMC_Init(Label,k,height,width);

EdgSupORG = EdgSup;
SLICCol =[Sup1';Sup2';Sup3'];
SupCol= SupColor(uint8(im), Label,Ncol,SLICCol,ConPix);
end


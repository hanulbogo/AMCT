function [Label, SupCol, ConPix, ConPixDouble, EdgSupORG]=InitialGraphConstruction_CNN(im,cnnfeat,k,Ncol,SupFlag)
[ height,width ] = size(im(:,:,1));

if SupFlag==1
    [Labels, Sup1,Sup2,Sup3, k] = SLIC_SupPix(double(im), k);
elseif SupFlag==0
    [Labels, Sup1, Sup2, Sup3, k] =ERS_SupPix(im,k);
elseif SupFlag==2
    [Labels, Sup1, Sup2, Sup3, k] =SEEDS_SupPix(im,k);

else
    [Labels, Sup1, Sup2, Sup3, k] =MMLP_SupPix(im,k);

end

Label=Labels;

[ConPix, ConPixDouble, EdgSup]=AMC_Init(Label,k,height,width);

EdgSupORG = EdgSup;
SLICCol =[Sup1';Sup2';Sup3'];
SupCol= SupColor_CNN(cnnfeat, Label,Ncol,SLICCol);
end


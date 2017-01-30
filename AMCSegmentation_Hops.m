function [Salpix, Sal]=AMCSegmentation_Hops(im, Label, SupCol,EdgSup,Ncol)
    [ height,width ] = size(im(:,:,1));
    k = max(Label(:))+1;
  
    segments= Label+1;     % the superpixle label
    
    
    imsegs.segimage = segments;
    num_region = max(imsegs.segimage(:));
    
    [ConPix, ConPixDouble, ~]=AMC_Init(Label,k,height,width);
    
    SaliencyParams.Img =im;
    SaliencyParams.Label=Label;
    SaliencyParams.LabelLine =reshape(Label',[],1);
    SaliencyParams.num_region =num_region;
    SaliencyParams.EdgSup=EdgSup;
    SaliencyParams.ConPix =ConPix;
    SaliencyParams.ConPixDouble =ConPixDouble;
    SaliencyParams.SupCol =SupCol;
    SaliencyParams.Ncol = Ncol;
    
   
    [Salpix ,Sal]=AbsorptionTime_Hops(EdgSup,SaliencyParams);

end

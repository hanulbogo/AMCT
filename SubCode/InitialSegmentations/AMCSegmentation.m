function [Salpix, Sal]=AMCSegmentation(im, Label, SupCol,EdgSup,Ncol)
    [ height,width ] = size(im(:,:,1));
    k = max(Label(:))+1;
  
    segments= Label+1;     % the superpixle label
    
    
    imsegs.segimage = segments;
    num_region = max(imsegs.segimage(:));
    
    [ConPix, ConPixDouble, ~]=ACM_Init(Label,k,height,width,[]);
    
    SaliencyParams.Img =im;
    SaliencyParams.Label=Label;
    SaliencyParams.LabelLine =reshape(Label',[],1);
    SaliencyParams.num_region =num_region;
    SaliencyParams.EdgSup=EdgSup;
    SaliencyParams.ConPix =ConPix;
    SaliencyParams.ConPixDouble =ConPixDouble;
    SaliencyParams.SupCol =SupCol;
    SaliencyParams.Ncol = Ncol;
    
   
    [Salpix ,Sal]=AbsorptionTime(EdgSup,SaliencyParams);

end

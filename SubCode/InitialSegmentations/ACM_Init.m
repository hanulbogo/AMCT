function [ConPix, ConPixDouble, EdgSup]=ACM_Init(Label,k,height,width,SupC)
% if ~isempty(SupC)
    
    [ ConPix, ConPixDouble ] = find_connect_superpixel_DoubleIn_Opposite( Label, k, height ,width );
  
    
    EdgSup = Find_Edge_Superpixels( Label, k,  height, width );
% else
%     
%     [ ConPix, ConPixDouble ] = find_connect_superpixel_DoubleIn_Opposite( Label, k, height ,width );
%     EdgSup=[];
% end

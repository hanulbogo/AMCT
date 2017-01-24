function [ConPix, ConPixDouble, EdgSup]=AMC_Init(Label,k,height,width)
   
    [ ConPix, ConPixDouble ] = find_connect_superpixel_DoubleIn_Opposite( Label, k, height ,width );
    EdgSup = Find_Edge_Superpixels( Label, k,  height, width );

function pixels =sup2pixel2(SupVal, Label)


LabelLine = Label(:);
[height, width] = size(Label);
SalLine = sup2pixel( length(LabelLine), LabelLine, SupVal);
pixels= reshape( SalLine, height,width);
% 
% pixels = zeros(size(Label));
% 
% for ii=0: max(Label(:))
%     
%     pixels(Label==ii) = SupVal(ii+1);
% end
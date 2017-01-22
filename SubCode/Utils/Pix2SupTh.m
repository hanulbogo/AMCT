function Sups= Pix2SupTh(Pixs, Label,th)
Sups = zeros(max(Label(:))+1,1);
for ii =0:max(Label(:))
    Sups(ii+1) = mean(Pixs(Label==ii))>th;
end
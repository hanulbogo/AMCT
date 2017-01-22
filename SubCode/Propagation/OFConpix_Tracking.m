function [Conpix , EdgSup]= OFConpix_Tracking(Kp, Kc, PrevLabel, Label, OF)
%  OFConpix(cK, PP.pK, Label,PP.Label, OF_CP);

[prow, pcol]= size(PrevLabel);
[crow, ccol]= size(Label);
[pc, pr]=meshgrid(1:pcol, 1:prow);
cr =int32(pr+OF.wy);
cc = int32(pc+OF.wx);

%current index에서 사라진 애들 없애기
pr2 = pr(cr>0 & cr<=crow & cc>0 & cc<=ccol);
pc2 = pc(cr>0 & cr<=crow & cc>0 & cc<=ccol);

pidx = prow*(pc2-1)+pr2;


cr2 =cr(cr>0 & cr<=crow & cc>0 & cc<=ccol);
cc2 =cc(cr>0 & cr<=crow & cc>0 & cc<=ccol);

cidx = crow*(cc2-1)+cr2;

CL = Label(cidx);
PL = PrevLabel(pidx);
EdgSup=ones(max(PrevLabel(:))+1,1);
EdgSup(unique(PL)+1)=0;
Conpix= (full(sparse( PL+1, CL+1, ones(size(PL)),Kp ,Kc ))>0);

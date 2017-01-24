function [cSalpix,cSal]= VAMC_TargetSegmentation_CNN(SP)
P_A_weight= (SP.pSaliency>0);


EdgSup = [1-P_A_weight ;zeros(SP.cK,1)];
NewConPixAll =SP.ConPixAll;
NewConPixAll(EdgSup==1, EdgSup==1)=1;
NewConPixAll(eye(SP.K)==1)=0;

[rows, cols]= find(NewConPixAll>0);

DPos= [rows,cols];


DPosAll=mat2cell(repmat(DPos, [SP.Ncol,1]),repmat(length(DPos),[SP.Ncol,1]),2);

global Ncol;
Colind = cell(Ncol,1);
for ii=1:Ncol
    Colind{ii} =ii;
end
DcolAll=cellfun(@colordist_CNN,SP.SupCol, DPosAll,Colind,'UniformOutput',0);
DcolNorAll =cellfun(@normalize2, DcolAll,'UniformOutput',0);
DcolNorAll =cell2mat(DcolNorAll');
DcolNor= max( DcolNorAll,[],2);

weight = exp( -10*DcolNor) + .00001;
Wcon = TransitionMatrix(weight,int32(DPos(:,1)-1), int32(DPos(:,2)-1),int32(SP.K), int32(size(DPos,1)));
Wcon(eye(SP.K)==1)=1;
WeightSum = sum(Wcon,2);
NumIn = SP.K ;

EdgWcon =Wcon(:,EdgSup==1);

AbsWcon= sum( EdgWcon, 2 )*3;


D= repmat(ones(size(AbsWcon))./(WeightSum + AbsWcon),[1,size(Wcon,2)]);


Wcon =  D .* Wcon;

I = eye( NumIn )*1;
N = ( I - Wcon  ); %현재의 Wcon은 transient state의 transient matrix

Sal =N\[P_A_weight;zeros(SP.cK,1)];
cSal = Sal(SP.pK+1:end);


pth=255;
cSal(cSal>pth) = pth;
cSal = (cSal-min(cSal))/max(cSal);

cLabelLine = SP.cLabel(:);
[height, width] = size(SP.cLabel);
cSalLine = sup2pixel( length(cLabelLine), cLabelLine, cSal );
cSalpix = reshape( cSalLine, height,width);
end




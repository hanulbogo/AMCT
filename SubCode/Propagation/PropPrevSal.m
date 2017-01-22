function PriorSal=PropPrevSal(PrevSal, wx,wy)
PriorSal = zeros(size(PrevSal));
[row,col,~]=size(PrevSal);
YY = repmat((1:row)',1, col);
XX = repmat(1:col, row, 1);

xyPrev =[XX(:),YY(:)];
xyCurr= uint32((xyPrev + [wx(:), wy(:)]));
CurrInd = (xyCurr(:,1)>0) & (xyCurr(:,1)<=col) &(xyCurr(:,2)>0) & (xyCurr(:,2)<=row);
CutxyPrev = xyPrev(CurrInd,:);
PrevInd = (CutxyPrev(:,1)-1)*row + CutxyPrev(:,2);
PriorSal(CurrInd) = PrevSal(PrevInd); 
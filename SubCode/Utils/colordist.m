function Dcol = colordist(SupCol, DPos)
global ff;
global st;
global ldamodel;
if ff==st
    Dcol=sqrt(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
%     Dcol=(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
else
    score=svmpredict(zeros(size(SupCol',1),1),svmnormalize(SupCol'),ldamodel,'-q');
    score1 = score(DPos(:,1));
    score2 = score(DPos(:,2));
    Dcol=abs(score1- score2);
    
%             Dcol= sqrt(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
    
    
    
end
end
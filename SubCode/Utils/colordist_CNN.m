function Dcol = colordist_fcn(SupCol, DPos,cc)
global ff;
global st;
global ldamodel;
if ff==st
    Dcol=sqrt(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
%     Dcol=(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
else
    if cc==1
        score=svmpredict(zeros(size(SupCol',1),1),svmnormalize_CNN(SupCol',cc),ldamodel{cc},'-q');
    else
         score=svmpredict(zeros(size(SupCol',1),1),SupCol',ldamodel{cc},'-q');
    end
    score1 = score(DPos(:,1));
    score2 = score(DPos(:,2));
    Dcol=abs(score1- score2);
    
%             Dcol= sqrt(sum( (SupCol(:,DPos(:,1))- SupCol(:,DPos(:,2))).^2 ))';
    
    
    
end
end
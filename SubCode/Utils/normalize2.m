function normdata=normalize2(data)


global ff;
if ff==1
    [Y I]=sort(data);
%     th =Y(ceil(length(I)*0.70));
    th =Y(ceil(length(I)*0.70));
    data(data>th)=th;
    
end
normdata =normalize(data);


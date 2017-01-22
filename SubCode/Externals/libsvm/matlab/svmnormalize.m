function data = svmnormalize(d)
% scale before svm
% the data is normalized so that max is 1, and min is 0
global meanval ;

global stdval 

data = (d -repmat(meanval,size(d,1),1));

data = data./(repmat(stdval,size(data,1),1)+eps);
% data;
end
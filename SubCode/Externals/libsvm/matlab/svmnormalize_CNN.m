function data = svmnormalize_CNN(d,cc)
% scale before svm
% the data is normalized so that max is 1, and min is 0
global meanval;
global stdval;

data = (d -repmat(meanval{cc},size(d,1),1));

data = data./(repmat(stdval{cc},size(data,1),1)+eps);
% data;
end
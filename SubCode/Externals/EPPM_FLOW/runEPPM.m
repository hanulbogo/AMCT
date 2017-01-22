clear; 

im1 = imread('frame10.png');
im2 = imread('frame11.png');

tic;
uv = EPPM(im1, im2);
toc;

writeFlowFile(uv, 'test.flo');

%uv(100,100:105)
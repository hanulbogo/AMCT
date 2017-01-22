% Function to compute optical flow using the algorithm in the following paper:
% 
% Linchao Bao, Qingxiong Yang, and Hailin Jin.
% Fast Edge-Preserving PatchMatch for Large Displacement Optical Flow.
% IEEE Transactions on Image Processing, 2014.
%
% NOTICE: 1. REQUIRE CUDA-capable NVIDIA GPU with compute capability > 2.0
%            (e.g., graphics card GTX 400 series or newer).
%
%         2. The first time running the mex needs to load the mex file into
%            Matlab's process and thus will be slow. For timing, please run
%            the mex for a second time. 
%
%         3. The timing described in the paper does not include device
%            initialization (but here each mex call does). Thus the timing
%            in Matlab will be a little longer than that described in the 
%            paper. 
%
%         4. Tested under Matlab R2013a in Windows 7/8 64-bit.
%         
%         5. Please contact Linchao Bao (linchaobao@gmail.com) for bugs.
%
% Usage:
%
% uv = EPPM(img1, img2);
% 
% PARAMS: 
%       img1 and img2: input image should be 3-channel uint8 type.
%       uv: output is a 2-channel double type flow field.
% 
% 
Matlab mex file for the algorithm in the following paper:

Linchao Bao, Qingxiong Yang, and Hailin Jin.
Fast Edge-Preserving PatchMatch for Large Displacement Optical Flow.
IEEE Transactions on Image Processing, 2014.

NOTICE: 1. REQUIRE CUDA-capable NVIDIA GPU with compute capability > 2.0
           (e.g., graphics card GTX 400 series or newer). Please update
           your graphics driver if there is problem running the mex. 
           See http://www.nvidia.com/Download/index.aspx?lang=en-us

        2. The first time running the mex needs to load the mex file into
           Matlab's process and thus will be slow. For timing, please run
           the mex for a second time. 

        3. The timing described in the paper does not include device
           initialization (but here each mex call does). Thus the timing
           in Matlab will be a little longer than that described in the 
           paper. 

        4. Tested under Matlab R2013a in Windows 7/8 64-bit.
        
        5. Please contact Linchao Bao (linchaobao@gmail.com) for bugs.

More information could be found here: http://www.cs.cityu.edu.hk/~linchabao2/
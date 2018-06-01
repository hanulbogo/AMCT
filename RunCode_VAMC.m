function RunCode_VAMC(dataset)
% Code to run VAMC

addpath(genpath('./SubCode/'));

%ERS : 0 SLIC: 1 SEEDS:2
global nbins;
global SupFlag;
global InputPath;
global OutputPath;
global GTPath;
global OFroot;
global K;
global flabel;
global Ncol;
global supth;
global multiplier;
global maxsal;
global KK;

global meanval ;
global stdval

KK=600;
nbins=6;
maxsal=0;
multiplier =1;
supth=0.5;
Ncol=1;

SupFlag = 1;
switch SupFlag
    case 0
        flabel =['ERS_' num2str(KK)];
    case 1
        flabel =[ 'AMCT_' num2str(KK)];
    case 2
        flabel =['SEEDS_' num2str(KK)];
end

fprintf('\n%s',flabel);

global outimgpath;
resultpath = './../Result/';
if ~exist(resultpath ,'dir')
    mkdir(resultpath);
end
switch dataset
    case 'NRD'
        InputPath = 'D:/Tracking/dataset/'; 
        OutputPath = [resultpath 'NRD_Result/']; 
        OFroot =[resultpath 'EEPM_Result_New/'];
        GTPath = 'D:/Tracking/dataset/';
        Outimgpath =[resultpath 'NRD_ResultImg/'];
        
    case 'SSD'
        InputPath = './../NewDataset/SSD/'; 
        GTPath = './../NewDataset_GT/SSD_GT/'; 
        OutputPath = [resultpath 'SSD_Result/']; 
        OFroot =[resultpath 'SSD_OF_EPPM/'];
        Outimgpath =[resultpath 'SSD_ResultImg/'];
        %         Outimgpath2 ='./SSD_MotionSaliency_img/';
    case 'GBD'
        InputPath = './../NewDataset/GBD/'; 
        GTPath = './../NewDataset_GT/GBD_GT/';
        OutputPath = [resultpath 'GBD_Result/'];
        OFroot =[resultpath 'GBD_OF_EPPM/'];
        Outimgpath =[resultpath 'GBD_ResultImg/'];
        %         Outimgpath2 ='./GBD_MotionSaliency_img/';
        % OutputPath = './VideoOutput/'; 
    case 'STD'
        InputPath = './../NewDataset/STD/'; 
        GTPath = './../NewDataset_GT/STD_GT/'; 
        OutputPath = [resultpath 'STD_Result/']; 
        OFroot =[resultpath 'STD_OF_EPPM/'];
        Outimgpath =[resultpath 'STD_ResultImg/'];
    case 'DAVIS480p'
        InputPath = './../NewDataset/DAVIS480p/'; 
        GTPath = './../NewDataset_GT/DAVIS480p_GT/'; 
        OutputPath = [resultpath 'DAVIS480p_Result/']; 
        OFroot =[resultpath 'DAVIS480p_OF_EPPM/'];
        Outimgpath =[resultpath 'DAVIS480p_ResultImg/'];
end



outimgpath=[Outimgpath flabel '/'];
if ~exist(outimgpath,'dir')
    mkdir(outimgpath);
end
if ~exist(OFroot,'dir')
    mkdir(OFroot);
end
if ~exist(OutputPath,'dir')
    mkdir(OutputPath);
end
OutputPath = [OutputPath flabel '/'];

if ~exist(OutputPath,'dir')
    mkdir(OutputPath);
end

if strcmp(dataset ,'NRD') 
    TrackingMain_NRD();
    fprintf('\nBB\n');
    ShowResult_NRD();
    fprintf('\nSeg\n');
    ShowResult_Seg_NRD();
elseif strcmp(dataset ,'DAVIS480p') 
    TrackingMain_SaliencyDataset();
    fprintf('\nBB\n');
    ShowResult_DAVIS();
    fprintf('\nSeg\n');
    ShowResult_Seg_DAVIS();
%     same as ShowResult_Seg
else
    TrackingMain_SaliencyDataset();
    fprintf('\nBB\n');
    ShowResult();
    fprintf('\nSeg\n');
    ShowResult_Seg();
end



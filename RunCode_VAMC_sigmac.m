function RunCode_VAMC_sigmac(dataset)
% Code to run VAMC

addpath(genpath('./SubCode/'));
% addpath(genpath('./EPPM_FLOW/'));
% addpath(genpath('./Saliency/'));
% addpath(genpath('./BoxDetection/'));
% addpath(genpath('./EdgeBox/'));
% addpath(genpath('./libsvm/'));
% addpath(genpath('./minBoundingBox/'));


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
        %         flabel =[ 'SalData_Final_' num2str(KK) '_abs_3_6bins_hist90'];
        flabel =[ 'VAMC_' num2str(KK)];
%         flabel =[ 'VAMC'];
    case 2
        flabel =['SEEDS_' num2str(KK)];
end


global outimgpath;
resultpath = './../Result/';
if ~exist(resultpath ,'dir')
    mkdir(resultpath);
end
switch dataset
    case 'NRD'
        InputPath = 'D:/Tracking/dataset/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'NRD_Result/']; %videos
        OFroot =[resultpath 'EEPM_Result_New/'];
        GTPath = 'D:/Tracking/dataset/';
        Outimgpath =[resultpath 'NRD_ResultImg/'];
        
    case 'SSD'
        InputPath = './../NewDataset/SSD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/SSD_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'SSD_Result/']; %videos
        OFroot =[resultpath 'SSD_OF_EPPM/'];
        Outimgpath =[resultpath 'SSD_ResultImg/'];
        %         Outimgpath2 ='./SSD_MotionSaliency_img/';
    case 'GBD'
        InputPath = './../NewDataset/GBD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/GBD_GT/';
        OutputPath = [resultpath 'GBD_Result/']; %videos
        OFroot =[resultpath 'GBD_OF_EPPM/'];
        Outimgpath =[resultpath 'GBD_ResultImg/'];
        %         Outimgpath2 ='./GBD_MotionSaliency_img/';
        % OutputPath = './VideoOutput/'; %videos
    case 'STD'
        InputPath = './../NewDataset/STD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/STD_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'STD_Result/']; %videos
        OFroot =[resultpath 'STD_OF_EPPM/'];
        Outimgpath =[resultpath 'STD_ResultImg/'];
    case 'DAVIS480p'
        InputPath = './../NewDataset/DAVIS480p/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/DAVIS480p_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'DAVIS480p_Result/']; %videos
        OFroot =[resultpath 'DAVIS480p_OF_EPPM/'];
        Outimgpath =[resultpath 'DAVIS480p_ResultImg/'];
end
fprintf('\n%s',flabel);
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
%     TrackingMain_NRD();
    fprintf('\nBB\n');
    ShowResult_NRD();
    fprintf('\nSeg\n');
    ShowResult_Seg_NRD();
elseif strcmp(dataset ,'DAVIS480p') 
%     TrackingMain_SaliencyDataset();
    fprintf('\nBB\n');
    ShowResult_DAVIS();
%     fprintf('\nSeg\n');
    ShowResult_Seg_DAVIS();
%     same as ShowResult_Seg
else
%     TrackingMain_SaliencyDataset();
    fprintf('\nBB\n');
    ShowResult();
    fprintf('\nSeg\n');
    ShowResult_Seg();
%     
end
% ProduceBB();
% ShowResult_Bench();
% ShowResult_VOT14();
% ShowResult_VOT14_4_points();



function RunCode_VAMC_CNN(dataset)

addpath(genpath('./SubCode/'));
% addpath(genpath('./../ObjectFlow-master/'));
% load and reshape CNN features
% cnnSave = [dirInfo.cnnPath dataInfo.videoName(1:end-1) sprintf('/%05d.mat',1)];
% load(cnnSave); cnnFeats{1} = reshapeCNNFeature(feats,pad,wd,ht,para.layers,para.scales);
% cnnModel = train(trainLabel, sparse(double(trainData)), '-s 0 -B 1 -q');

%ERS : 0 SLIC: 1 SEEDS:2
global nbins;
global SupFlag;
global InputPath;
global OutputPath;
global GTPath;
global OFroot;
global flabel;
global Ncol;
global supth;
global multiplier;
global KK;
global CNNPath;
global InitGTFlag;
global csize;
global bsize;
global InitPureFlag;
csize=0.5;
bsize =0.45;
nbins=6;
multiplier =1;
supth=0.5;
Ncol=2;
KK=600;
SupFlag = 1;

global InitCNNFlag;

switch SupFlag
    case 0
        flabel =['ERS_' num2str(KK)];
    case 1
        %         flabel =['SLIC_' num2str(KK) '_Original_moving_init25_abs5'];
%         flabel =[ 'fcn_Max_' num2str(KK) '_abs_3_6bins_hist90_csize',num2str(csize,'%.2f'), 'bsize' num2str(bsize,'%.2f')];
        flabel =['VAMC_CNN_InitGTFlag_' num2str(InitGTFlag) '_InitCNNFlag_' num2str(InitCNNFlag) '_InitPureFlag_' num2str(InitPureFlag)];
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
        CNNPath = './../ObjectFlow-master/NRD_Data/cnn/';
    case 'SSD'
        InputPath = './../NewDataset/SSD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/SSD_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'SSD_Result/']; %videos
        OFroot =[resultpath 'SSD_OF_EPPM/'];
        Outimgpath =[resultpath 'SSD_ResultImg/'];
        CNNPath = './../ObjectFlow-master/SSD_Data/cnn/';
    case 'GBD'
        InputPath = './../NewDataset/GBD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/GBD_GT/';
        OutputPath = [resultpath 'GBD_Result/']; %videos
        OFroot =[resultpath 'GBD_OF_EPPM/'];
        Outimgpath =[resultpath 'GBD_ResultImg/'];
        CNNPath = './../ObjectFlow-master/GBD_Data/cnn/';
        %         Outimgpath2 ='./GBD_MotionSaliency_img/';
        % OutputPath = './VideoOutput/'; %videos
    case 'STD'
        InputPath = './../NewDataset/STD/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/STD_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'STD_Result/']; %videos
        OFroot =[resultpath 'STD_OF_EPPM/'];
        Outimgpath =[resultpath 'STD_ResultImg/'];
        CNNPath = './../ObjectFlow-master/STD_Data/cnn/';
    case 'DAVIS480p'
        InputPath = './../NewDataset/DAVIS480p/'; %CategoryFolder->Frames
        GTPath = './../NewDataset_GT/DAVIS480p_GT/'; %CategoryFolder->Frames
        OutputPath = [resultpath 'DAVIS480p_Result/']; %videos
        OFroot =[resultpath 'DAVIS480p_OF_EPPM/'];
        Outimgpath =[resultpath 'DAVIS480p_ResultImg/'];
        CNNPath = './../ObjectFlow-master/DAVIS480p_Data/cnn/';
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
    TrackingMain_NRD_CNN();
    fprintf('\nBB\n');
    ShowResult_NRD();
    fprintf('\nSeg\n');
    ShowResult_Seg_NRD();
elseif strcmp(dataset ,'DAVIS480p')
    TrackingMain_SaliencyDataset_CNN();
    fprintf('\nBB\n');
    ShowResult_DAVIS();
    fprintf('\nSeg\n');
    ShowResult_Seg_DAVIS();
else
    TrackingMain_SaliencyDataset_CNN();
    fprintf('\nBB\n');
    ShowResult();
    fprintf('\nSeg\n');
    ShowResult_Seg();
end

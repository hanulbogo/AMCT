clear all;
dataset ={'NRD','GBD','SSD','STD','DAVIS480p'};

% for dd=[2,1]%1:length(dataset);
%     RunCode_Tracking_Saliency_Dataset(dataset{dd});
% %     RunCode_Tracking_Saliency_Dataset_cAMC(dataset{dd});
% %     RunCode_Tracking_Saliency_Dataset_NGAMC(dataset{dd});
% end

% % 
global InitGTFlag;
global InitCNNFlag;
global InitPureFlag;
InitGTFlag=0;
InitCNNFlag=0;
InitPureFlag=1;
for dd=5%:length(dataset)
    %Run VAMC
    RunCode_VAMC(dataset{dd});
    %Run VAMC+CNN
%     RunCode_VAMC_CNN_Evaluation(dataset{dd})
    
%       RunCode_Tracking_Saliency_Dataset_initSVR(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_withInitGT(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_BoundaryEdge(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_fourcolors(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_fcn(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_fcn_woInitSeg(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_fcn_woInitSeg_woColor(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_fcn_faster(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_InitGT(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_RF(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_wGTInit(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_cAMC(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_NGAMC(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_NGAMC_wInitGT(dataset{dd});
end

clear all;
dataset ={'NRD','GBD','SSD','STD'};

% for dd=[2,1]%1:length(dataset);
%     RunCode_Tracking_Saliency_Dataset(dataset{dd});
% %     RunCode_Tracking_Saliency_Dataset_cAMC(dataset{dd});
% %     RunCode_Tracking_Saliency_Dataset_NGAMC(dataset{dd});
% end

% % 
for dd=1:length(dataset)
    %Run VAMC
    RunCode_VAMC(dataset{dd});
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
% 
% 
% for dd=[3,2,1]%1:length(dataset);
% %     RunCode_Tracking_Saliency_Dataset(dataset{dd});
% %     RunCode_Tracking_Saliency_Dataset_cAMC(dataset{dd});
%     RunCode_Tracking_Saliency_Dataset_NGAMC(dataset{dd});
% end

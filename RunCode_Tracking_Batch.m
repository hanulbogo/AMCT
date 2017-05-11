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
InitPureFlag=0;
for dd=1:4%:length(dataset)
    %Run VAMC
    RunCode_VAMC(dataset{dd});
    %Run VAMC+CNN
    %RunCode_VAMC_CNN(dataset{dd})
end

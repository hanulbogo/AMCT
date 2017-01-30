clear all;
dataset ={'NRD','GBD','SSD','STD','DAVIS480p'};

% % 
global InitGTFlag;
global InitCNNFlag;
InitGTFlag=0;
InitCNNFlag=1;

global KK;
% KK=600;
for KK=[1200]%800,1000]
    for dd=1%:length(dataset)
        %Run VAMC
        RunCode_VAMC(dataset{dd});
        %Run VAMC+CNN
        %     RunCode_VAMC_CNN(dataset{dd})
        
       
    end
    
end
clear all;
dataset ={'NRD','GBD','SSD','STD','DAVIS480p'};

% % 
global InitGTFlag;
global InitCNNFlag;
InitGTFlag=0;
InitCNNFlag=0;
global nhops;
global KK;
% KK=600;
for KK=900%,800,1000]
    for nhops=3
        for dd=1%1:length(dataset)
            %Run VAMC
            RunCode_VAMC_Hops(dataset{dd});
            %Run VAMC+CNN
            %     RunCode_VAMC_CNN(dataset{dd})
            
            
        end
    end
end
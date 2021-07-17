%% export neuron names
clear, clc
Listing = dir([pwd, '/Data' , '/Spike_and_Log_Files']);
neuron_codes = [Listing(3:63).name, " "]; 
neuron_codes(62) = [];
%% Part3: spike-count rate histogram
SCRA = zeros(1, 61); % spike-count rate average
for i = 1:61
   [~ ,SCRA(i)] = Func_ReadData(char(neuron_codes(i)));
end
histogram(SCRA,15)
title('spike-count-rate histogram', 'Interpreter', 'latex')
%% Part3: Exclude low firing rate neurons
index_counter = 0;
for i = 1:61
    if SCRA(i) < 2
        index_counter = index_counter + 1;
        index(index_counter) = i;
    end
end
fprintf('Exluded Neurons:\n')
disp(neuron_codes(index)')
neuron_codes(index) = [];
%% Create Struct
SCRA = [];
N = length(neuron_codes); % spike-count rate average
for i = 1:N
   [outs{i} ,SCRA(i)] = Func_ReadData(char(neuron_codes(i)));
   neurons(i) = struct("outs", outs{i},"spike_rate", SCRA(i));
end
%% Save Datas
save Data/neuron_codes.mat neuron_codes
save Data/neurons_struct.mat neurons


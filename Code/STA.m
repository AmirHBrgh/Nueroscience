%% load neuron codes
clc, clear
load Data/neuron_codes.mat 
%%
[events, ~] = Func_ReadData(char(neuron_codes(10)));
spike_trigerred_matrices = [];
for i = 1:length(events)
    spike_trigerred_trial = Func_StimuliExtraction(events(i).events);
    spike_trigerred_matrices = cat(3, spike_trigerred_matrices, spike_trigerred_trial);
end
N = length(spike_trigerred_matrices);
sta = (sum(spike_trigerred_matrices, 3)/ N) + 0.5;
%%
imshow(sta,  'InitialMagnification', 800) 
%%
[h, p] = ttest(permute(spike_trigerred_matrices,[3 1 2]));
imshow(reshape(p, [16, 16]),  'InitialMagnification', 800);
%%
sample = randi([16 32767], 1, N);
spike_trigerred_control = Func_StimuliExtraction(sample, "random");
correlation_control = sum(spike_trigerred_control .* sta, [1 2])/length(spike_trigerred_control);
%%
correlation_spike_trigerred = sum(spike_trigerred_matrices .* sta, [1 2])/length(spike_trigerred_matrices);
%%
close
histogram(reshape(correlation_spike_trigerred, [1, 12845]), 'Normalization', 'probability')
hold on
histogram(reshape(correlation_control, [1, 12845]), 'Normalization', 'probability') 
legend('spike', 'control')
%%
[h, p] = ttest2(reshape(correlation_spike_trigerred, [1, 12845]),...
    reshape(correlation_control, [1, 12845]));
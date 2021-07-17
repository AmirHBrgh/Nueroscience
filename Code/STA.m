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
sta = (sum(spike_trigerred_matrices, 3)/ N);
%%
sta_show = sta + 0.5;
imshow(sta_show,  'InitialMagnification', 800) 
%%
sta_show = 10 * (sta - mean(sta, [1 2])); 
sta_show = sta_show + 0.5;
imshow(sta_show,  'InitialMagnification', 800) 
%%
[h, p] = ttest(permute(spike_trigerred_matrices,[3 1 2]));
p = 1 - p;
imshow(reshape(p, [16, 16]),  'InitialMagnification', 800);
%%
sample = randi([16 32767], 1, N);
spike_trigerred_control = Func_StimuliExtraction(sample, "random");
%%
stm_reshaped = reshape(spike_trigerred_matrices, [1, 256, 12845]);
sta_reshaped = reshape(sta, [1, 256]);
correlation_spike_trigerred = [];
for i = 1:12845
    correlation_spike_trigerred(i) = dot(sta_reshaped, stm_reshaped(:,:,i));
end
correlation_spike_trigerred = correlation_spike_trigerred / 256;
%%
stc = reshape(spike_trigerred_control, [1, 256, 12845]);
corr_stc = zeros(1, 12845);
for i = 1:12845
    corr_stc(i) = dot(sta_reshaped, stc(:,:,i));
end
corr_stc = corr_stc / 256;
%%
close
histogram(correlation_spike_trigerred, 'Normalization', 'probability')
hold on
histogram(corr_stc, 'Normalization', 'probability') 
legend('spike', 'control')
%%
[h, p] = ttest2(reshape(correlation_spike_trigerred, [1, 12845]),...
    reshape(correlation_control, [1, 12845]));
%% load neurons 
clc, clear
load Data/neurons_struct.mat
%%
neuron = neurons(10);
[sta, spike_trigerred] = Func_FindSTA(neuron);
%%
neuron_code = neuron.outs(1).hdr.DataInfo.DataFrom(1:10);
Func_FrameShow(sta, reshape(p, [16, 16]), sprintf('%s', neuron_code));
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
histogram(correlation_spike_trigerred)
hold on
histogram(corr_stc) 
legend('spike', 'control')
%%
[h, p] = ttest2(reshape(correlation_spike_trigerred, [1, 12845]),...
    reshape(correlation_control, [1, 12845]));
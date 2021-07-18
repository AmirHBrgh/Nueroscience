%%
clear, clc
load v.mat
load('Data/neurons_full_struct.mat')
%% Test Sta
sta_result = [];
stc_result = [];
for i = 1:length(neurons)
    neuron = neurons(i);
    freq = 59.721395;
    % Spike triggered ensemble
    neuron_code = neuron.outs(1).hdr.DataInfo.DataFrom(1:10);
    [sta, spike_trigerred] = Func_FindSTA(neuron);
    spike_trigerred = reshape(spike_trigerred,256,length(spike_trigerred));
    %control stimuli ensemble
    random_events = 10000*rand(1,(length(spike_trigerred)))*(32767/freq);
    random_spike = Func_StimuliExtraction (random_events);
    random_spike = reshape(random_spike, 256, length(random_spike));
    
    zeta_sta = reshape(sta,1,256)*spike_trigerred;
    random_zeta_sta = reshape(sta,1,256)*random_spike;
    
    sta_result(i) = vartest2(zeta_sta, random_zeta_sta, 'Tail', 'right');
    
    v1 = neuron.v1;
    zeta_stc = reshape(v1,1,256)*spike_trigerred;
    random_zeta_stc = reshape(v1,1,256)*random_spike;
    
    stc_result(i) = vartest2(zeta_stc, random_zeta_stc, 'Tail', 'right');
end
%%
fprintf('mean result for Spike triggered correlation:%d\n', mean(stc_result));
fprintf('mean result for Spike triggered correlation:%d\n', mean(sta_result));
%%
neuron = neurons(10);
freq = 59.721395;
% Spike triggered ensemble
neuron_code = neuron.outs(1).hdr.DataInfo.DataFrom(1:10);
[sta, spike_trigerred] = Func_FindSTA(neuron);
spike_trigerred = reshape(spike_trigerred,256,length(spike_trigerred));
%control stimuli ensemble
random_events = 10000*rand(1,(length(spike_trigerred)))*(32767/freq);
random_spike = Func_StimuliExtraction (random_events);
random_spike = reshape(random_spike, 256, length(random_spike));
for i = 1:256
zeta = v(:,I(i))' * spike_trigerred;
random_zeta = v(:,I(i))' *random_spike;
[h(i), p(i)] = vartest2(zeta, random_zeta, 'Tail', 'right');
end

plot(p,'Marker','o','LineWidth',1);
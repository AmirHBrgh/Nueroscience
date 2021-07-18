%%
clear, clc
load Data/neurons_full_struct.mat
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
    
    sta_result(i) = vartest2(zeta, random_zeta, 'Tail', 'right');
    
    zeta_sta = reshape(v1,1,256)*spike_trigerred;
    random_zeta_sta = reshape(v1,1,256)*random_spike;
    
    stc_result(i) = vartest2(zeta, random_zeta, 'Tail', 'right');
end
%%
zeta4 = reshape(sta,1,256)*spike_trigerred;

%%
[h, p] = vartest2(zeta4, random_zeta4);
%%
v1 = neuron.v1;
v2 = neuron.v2;
v3 = neuron.v3;
%%
for i = 1:256
zeta = v(:,I(i))' * spike_trigerred;
random_zeta = v(:,I(i))' *random_spike;
[h(i), p(i)] = vartest2(zeta, random_zeta, 'Tail', 'right');
end

plot(p,'Marker','o','LineWidth',1);




%zeta2 = reshape(v2,1,256)*spike_trigerred;
%random_zeta2 = reshape(v2,1,256)*random_spike;

%zeta3 = reshape(v3,1,256)*spike_trigerred;
%random_zeta3 = reshape(v3,1,256)*random_spike;
%%
histogram(zeta,'Normalization', 'pdf', 'BinMethod','fd')
hold on
histogram(random_zeta,'Normalization', 'pdf', 'BinMethod','fd') 
%%
[h, p(1)] = vartest2(zeta1, random_zeta1);
[h, p(2)] = vartest2(zeta2, random_zeta2);
[h, p(3)] = vartest2(zeta3, random_zeta3);
%%
plot(p,'r','LineWidth',1,'Marker','o');

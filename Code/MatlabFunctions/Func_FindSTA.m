function [sta, spike_trigerred] = Func_FindSTA(neuron)
    outs = neuron.outs;
    spike_trigerred = [];
    for i = 1:length(outs)
        spike_trigerred_trial = Func_StimuliExtraction(outs(i).events);
        spike_trigerred = cat(3, spike_trigerred, spike_trigerred_trial);
    end
    N = length(spike_trigerred);
    sta = (sum(spike_trigerred, 3)/ N) * 256;
end
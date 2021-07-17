%% Load neurons 
clc, clear
load Data/neurons_struct.mat
%% Do for each neuron
number_of_neurons = length(neurons);
for i = 1:number_of_neurons     
    %calculate sta
    neuron = neurons(i);
    [sta, spike_trigerred] = Func_FindSTA(neuron);
    %calculate control matrix
    N = length(spike_trigerred);
    spike_sample = randi([16 32767], 1, N);
    stim_control = Func_StimuliExtraction(spike_sample, "random");
    %correlation 
    corr_control = Func_Correlation(sta, stim_control);
    corr_sta = Func_Correlation(sta, spike_trigerred);
    corr_control = reshape(corr_control, [1 length(corr_control)]);
    corr_sta = reshape(corr_sta, [1 length(corr_sta)]);
    %histograms
    histogram(corr_sta, 'Normalization', 'pdf')
    hold on
    histogram(corr_control, 'Normalization', 'pdf') 
    legend('spike', 'control')
    title(sprintf('neuron code: %s', neuron_code), 'Interpreter', 'latex')
    address = sprintf('../Report/photos/STA/histograms/%d.png', i);
    exportgraphics(gcf, address)
    close
    %
    [~, p] = ttest2(corr_sta, corr_control);
    p_values(i) = p;
    if p < 0.0005
        result(i) = "null-hypothesis rejected, means are diffrent.";
    else
        result(i) = "null-hypothesis accepted, means are equal.";
    end
    %
    f = figure;
    histfit(corr_sta);
    hold on
    histfit(corr_control);
    legend('p(s|r)', 'Gaussian fit', 'p(s)', 'Gaussian fit')
    address = sprintf('../Report/photos/STA/gaussianFits/%d.png', i);
    exportgraphics(gcf, address)
    close
    %
    h1 = fitdist(corr_control', 'Normal');
    h2 = fitdist(corr_sta', 'Normal');
    mu1 = h1.mu; mu2 = h2.mu; var1 = h1.sigma ^ 2; var2 = h2.sigma ^ 2;
    yfun = @(mu,var, x)(2*pi*(var))^(-0.5)* exp(-((x-mu).^2)/(2*(var)));
    val = fzero(@(x) yfun(mu1, var1, x) - yfun(mu2, var2, x), mean([mu1,mu2]));
    accuracy(i) = mean(corr_sta > val) * 100;
    %plot sta, p-value, export it
    neuron_code = neuron.outs(1).hdr.DataInfo.DataFrom(1:12);
    str = sprintf('Neuron Code: %s\nControl/Spike p-Value: %f\nt-test result: %s\nTreshold accuracy: %f',...
    neuron_code, p_values(i), result(i), accuracy(i));
    [~, p] = ttest(permute(spike_trigerred,[3 1 2]));
    Func_FrameShow(sta, reshape(p, [16, 16]), sprintf('neuron code: %s', neuron_code));
    annotation('textbox',...
    [0.1 0.1 0.8 0.15],...
    'LineWidth', 1,...
    'String', str,...
    'Interpreter', 'latex');
    address = sprintf('../Report/photos/STA/imshows/%d.png', i);
    exportgraphics(gcf, address)
    close
end
%%
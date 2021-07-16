function Output = Func_StimuliExtraction(events, msq1D)
%FUNC_STIMULIEXTRACTION spike-triggerd stimuli extracion 
%   inputs: events = spike times in 0.1ms
%   (optional): msq1D = stimuli matrix, defalut = Data/Stimulus_Files/msq1D.mat
    if nargin < 2
        x = load('Data/Stimulus_Files/msq1D.mat');
        msq1D = x.msq1D;
    end
    frame_rate = 59.7213;
    indices = ceil((events * frame_rate) / 10000);
    Output = zeros(16, 16, length(events));
    for i = 1:length(events)
        Output(:, :, i) = msq1D(indices(i)-15:indices(i), :);
    end
end


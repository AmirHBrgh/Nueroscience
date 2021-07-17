function Output = Func_StimuliExtraction(events, option, msq1D)
%FUNC_STIMULIEXTRACTION spike-triggerd stimuli extracion 
%   inputs: events = spike times in 0.1ms
%   (optional): msq1D = stimuli matrix, defalut = Data/Stimulus_Files/msq1D.mat
    if nargin < 3
        x = load('Data/Stimulus_Files/msq1D.mat');
        msq1D = x.msq1D;
    end
    if nargin < 2
        option = "real";
    end
    %rep = (msq1D == -1);
    %msq1D(rep) = 0;
    frame_rate = 59.7213;
    if option == "random"
        indices = events;
    else
    indices = ceil((events * frame_rate) / 10000);
    indices = indices(indices>15);
    end
    Output = zeros(16, 16, length(indices));
    for i = 1:length(indices)
        Output(:, :, i) = msq1D(indices(i)-15:indices(i), :);
    end
end


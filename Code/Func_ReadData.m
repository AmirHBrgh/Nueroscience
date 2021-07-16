% Recomend: select Data/ and MatlabFucntions/
% directorys and add them to matlab PATH
function [Output, spike_count_rate] = Func_ReadData(NeuronCode)
    Path = [pwd, '/Data', '/Spike_and_Log_Files/', NeuronCode];
    Listing = dir(Path);
    Index_Counter = 0;
    events = {};
    hdrs = {};
    frame_rate = 59.72; %Hz
    frame_number = 32767;
    spike_count = [];
    for i = 1:length(Listing)
        if (contains(Listing(i).name, 'msq1d.sa0', 'IgnoreCase', true) && ...
                ~contains(Listing(i).name, 'sa0.sub', 'IgnoreCase', true) && ...
                ~contains(Listing(i).name, 'sa0.', 'IgnoreCase', true))
            Index_Counter = Index_Counter + 1;
            [events{Index_Counter}, hdrs{Index_Counter}] = fget_spk(Listing(i).name, 'get');
            spike_count(Index_Counter) = length( events{Index_Counter});
        end
    end
    Output = struct('events', events, 'hdr', hdrs);
    spike_count_rate = mean(spike_count) * frame_rate / frame_number;
end

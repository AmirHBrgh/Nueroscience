%% 4.1
n = 10;           %neurons number in struct "neuron"
load('Data\Stimulus_Files\msq1D.mat')
% Spike triggered ensemble
Spike_trig_stimuli = Func_StimuliExtraction (neurons(n).outs(1).events);
Spike_trig_stimuli = reshape(Spike_trig_stimuli,256,length(Spike_trig_stimuli));
% correlation matrix calculation
correlation_mat = corr(Spike_trig_stimuli');
[v, d] = eig(correlation_mat,'vector');
[sorted_d, I] = sort(d,'descend');
% 3 most significant eigenvectors
v1 = reshape(v(:,I(1)),16,16);
v2 = reshape(v(:,I(2)),16,16);
v3 = reshape(v(:,I(3)),16,16);

subplot(1,3,1);                 % first eigenvector
imshow(v1,[-0.1,0.1]);
title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v1']);
xlabel('$Spatial$','interpreter','latex');
ylabel('$Temporal$','interpreter','latex');

subplot(1,3,2);                 % second eigenvector
imshow(v2,[-0.1,0.1]);
title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v2']);
xlabel('$Spatial$','interpreter','latex');
ylabel('$Temporal$','interpreter','latex');

subplot(1,3,3);                 % third eigenvector
imshow(v3,[-0.1,0.1]);
title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v3']);
xlabel('$Spatial$','interpreter','latex');
ylabel('$Temporal$','interpreter','latex');

%% 4.2
k = 20;
freq = 59.721395;
% creating the control stimuli ensemble
eig_val = zeros(k,256);
for i = 1 : k
    random_events = 10000*rand(1,(length(Spike_trig_stimuli)))*(32767/freq);
    random_spike = Func_StimuliExtraction (random_events);
    random_spike = reshape(random_spike, 256, length(random_spike));
    random_correlation_mat = corr(random_spike');
    [~, random_d] = eig(random_correlation_mat);
    eig_val(i,:) = diag(random_d);
end
% control eigenvalues and other statistics
eig_val = sort(eig_val,2,'descend');
random_mean = mean(eig_val,1);
random_mean = (random_mean + sorted_d(10) - random_mean(10));
random_std = std(eig_val,0,1);

% the radius of confidence interval
CI = (sorted_d(3)-random_mean(3) + 0.1*(sorted_d(2)-random_mean(2)))/mean(random_std(3));

N=30;
figure
plot(random_mean(1:N)+ CI*random_std(1:N),'--','LineWidth',1);
hold on
plot(random_mean(1:N) - CI*random_std(1:N),'--','LineWidth',1);
plot(sorted_d(1:N),'r','LineWidth',1,'Marker','o');

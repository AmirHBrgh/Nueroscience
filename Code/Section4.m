%% 4.1
n = 10;           %neurons number in struct "neuron"
load('Data/Stimulus_Files/msq1D.mat')
load('Data/neurons_struct.mat')
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
%% 4.4
% the image of spike and control ensembles on significant eigenvectors
zeta1 = reshape(v1,1,256)*Spike_trig_stimuli;
zeta2 = reshape(v2,1,256)*Spike_trig_stimuli;
random_zeta1 = reshape(v1,1,256)*random_spike;
random_zeta2 = reshape(v2,1,256)*random_spike;

string = sprintf(['Neuron''s Name: ',[neurons(n).outs(1).hdr.FileInfo.Fname],'\nNeuron''s Number: ','%d','\n'],n);

% histogram of spike and control images on the first eigenvector
figure
histogram(zeta1,'Normalization','pdf','BinMethod','fd');
hold on
histogram(random_zeta1,'Normalization','pdf','BinMethod','fd');
legend('spike','control');
title([string 'First Eigenvector'],'interpreter','latex');

% histogram of spike and control images on the second eigenvector
figure
histogram(zeta2,'Normalization','pdf','BinMethod','fd');
hold on
histogram(random_zeta2,'Normalization','pdf','BinMethod','fd');
legend('spike','control');
title([string 'Second Eigenvector'],'interpreter','latex');

% histogram of spike and control images on the first and second eigenvector
figure
histogram2(zeta1,zeta2,'Normalization','pdf');
hold on
histogram2(random_zeta1,random_zeta2,'Normalization','pdf');
legend('spike','control');
title([string 'Joint Distribution'],'interpreter','latex');

%% 4.5
% statistics of spike and control ensembles
mu1 = mean(zeta1);
mu2 = mean(zeta2);
sigma1 = std(zeta1);
sigma2 = std(zeta2);
random_mu1 = mean(random_zeta1);
random_mu2 = mean(random_zeta2);
random_sigma1 = std(random_zeta1);
random_sigma2 = std(random_zeta2);

% hypothesis testing, using joint gaussian model
r = (mean(zeta1.*zeta2)-mu1*mu2)/(sigma1*sigma2);
random_r = (mean(random_zeta1.*random_zeta2)-random_mu1*random_mu2)/(random_sigma1*random_sigma2);

y1 = (1/(sigma1*sigma2*sqrt(1-r^2)))*exp(-0.5*(1/(1-r^2))*((zeta1-mu1).^2/sigma1^2+...
    (zeta2-mu2).^2/sigma2^2 - 2*(zeta1-mu1).*(zeta2-mu2)*r/(sigma1*sigma2) ));

random_y1 = (1/(random_sigma1*random_sigma2*sqrt(1-random_r^2)))...
    *exp(-0.5*(1/(1-random_r^2))*((zeta1-random_mu1).^2/random_sigma1^2+...
    (zeta2-random_mu2).^2/random_sigma2^2 - ...
    2*(zeta1-random_mu1).*(zeta2-random_mu2)*random_r/(random_sigma1*random_sigma2) ));

accepted_percentage = 100*sum(y1>random_y1)/length(y1)

%% 4.6
for n = 1 : 54
        figure
        subplot(5,4,4);
        string = sprintf(['Neuron''s Name: ',neurons(n).outs(1).hdr.FileInfo.Fname,'\nNeuron''s Number: ','%d'],n);
        text(0,0.5,string,'interpreter','latex'); 
        axis off
        
        % 4.1
        load('Data/Stimulus_Files/msq1D.mat')
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
        neurons(n).v1 = v1;
        neurons(n).v2 = v2;
        neurons(n).v3 = v3;

        subplot(5,4,1);             % first eigenvector
        imshow(v1,[min(min(v1)),max(max(v1))]);
        title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v1']);
        xlabel('$Spatial$','interpreter','latex');
        ylabel('$Temporal$','interpreter','latex');

        subplot(5,4,2);             % second eigenvector
        imshow(v2,[min(min(v2)),max(max(v2))]);
        title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v2']);
        xlabel('$Spatial$','interpreter','latex');
        ylabel('$Temporal$','interpreter','latex');

        subplot(5,4,3);             % third eigenvector
        imshow(v3,[min(min(v3)),max(max(v3))]);
        title([neurons(n).outs(1).hdr.FileInfo.Fname,'-v3']);
        xlabel('$Spatial$','interpreter','latex');
        ylabel('$Temporal$','interpreter','latex');
        
        % 4.2
        k = 20;
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
        random_mean = (random_mean + sorted_d')/2;
        random_std = std(eig_val,0,1);

        % the radius of confidence interval
        CI = (sorted_d(3)-random_mean(3) + 0.1*(sorted_d(2)-random_mean(2)))/mean(random_std(3));

        N=30;
        subplot(5,4,[13:14,17:18])
        plot(random_mean(1:N)+ CI*random_std(1:N),'--','LineWidth',1);
        hold on
        plot(random_mean(1:N) - CI*random_std(1:N),'--','LineWidth',1);
        plot(sorted_d(1:N),'r','LineWidth',1,'Marker','o');

        % 4.4
        % the image of spike and control ensembles on significant eigenvectors
        zeta1 = reshape(v1,1,256)*Spike_trig_stimuli;
        zeta2 = reshape(v2,1,256)*Spike_trig_stimuli;
        random_zeta1 = reshape(v1,1,256)*random_spike;
        random_zeta2 = reshape(v2,1,256)*random_spike;
        
        % histogram of spike and control images on the first eigenvector
        subplot(5,4,[5:6,9:10])
        histogram(zeta1,'Normalization','pdf','BinMethod','fd');
        hold on
        histogram(random_zeta1,'Normalization','pdf','BinMethod','fd');
        legend('spike','control');
        title('First Eigenvector','interpreter','latex');

        % histogram of spike and control images on the second eigenvector
        subplot(5,4,[7:8,11:12])
        histogram(zeta2,'Normalization','pdf','BinMethod','fd');
        hold on
        histogram(random_zeta2,'Normalization','pdf','BinMethod','fd');
        legend('spike','control');
        title('Second Eigenvector','interpreter','latex');

        % histogram of spike and control images on the first and second eigenvector
        subplot(5,4,[15:16,19:20])
        histogram2(zeta1,zeta2,'Normalization','pdf');
        hold on
        histogram2(random_zeta1,random_zeta2,'Normalization','pdf');
        legend('spike','control');
        title('Joint Distribution','interpreter','latex');
        
        % 4.5
        % statistics of spike and control ensembles
        mu1 = mean(zeta1);
        mu2 = mean(zeta2);
        sigma1 = std(zeta1);
        sigma2 = std(zeta2);
        random_mu1 = mean(random_zeta1);
        random_mu2 = mean(random_zeta2);
        random_sigma1 = std(random_zeta1);
        random_sigma2 = std(random_zeta2);
 
        % hypothesis testing, using joint gaussian model
        r = (mean(zeta1.*zeta2)-mu1*mu2)/(sigma1*sigma2);
        random_r = (mean(random_zeta1.*random_zeta2)-random_mu1*random_mu2)/(random_sigma1*random_sigma2);

        y1 = (1/(sigma1*sigma2*sqrt(1-r^2)))*exp(-0.5*(1/(1-r^2))*((zeta1-mu1).^2/sigma1^2+...
            (zeta2-mu2).^2/sigma2^2 - 2*(zeta1-mu1).*(zeta2-mu2)*r/(sigma1*sigma2) ));

        random_y1 = (1/(random_sigma1*random_sigma2*sqrt(1-random_r^2)))...
                *exp(-0.5*(1/(1-random_r^2))*((zeta1-random_mu1).^2/random_sigma1^2+...
                (zeta2-random_mu2).^2/random_sigma2^2 - ...
                2*(zeta1-random_mu1).*(zeta2-random_mu2)*random_r/(random_sigma1*random_sigma2) ));

        neurons(n).STC_percentage = 100*sum(y1>random_y1)/length(y1);        
        
   
end

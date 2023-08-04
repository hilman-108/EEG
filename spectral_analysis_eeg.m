clear;
clc;
S = load('20.mat');
data = transpose(S.data_final);
data=rmbase(data(:,1:111364));

Fs=128;
channels={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
ch=size(data,1);

eo1 = data(:,1:15360);
eo2 = data(:,53762:57602);
eo3 = data(:,96004:111364);

eyes_open = [eo1 eo2 eo3];


wlength=256;
NFFT = 2^nextpow2(wlength+1);
for c=1:14
    [power(c,:),frekuensi]=pwelch(data(c,:),hamming(256),wlength/2,NFFT,Fs);
    [power_eo(c,:),frekuensi_eo]=pwelch(eyes_open(c,:),hamming(256),wlength/2,NFFT,Fs);
end

power_all = transpose(power);
power_eyes_open = transpose(power_eo);

delta = sum(power_all(1:17,:));
theta = sum(power_all(17:33,:));
alpha = sum(power_all(33:61,:));
beta = sum(power_all(61:121,:));
gamma = sum(power_all(121:241,:));

delta_eo = mean(power_eyes_open(1:17,:));
theta_eo = mean(power_eyes_open(17:33,:));
alpha_eo = mean(power_eyes_open(33:61,:));
beta_eo = mean(power_eyes_open(61:121,:));
gamma_eo = mean(power_eyes_open(121:241,:));

for c=1:14
    pn_delta(:,c) = (delta(:,c)-delta_eo(:,c))/delta_eo(:,c);
    pn_theta(:,c) = (theta(:,c)-theta_eo(:,c))/theta_eo(:,c);
    pn_alpha(:,c) = (alpha(:,c)-alpha_eo(:,c))/alpha_eo(:,c);
    pn_beta(:,c) = (beta(:,c)-beta_eo(:,c))/beta_eo(:,c);
    pn_gamma(:,c) = (gamma(:,c)-gamma_eo(:,c))/gamma_eo(:,c);
    
    delta1(:,c) = delta(:,c)/theta(:,c);
    delta2(:,c) = delta(:,c)/alpha(:,c);
    delta3(:,c) = delta(:,c)/beta(:,c);
    delta4(:,c) = delta(:,c)/gamma(:,c);
    
    theta1(:,c) = theta(:,c)/delta(:,c);
    theta2(:,c) = theta(:,c)/alpha(:,c);
    theta3(:,c) = theta(:,c)/beta(:,c);
    theta4(:,c) = theta(:,c)/gamma(:,c);
    
    alpha1(:,c) = alpha(:,c)/delta(:,c);
    alpha2(:,c) = alpha(:,c)/theta(:,c);
    alpha3(:,c) = alpha(:,c)/beta(:,c);
    alpha4(:,c) = alpha(:,c)/gamma(:,c);
    
    beta1(:,c) = beta(:,c)/delta(:,c);
    beta2(:,c) = beta(:,c)/theta(:,c);
    beta3(:,c) = beta(:,c)/alpha(:,c);
    beta4(:,c) = beta(:,c)/gamma(:,c);
    
    gamma1(:,c) = gamma(:,c)/delta(:,c);
    gamma2(:,c) = gamma(:,c)/theta(:,c);
    gamma3(:,c) = gamma(:,c)/alpha(:,c);
    gamma4(:,c) = gamma(:,c)/beta(:,c);
end

pn_all = [pn_delta;pn_theta;pn_alpha;pn_beta;pn_gamma];

ratio_delta = [delta1;delta2;delta3;delta4];
ratio_theta = [theta1;theta2;theta3;theta4];
ratio_alpha = [alpha1;alpha2;alpha3;alpha4];
ratio_beta = [beta1;beta2;beta3;beta4];
ratio_gamma = [gamma1;gamma2;gamma3;gamma4];

pn_name={'AF3_PN_PN','F7_PN','F3_PN','FC5_PN','T7_PN','P7_PN','O1_PN','O2_PN','P8_PN','T8_PN','FC6_PN','F4_PN','F8_PN','AF4_PN'};
ratio_delta_name = {'AF3_delta','F7_delta','F3_delta','FC5__delta','T7_delta','P7_delta','O1_delta','O2_delta','P8_delta','T8_delta','FC6_delta','F4_delta','F8_delta','AF4_delta'};
ratio_theta_name = {'AF3_theta','F7_theta','F3_theta','FC5_theta','T7_theta','P7_theta','O1_theta','O2_theta','P8_theta','T8_theta','FC6_theta','F4_theta','F8_theta','AF4_theta_theta'};
ratio_alpha_name = {'AF3_alpha','F7_alpha','F3_alpha','FC5_alpha','T7_alpha','P7_alpha','O1_alpha','O2_alpha','P8_alpha','T8_alpha','FC6_alpha','F4_alpha','F8_alpha','AF4_alpha'};
ratio_beta_name = {'AF3_beta','F7_beta','F3_beta','FC5_beta','T7_beta','P7_beta','O1_beta','O2_beta','P8_beta','T8_beta','FC6_beta','F4_beta','F8_beta','AF4_beta'};
ratio_gamma_name = {'AF3_gamma','F7_gamma','F3_gamma','FC5_gamma','T7_gamma','P7_gamma','O1_gamma','O2_gamma','P8_gamma','T8_gamma','FC6_gamma','F4_gamma','F8_gamma','AF4_gamma'};

semua_data = [pn_name;num2cell(pn_all);ratio_delta_name;num2cell(ratio_delta);ratio_theta_name;num2cell(ratio_theta);ratio_alpha_name;num2cell(ratio_alpha);ratio_beta_name;num2cell(ratio_beta);ratio_gamma_name;num2cell(ratio_gamma)];
xlswrite('d20.xlsx', semua_data);

figure;
plot(frekuensi, power_all);
xlabel('Frequency (Hz)')
ylabel('Power Spectral (\muV^{2})')
xlim([0 60])
grid on
legend ('AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4')
=

figure;
plot(frekuensi_eo, power_eyes_open);
xlabel('Frequency (Hz)')
ylabel('Power Spectral (\muV^{2})')
xlim([0 60])
grid on
legend ('AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4')






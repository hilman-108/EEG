clear;
clc;
eeglab;
EEG = pop_biosig();
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
nama=ALLEEG.data;
ss=nama(3:16,:);
cc=ss(:,1:11520);
data=rmbase(cc);

Fs=128;
channels={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
ch=size(data,1);

for c=1:ch
    filtering(c,:)=eegfilt(data(c,:),128,1,45,0,64);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%source = http://www.mat.ucm.es/~vmakarov/Supplementary/wICAexample/TestExample.html%%
[weight, sphere] = runica(filtering, 'verbose', 'off');
W = weight*sphere;
icaEEG = W*filtering;
[icaEEG2, opt]= RemoveStrongArtifacts(icaEEG, (1:14), 1.25, Fs);
Data_wICA = inv(W)*icaEEG2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trials = 30;
scales = 20;
% store the sample entropy values
t = zeros(scales, 1);
r = 0.15;
m = 2;
n = 3000; % the example uses 30,000



for tau = 1:scales
    for j = 1:trials
        [ AF3_MSE(tau, j), A1, B1 ] = multiscaleSampleEntropy( Data_wICA(1,:), m, r, tau );
        [ F7_MSE(tau, j), A2, B2 ] = multiscaleSampleEntropy( Data_wICA(2,:), m, r, tau );
        [ F3_MSE(tau, j), A3, B3 ] = multiscaleSampleEntropy( Data_wICA(3,:), m, r, tau );
        [ FC5_MSE(tau, j), A4, B4 ] = multiscaleSampleEntropy( Data_wICA(4,:), m, r, tau );
        [ T7_MSE(tau, j), A5, B5 ] = multiscaleSampleEntropy( Data_wICA(5,:), m, r, tau );
        [ P7_MSE(tau, j), A6, B6 ] = multiscaleSampleEntropy( Data_wICA(6,:), m, r, tau );
        [ O1_MSE(tau, j), A7, B7 ] = multiscaleSampleEntropy( Data_wICA(7,:), m, r, tau );
        [ O2_MSE(tau, j), A8, B8 ] = multiscaleSampleEntropy( Data_wICA(8,:), m, r, tau );
        [ P8_MSE(tau, j), A9, B9 ] = multiscaleSampleEntropy( Data_wICA(9,:), m, r, tau );
        [ T8_MSE(tau, j), A10, B10 ] = multiscaleSampleEntropy( Data_wICA(10,:), m, r, tau );
        [ FC6_MSE(tau, j), A11, B11 ] = multiscaleSampleEntropy( Data_wICA(11,:), m, r, tau );
        [ F4_MSE(tau, j), A12, B12 ] = multiscaleSampleEntropy( Data_wICA(12,:), m, r, tau );
        [ F8_MSE(tau, j), A13, B13 ] = multiscaleSampleEntropy( Data_wICA(13,:), m, r, tau );
        [ AF4_MSE(tau, j), A14, B14 ] = multiscaleSampleEntropy( Data_wICA(14,:), m, r, tau );
    end
end

AF3 = mean(AF3_MSE, 2);
F7 = mean(F7_MSE, 2);
F3 = mean(F3_MSE, 2);
FC5 = mean(FC5_MSE, 2);
T7 = mean(T7_MSE, 2);
P7 = mean(P7_MSE, 2);
O1 = mean(O1_MSE, 2);
O2 = mean(O2_MSE, 2);
P8 = mean(P8_MSE, 2);
T8 = mean(T8_MSE, 2);
FC6 = mean(FC6_MSE, 2);
F4 = mean(F4_MSE, 2);
F8 = mean(F8_MSE, 2);
AF4 = mean(AF4_MSE, 2);

f1 = figure('visible','off');
Hasil = [AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4];
plot(Hasil);
title('Multiscale Sample Entropy')
xlabel('Entropy')
ylabel('Scales')
grid on
legend ('AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4')
saveas(f1,'multiscale.jpg')
xlswrite('data.xlsx', Hasil);

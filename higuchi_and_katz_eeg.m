eeglab;
EEG = pop_biosig();
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
nama=ALLEEG.data;

ss=nama(3:16,:);
cc=ss(:,1:23040);
data=rmbase(cc);

Fs=128;
channels={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
ch=size(data,1);

for c=1:ch
    filtering(c,:)=eegfilt(data(c,:),128,1,45,0,64);
end

[weight, sphere] = runica(filtering, 'verbose', 'off');
W = weight*sphere;
icaEEG = W*filtering;
[icaEEG2, opt]= RemoveStrongArtifacts(icaEEG, (1:14), 1.25, Fs);
Data_wICA = inv(W)*icaEEG2;


wlength=256;
NFFT = 2^nextpow2(wlength+1);
for c=1:14
    [power(c,:),frekuensi]=pwelch(Data_wICA(c,:),hamming(256),wlength/2,NFFT,Fs);
end

AF3 = Data_wICA(1,:);
F7 = Data_wICA(2,:);
F3 = Data_wICA(3,:);
FC5 = Data_wICA(4,:);
T7 = Data_wICA(5,:);
P7 = Data_wICA(6,:);
O1 = Data_wICA(7,:);
O2 = Data_wICA(8,:);
P8 = Data_wICA(9,:);
T8 = Data_wICA(10,:);
FC6 = Data_wICA(11,:);
F4 = Data_wICA(12,:);
F8 = Data_wICA(13,:);
AF4 = Data_wICA(14,:);

AF3_H = Higuchi_FD(AF3, 60);
F7_H = Higuchi_FD(F7, 60);
F3_H = Higuchi_FD(F3, 60);
FC5_H = Higuchi_FD(FC5, 30);
T7_H = Higuchi_FD(T7, 30);
P7_H = Higuchi_FD(P7, 60);
O1_H = Higuchi_FD(O1, 60);
O2_H = Higuchi_FD(O2, 60);
P8_H = Higuchi_FD(P8, 60);
T8_H = Higuchi_FD(T8, 30);
FC6_H = Higuchi_FD(FC6, 30);
F4_H = Higuchi_FD(F4, 60);
F8_H = Higuchi_FD(F8, 60);
AF4_H = Higuchi_FD(AF4, 60);

Hasil_H = [AF3_H F7_H F3_H FC5_H T7_H P7_H O1_H O2_H P8_H T8_H FC6_H F4_H F8_H AF4_H];
figure;
bar(diag(Hasil_H), 'stacked')
set(gca,'XTickLabel',{'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'});
title('Metode Hiiguchi')
xlabel('Elektroda')
ylabel('Kompleksitas')


AF3_K = Katz_FD(AF3, 60);
F7_K = Katz_FD(F7, 60);
F3_K = Katz_FD(F3, 60);
FC5_K = Katz_FD(FC5, 30);
T7_K = Katz_FD(T7, 30);
P7_K = Katz_FD(P7, 60);
O1_K = Katz_FD(O1, 60);
O2_K = Katz_FD(O2, 60);
P8_K = Katz_FD(P8, 60);
T8_K = Katz_FD(T8, 30);
FC6_K = Katz_FD(FC6, 30);
F4_K = Katz_FD(F4, 60);
F8_K = Katz_FD(F8, 60);
AF4_K = Katz_FD(AF4, 60);

Hasil_K = [AF3_K F7_K F3_K FC5_K T7_K P7_K O1_K O2_K P8_K T8_K FC6_K F4_K F8_K AF4_K];
figure;
bar(diag(Hasil_K), 'stacked')
set(gca,'XTickLabel',{'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'});
title('Metode Katz')
xlabel('Elektroda')
ylabel('Kompleksitas')


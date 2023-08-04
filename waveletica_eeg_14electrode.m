clear; clc;
eeglab;
EEG = pop_biosig();
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
nama=ALLEEG.data;
ss=nama(3:16,:);
cc=ss(:,1:15360);

data=rmbase(ss);

Fs=128;
ch=size(data,1);
for c=1:ch
    filtering(c,:)=eegfilt(data(c,:),128,1,45,0,64);
end
channels={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
figure;

%%source = http://www.mat.ucm.es/~vmakarov/Supplementary/wICAexample/TestExample.html%%
PlotEEG(filtering, Fs, channels, 200, 'Filtering');

[weight, sphere] = runica(filtering, 'verbose', 'off');
W = weight*sphere;
icaEEG = W*filtering;

[icaEEG2, opt]= RemoveStrongArtifacts(icaEEG, (1:14), 1.25, Fs);
Data_wICA = inv(W)*icaEEG2;
figure;
PlotEEG(Data_wICA, Fs, channels, 200, 'wICA cleanned EEG');

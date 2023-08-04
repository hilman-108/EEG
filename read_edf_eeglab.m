clear;
clc;
eeglab;
EEG = pop_biosig();
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
data=ALLEEG.data;

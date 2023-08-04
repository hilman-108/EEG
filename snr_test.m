tanpa_noise=filtering(:,5120:6400);
dengan_noise=filtering(:,5120:7680);
ICA=Data_wICA(:,5120:7680);

%%menghitung variance
for c=1:14
    varianTN(c,:)=var(tanpa_noise(c,:));
end

for c=1:14
    varianDN(c,:)=var(dengan_noise(c,:));
end

for c=1:14
    varianICA(c,:)=var(ICA(c,:));
end

%menghitung snr
for c=1:14
    snrFILT(c,:)=10*log10(varianTN(c,:)/varianDN(c,:));
end

for c=1:14
    snrICA(c,:)=10*log10(varianTN(c,:)/varianICA(c,:));
end

[snrFILT snrICA]

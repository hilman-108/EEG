clear;clc;
clear; clc;

d1 = xlsread('d1');
d2 = xlsread('d2');
d3 = xlsread('d3');
d4 = xlsread('d4');
d5 = xlsread('d5');
d6 = xlsread('d6');
d7 = xlsread('d7');
d8 = xlsread('d8');
d9 = xlsread('d9');
d10 = xlsread('d10');
d11 = xlsread('d11');
d12 = xlsread('d12');
d13 = xlsread('d13');
d14 = xlsread('d14');
d15 = xlsread('d15');
d16 = xlsread('d16');
d17 = xlsread('d17');
d18 = xlsread('d18');
d19 = xlsread('d19');
d20 = xlsread('d20');

%%Power Normalized

for i=1:30
    for j=1:14
        data(:,:,i,j) = [d1(i,j) d11(i,j); d2(i,j) d12(i,j); d3(i,j) d13(i,j); d4(i,j) d14(i,j);...
        d5(i,j) d15(i,j); d6(i,j) d16(i,j); d7(i,j) d17(i,j); d8(i,j) d18(i,j); d9(i,j) d19(i,j); d10(i,j) d20(i,j)];
    end
end

channels={'AF3-V','AF3-T','F7-V','F7-T','F3-V','F3-T','FC5-V','FC5-T','T7-V','T7-T','P7-V','P7-T','O1-V','O1-T'...
    'O2-V','O2-T','P8-V','P8-T','T8-V','T8-T','FC6-V','FC6-T','F4-V','F4-T','F8-V','F8-T','AF4-V','AF4-T'};

for i=1:30
    for j=1:14
        A = data(:,:,i,j);
        [h(i,j),p(i,j)] = ttest2(A(:,1),A(:,2),'Vartype','unequal');
    end
end

nama = 'hasil.xlsx';
nama_sheet = 'sheet';
format = '.xlsx';

for j=1:30
    all_pn = [];
    for k=1:14
        dt = data(:,:,j,k);
        all_pn = cat(2,all_pn,dt);
    end
    conv = num2str(j);
    name_sheet = strcat(nama_sheet,conv);
    all_data = [channels;num2cell(all_pn)];
    xlswrite(nama, all_data, name_sheet);
end


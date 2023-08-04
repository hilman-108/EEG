clear; clc;
N = 1000; %jumlah kanal
Vmax = 10000; % tegangan maksimal
I = Vmax/N; %rentang tegangan
for c=1:N
    A(c,:)=[(c-1)*10:1:c*10];
end
Z= 0+rand(N,1)*(10000);
for i=1:N
    T=Z(i);
    for c=1:N
        D(c,:)=A(c,:)/fix(T);
    end
    [row,~]=find(D==1);
    H=max(row);
    P=A(H,:);
    kanal(i,:)=[Z(i) min(P) max(P)];
end

histogram(kanal(:,3), 'BinWidth', 10)

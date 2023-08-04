spektral=xlsread('Spektral');

subjek1=spektral(1:8,:);
subjek2=spektral(12:19,:);
subjek3=spektral(23:30,:);
subjek4=spektral(34:41,:);
subjek5=spektral(45:52,:);
subjek6=spektral(56:63,:);
subjek7=spektral(67:74,:);
subjek8=spektral(78:85,:);


%%Subjek-1 vs Subjek-5
for c=1:8
    [p1(c,:),h1(c,:)] = ranksum(subjek1(c,:),subjek5(c,:));
end

%%Subjek-2 vs Subjek-6
for c=1:8
    [p2(c,:),h2(c,:)] = ranksum(subjek2(c,:),subjek6(c,:));
end

%%Subjek-3 vs Subjek-7
for c=1:8
    [p3(c,:),h3(c,:)] = ranksum(subjek3(c,:),subjek7(c,:));
end

%%Subjek-1 vs Subjek-5
for c=1:8
    [p4(c,:),h4(c,:)] = ranksum(subjek4(c,:),subjek8(c,:));
end

[p1 p2 p3 p4]

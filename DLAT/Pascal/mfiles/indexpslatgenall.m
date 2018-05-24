%script om uit te vissen waar de grote verschillen tussen A0306,A0307 vs de andere dieren vandaan komen

A0306 = [4 6 7 8 10 11 13 17 24 25 29 31 33 35 38 44 47 48 49 50 51];
A0307 = [6 7 8 14 15 17 29 30 32 43 45 50 53 55 56 58 61 64 65 66 81 88 91 101 103 104];
A0241 = [10 17 18 19 20 21 23 25 33 35 37 39 42 47 48 55 64 65 67 72 82 83];
A0242 = [1 2 4 7 8 9 10 11 12 13 14 17 18 19 20 21 22 25 26 28 31 32 33 34 37 44 47 48 49 51 52 63 76 82 85 86 88 89 90 92];
A0428 = [6 7 11 12 13 18 19 20 21 22 23 36 42 43 44 46 48 49 50 51 52 53 55 57 59 60 61 62 64 66 68 70 71 73 74 75];
A0454 = [5 6 9 10 13 34 35 36 40 41 44 47 48 58 59 68 71 72 74 75];

%effect van gemiddelde drempel?
T6 = selectsplitFibers('A0306', thrlist('A0306'), 150, 5000);
T7 = selectsplitFibers('A0307', thrlist('A0307'), 150, 5000);
T41 = selectsplitFibers('A0241', thrlist('A0241'), 150, 5000);
T42 = selectsplitFibers('A0242', thrlist('A0242'), 150, 5000);
T28 = selectsplitFibers('A0428', thrlist('A0428'), 150, 5000);
T54 = selectsplitFibers('A0454', thrlist('A0454'), 150, 5000);

A0306t = zeros(1,numel(A0306));
for i=1:numel(A0306)
    eval(['c = structfilter(T6,''$fibernr$==' num2str(A0306(i)) ''');']);
    A0306t(i) = c(numel(c)).thr;
end
A0307t = zeros(1,numel(A0307));
for i=1:numel(A0307)
    eval(['c = structfilter(T7,''$fibernr$==' num2str(A0307(i)) ''');']);
    A0307t(i) = c(numel(c)).thr;
end
A0241t = zeros(1,numel(A0241));
for i=1:numel(A0241)
    eval(['c = structfilter(T41,''$fibernr$==' num2str(A0241(i)) ''');']);
    A0241t(i) = c(numel(c)).thr;
end
A0242t = zeros(1,numel(A0242));
for i=1:numel(A0242)
    eval(['c = structfilter(T42,''$fibernr$==' num2str(A0242(i)) ''');']);
    A0242t(i) = c(numel(c)).thr;
end
A0428t = zeros(1,numel(A0428));
for i=1:numel(A0428)
    eval(['c = structfilter(T28,''$fibernr$==' num2str(A0428(i)) ''');']);
    A0428t(i) = c(numel(c)).thr;
end
A0454t = zeros(1,numel(A0454));
for i=1:numel(A0454)
    eval(['c = structfilter(T54,''$fibernr$==' num2str(A0454(i)) ''');']);
    A0454t(i) = c(numel(c)).thr;
end
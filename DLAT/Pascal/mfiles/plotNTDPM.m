echo on;

figure(1)
%=======================================================
% neuron 98: MBL 70
%=======================================================
subplot(3,2,1); grid on; hold on;
BestDelay9870 = []; % maakt nieuwe, lege variable aan

DF = 'M0545D' % duidt dataset aan

dsIDp = '98-31-NTD'; % duidt specifieke recording aan
ds1 = dataset(DF, dsIDp); % maakt variable aan
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx); % maakt ITD curve aan
[How,Where] = max(Y); % berekent maximum van ITD curve, en plaats van het maximum
BD = X(Where); % x-coordinaat (plaats van maximum) is best delay
BestDelay9870 = [BestDelay9870 BD]; % voegt nieuwe BD toe aan (tot hier toe lege) bestdelay variable
plot(X,Y) % plot ITD curve
plot(X(Where),How,'o') % duidt BD aan op ITD curve

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay9870 = [BestDelay9870 BD];
plot(X,Y,'r')
plot(X(Where),How,'ro')

dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay9870 = [BestDelay9870 BD];
plot(X,Y,'y')
plot(X(Where),How,'yo')

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay9870 = [BestDelay9870 BD];
plot(X,Y,'g')
plot(X(Where),How,'go')

%=======================================================
% neuron 110: MBL 70
%=======================================================
subplot(3,2,2); grid on; hold on;
BestDelay11070 = [];

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11070 = [BestDelay11070 BD];
plot(X,Y)
plot(X(Where),How,'o')

dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11070 = [BestDelay11070 BD];
plot(X,Y,'r')
plot(X(Where),How,'ro')

dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11070 = [BestDelay11070 BD];
plot(X,Y,'y')
plot(X(Where),How,'yo')

dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11070 = [BestDelay11070 BD];
plot(X,Y,'g')
plot(X(Where),How,'go')

%=======================================================
% neuron 110: MBL 65
%=======================================================
subplot(3,2,3); grid on; hold on;
BestDelay11065 = [];

dsIDp = '110-15-NTD-6070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11065 = [BestDelay11065 BD];
plot(X,Y)
plot(X(Where),How,'o')

dsIDp = '110-17-NTD-7060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11065 = [BestDelay11065 BD];
plot(X,Y,'r')
plot(X(Where),How,'ro')

%=======================================================
% neuron 110: MBL 75
%=======================================================
subplot(3,2,4); grid on; hold on;
BestDelay11075 = [];

dsIDp = '110-16-NTD-8070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(-ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11075 = [BestDelay11075 BD];
plot(X,Y)
plot(X(Where),How,'o')

dsIDp = '110-18-NTD-7080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(-ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11075 = [BestDelay11075 BD];
plot(X,Y,'r')
plot(X(Where),How,'ro')

%=======================================================
% neuron 112: MBL 70
%=======================================================
subplot(3,2,5); grid on; hold on;
BestDelay11270 = [];

dsIDp = '112-6-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(-ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11270 = [BestDelay11270 BD];
plot(X,Y)
plot(X(Where),How,'o')

dsIDp = '112-7-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X, idx] = sort(-ds1.indepval(1:Nrec));
Y = getrate(ds1, idx);
[How,Where] = max(Y);
BD = X(Where);
BestDelay11270 = [BestDelay11270 BD];
plot(X,Y,'r')
plot(X(Where),How,'ro')

echo off;

%Resetting vector strength vectors ...
[Rin, Rmon, Rbin] = deal([]);

ITDrange = linspace(-6000, +6000, 501); %ITD steps to be calculated in microsec ...

%Model parameters
P.anwin    = [0 25];%Analysis window in ms ...
P.ninputs  = 2;       %Number of inputs ...
P.ainputs  = 1.00;    %Amplitude of the inputs given as a scalar or 
                      %a rowvector with the same length as the number
                      %of inputs ...
P.trefrac  = 0.000;   %Refractory period in ms ...
P.tdecay   = 0.200;   %Decay period of input amplitude in ms ...
P.thr      = 1.25;    %Threshold level ...
P.repmode  = 'pair';  %Handling of repetitions: 'all' or 'pair' ...

%Dataset information
DF       = 'A0240';
dsIDStim = '1-2';
StimFreq = 600;
dsIDSpon = '1-2';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '1-3';
StimFreq = 600;
dsIDSpon = '1-3';
SponFreq = 1450;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '4-4';
StimFreq = 1000;
dsIDSpon = '4-4';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '4-4';
StimFreq = 1000;
dsIDSpon = '4-4';
SponFreq = 1650;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '7-5';
StimFreq = 700;
dsIDSpon = '7-5';
SponFreq = 300;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '12-7';
StimFreq = 450;
dsIDSpon = '12-7';
SponFreq = 900;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '15-6';
StimFreq = 725;
dsIDSpon = '15-6';
SponFreq = 325;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0240';
dsIDStim = '16-2';
StimFreq = 700;
dsIDSpon = '16-2';
SponFreq = 350;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0241';
dsIDStim = '10-3';
StimFreq = 250;
dsIDSpon = '10-3';
SponFreq = 1000;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 1000];     %Analysis window in ms ...

%Dataset information
DF       = 'A0241';
dsIDStim = '16-3';
StimFreq = 450;
dsIDSpon = '16-3';
SponFreq = 1100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0241';
dsIDStim = '23-3';
StimFreq = 450;
dsIDSpon = '23-3';
SponFreq = 1200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0241';
dsIDStim = '37-4';
StimFreq = 200;
dsIDSpon = '37-4';
SponFreq = 750;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0241';
dsIDStim = '42-4';
StimFreq = 1100;
dsIDSpon = '42-4';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0241';
dsIDStim = '47-3';
StimFreq = 700;
dsIDSpon = '47-3';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '1-5';
StimFreq = 1000;
dsIDSpon = '1-5';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 25];    %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '2-3';
StimFreq = 300;
dsIDSpon = '2-3';
SponFreq = 1200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '3-2';
StimFreq = 275;
dsIDSpon = '3-2';
SponFreq = 1000;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 1000];    %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '4-4';
StimFreq = 250;
dsIDSpon = '4-4';
SponFreq = 1000;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 25];     %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '11-3';
StimFreq = 850;
dsIDSpon = '11-3';
SponFreq = 2100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '12-3';
StimFreq = 750;
dsIDSpon = '12-3';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '13-3';
StimFreq = 1100;
dsIDSpon = '13-3';
SponFreq = 400;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 1000];    %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '13-4';
StimFreq = 1250;
dsIDSpon = '13-4';
SponFreq = 400;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '17-4';
StimFreq = 550;
dsIDSpon = '17-4';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '18-3';
StimFreq = 950;
dsIDSpon = '18-3';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '25-3';
StimFreq = 650;
dsIDSpon = '25-3';
SponFreq = 1650;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 25];    %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '28-3';
StimFreq = 850;
dsIDSpon = '28-3';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 1000];     %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '28-4';
StimFreq = 800;
dsIDSpon = '28-4';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 25];      %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '31-1';
StimFreq = 450;
dsIDSpon = '31-1';
SponFreq = 2050;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [0 1000];     %Analysis window in ms ...

%Dataset information
DF       = 'A0242';
dsIDStim = '31-4';
StimFreq = 500;
dsIDSpon = '31-4';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '32-3';
StimFreq = 700;
dsIDSpon = '32-3';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '33-4';
StimFreq = 900;
dsIDSpon = '33-4';
SponFreq = 500;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '34-4';
StimFreq = 1000;
dsIDSpon = '34-4';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '37-3';
StimFreq = 300;
dsIDSpon = '37-3';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '38-4';
StimFreq = 500;
dsIDSpon = '38-4';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '44-3';
StimFreq = 550;
dsIDSpon = '44-3';
SponFreq = 1100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '45-3';
StimFreq = 1000;
dsIDSpon = '45-3';
SponFreq = 450;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '51-3';
StimFreq = 750;
dsIDSpon = '51-3';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '52-3';
StimFreq = 250;
dsIDSpon = '52-3';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '53-4';
StimFreq = 1800;
dsIDSpon = '53-4';
SponFreq = 300;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '60-3';
StimFreq = 250;
dsIDSpon = '60-3';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '61-3';
StimFreq = 350;
dsIDSpon = '61-3';
SponFreq = 100;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '63-3';
StimFreq = 1150;
dsIDSpon = '63-3';
SponFreq = 350;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '70-3';
StimFreq = 1050;
dsIDSpon = '70-3';
SponFreq = 300;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '85-3';
StimFreq = 500;
dsIDSpon = '85-3';
SponFreq = 200;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '85-11';
StimFreq = 550;
dsIDSpon = '85-11';
SponFreq = 1400;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '86-4';
StimFreq = 700;
dsIDSpon = '86-4';
SponFreq = 2000;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '88-3';
StimFreq = 600;
dsIDSpon = '88-3';
SponFreq = 150;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Dataset information
DF       = 'A0242';
dsIDStim = '90-5';
StimFreq = 150;
dsIDSpon = '90-5';
SponFreq = 50;

dsStim = dataset(DF, dsIDStim);
dsSpon = dataset(DF, dsIDSpon);

[RinTmp, RmonTmp, RbinTmp] = StaticITD(P, ITDrange, dsStim, StimFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Saving data to disk
save(mfilename, 'Rin', 'Rmon', 'Rbin');
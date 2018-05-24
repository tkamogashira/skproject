%All data:binaural beat data and timewarped data
%Subdivision high spontaneous rate(HSR)-low spontaneous rate(LSR)
%if Rin=0 -> not included in scatterplots
%if Rmon=0 -> not included in scatterplots (exeption! data LSR)
%Correction for analysis window in ms
    %[1cycle 25]
    %[100cycles 1000]
    %[100cycles 5000]

%After binbeat2script.m run figbinbeat2.m    
    
%Resetting vector strength vectors ...
[Rin, Rmon, Rbin] = deal([]);

%Model parameters
P.anwin    = [0 5000];%Analysis window in ms ...
P.ninputs  = 4;       %Number of inputs ...
P.ainputs  = 1;       %Amplitude of the inputs given as a scalar or 
                      %a rowvector with the same length as the number
                      %of inputs ...
P.trefrac  = 0.000;   %Refractory period in ms ...
P.tdecay   = 0.200;   %Decay period of input amplitude in ms ...
P.thr      = 1.25;    %Threshold level ...
P.repmode  = 'pair';  %Handling of repetitions: 'all' or 'pair' ...

P.anwin = [100000/760 5000]

%Datasets binaural beat HSR
%Dataset information
DF            = 'A0428';
dsIDipsi      = '31-2'; IpsiFreq   = 760;
dsIDcontra    = '31-3'; ContraFreq = 761;
dsIDspon      = '31-4'; SponFreq   = 999;
    %spontaneous rate = 74.9spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/590 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '35-3'; IpsiFreq   = 590;
dsIDcontra    = '35-2'; ContraFreq = 591;
dsIDspon      = '35-4'; SponFreq   = 9999;
    %spontaneous rate = 68.2spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/690 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '36-2'; IpsiFreq   = 690;
dsIDcontra    = '36-3'; ContraFreq = 691;
dsIDspon      = '36-4'; SponFreq   = 9999;
    %spontaneous rate = 55.6spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/690 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '38-2'; IpsiFreq   = 690;
dsIDcontra    = '38-3'; ContraFreq = 691;
dsIDspon      = '38-4'; SponFreq   = 9999; 
    %spontaneous rate = 44.9spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1500 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '40-2'; IpsiFreq   = 1500;
dsIDcontra    = '40-3'; ContraFreq = 1501;
dsIDspon      = '40-4'; SponFreq   = 9999;
    %spontaneous rate = 81spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/2500 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '40-7'; IpsiFreq   = 2500;
dsIDcontra    = '40-8'; ContraFreq = 2501;
dsIDspon      = '40-4'; SponFreq   = 9999;
    %spontaneous rate = 81spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Datasets binaural beat LSR

P.anwin = [100000/760 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '39-2'; IpsiFreq   = 760;
dsIDcontra    = '39-3'; ContraFreq = 761;
dsIDspon      = '39-4'; SponFreq   = 999;
    %spontaneous rate = 3.99spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsContra = dataset(DF, dsIDcontra);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, IpsiFreq, dsContra, ContraFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Timewarped data HSR
%P.anwin    = [1000/600 25];   %Analysis window in ms ...

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '1-2'; StimFreq = 600; BeatFreq = 1;
%dsIDspon      = '1-2'; SponFreq = 200; 
    %spontaneous rate = 44.5spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/600 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '1-3'; StimFreq = 600; BeatFreq = 1;
%dsIDspon      = '1-3'; SponFreq = 1450; 
    %spontaneous rate = 44.5spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/600 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '4-4'; StimFreq = 600; BeatFreq = 1;
%dsIDspon      = '4-4'; SponFreq = 200; 
    %Attention: no threshold curve
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/600 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '4-4'; StimFreq = 600; BeatFreq = 1;
%dsIDspon      = '4-4'; SponFreq = 1650; 
    %Attention: no threshold curve
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/450 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '12-7'; StimFreq = 450; BeatFreq = 1;
%dsIDspon      = '12-7'; SponFreq = 900; 
    %spontaneous rate = 66.5spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/725 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '15-6'; StimFreq = 725; BeatFreq = 1;
%dsIDspon      = '15-6'; SponFreq = 325; 
    %spontaneous rate = 32.7spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/700 25]

%Dataset information
%DF            = 'A0240';
%dsIDipsi      = '16-2'; StimFreq = 700; BeatFreq = 1;
%dsIDspon      = '16-2'; SponFreq = 350; 
    %spontaneous rate = 53.7spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/1000 25]

%Dataset information
%DF            = 'A0241';
%dsIDipsi      = '10-3'; StimFreq = 1000; BeatFreq = 1;
%dsIDspon      = '10-3'; SponFreq = 250; 
    %spontaneous rate = 27.1spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin    = [100000/450 1000];    %Analysis window in ms ...

%Dataset information
%DF            = 'A0241';
%dsIDipsi      = '16-3'; StimFreq = 450; BeatFreq = 1;
%dsIDspon      = '16-3'; SponFreq = 1100; 
    %spontaneous rate = 62.9spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin = [100000/200 1000]

%Dataset information
DF            = 'A0241';
dsIDipsi      = '37-4'; StimFreq = 200; BeatFreq = 1;
dsIDspon      = '37-4'; SponFreq = 750; 
    %spontaneous rate = 43spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1000 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '1-5'; StimFreq = 1000; BeatFreq = 1;
dsIDspon      = '1-5'; SponFreq = 200;
    %spontaneous rate = 52.1spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin    = [1000/300 25];     %Analysis window in ms ...

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '2-3'; StimFreq = 300; BeatFreq = 1;
%dsIDspon      = '2-3'; SponFreq = 1200;
    %spontaneous rate = 86.7spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/275 25]

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '3-2'; StimFreq = 275; BeatFreq = 1;
%dsIDspon      = '3-2'; SponFreq = 1000;
    %spontaneous rate = 65.3spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin    = [100000/250 1000];    %Analysis window in ms ...

%Dataset information
DF            = 'A0242';
dsIDipsi      = '4-4'; StimFreq = 250; BeatFreq = 1;
dsIDspon      = '4-4'; SponFreq = 1000;
    %spontaneous rate = 74.7spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin    = [1000/850 25];   %Analysis window in ms ...

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '11-3'; StimFreq = 850; BeatFreq = 1;
%dsIDspon      = '11-3'; SponFreq = 2100;
    %spontaneous rate = 58.8spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/750 25]

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '12-3'; StimFreq = 750; BeatFreq = 1;
%dsIDspon      = '12-3'; SponFreq = 200;
    %spontaneous rate = 39spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1650 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '25-3'; StimFreq = 1650; BeatFreq = 1;
dsIDspon      = '25-3'; SponFreq = 650;
    %spontaneous rate = 60.6spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin    = [1000/850 25];      %Analysis window in ms ...

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '28-3'; StimFreq = 850; BeatFreq = 1;
%dsIDspon      = '28-3'; SponFreq = 100;
    %spontaneous rate = 53.1spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin    = [100000/800 1000];     %Analysis window in ms ...

%Dataset information
DF            = 'A0242';
dsIDipsi      = '28-4'; StimFreq = 800; BeatFreq = 1;
dsIDspon      = '28-4'; SponFreq = 50;
    %spontaneous rate = 53.1spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin    = [1000/450 25];    %Analysis window in ms ...

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '31-1'; StimFreq = 450; BeatFreq = 1;
%dsIDspon      = '31-1'; SponFreq = 2050;
    %spontaneous rate = 75.7spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin     = [100000/500 1000];    %Analysis window in ms ...

%Dataset information
DF            = 'A0242';
dsIDipsi      = '31-4'; StimFreq = 500; BeatFreq = 1;
dsIDspon      = '31-4'; SponFreq = 100;
    %spontaneous rate = 75.7spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/700 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '32-3'; StimFreq = 700; BeatFreq = 1;
dsIDspon      = '32-3'; SponFreq = 100;
    %spontaneous rate = 91.6spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1000 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '34-4'; StimFreq = 1000; BeatFreq = 1;
dsIDspon      = '34-4'; SponFreq = 100;
    %spontaneous rate = 43.2spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/300 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '37-3'; StimFreq = 300; BeatFreq = 1;
dsIDspon      = '37-3'; SponFreq = 50;
    %spontaneous rate = 63.1spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/500 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '38-4'; StimFreq = 500; BeatFreq = 1;
dsIDspon      = '38-4'; SponFreq = 100;
    %spontaneous rate = 77.7spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1800 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '53-4'; StimFreq = 1800; BeatFreq = 1;
dsIDspon      = '53-4'; SponFreq = 300;
    %spontaneous rate = 58.1 spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/350 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '61-3'; StimFreq = 350; BeatFreq = 1;
dsIDspon      = '61-3'; SponFreq = 100;
    %spontaneous rate = 70.4spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1150 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '63-3'; StimFreq = 1150; BeatFreq = 1;
dsIDspon      = '63-3'; SponFreq = 350;
    %spontaneous rate = 66.4spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1050 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '70-3'; StimFreq = 1050; BeatFreq = 1;
dsIDspon      = '70-3'; SponFreq = 300;
    %spontaneous rate = 69.2spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin = [100000/700 1000]

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '86-4'; StimFreq = 700; BeatFreq = 1;
%dsIDspon      = '86-4'; SponFreq = 2000;
    %spontaneous rate = 73.5spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin = [100000/600 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '88-3'; StimFreq = 600; BeatFreq = 1;
dsIDspon      = '88-3'; SponFreq = 150;
    %spontaneous rate = 68.4spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];


%Timewarped data LSR
P.anwin = [1000/700 25]

%Dataset information
DF            = 'A0240';
dsIDipsi      = '7-5'; StimFreq = 700; BeatFreq = 1;
dsIDspon      = '7-5'; SponFreq = 300; 
    %spontaneous rate = 2.06spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/450 1000]

%Dataset information
DF            = 'A0241';
dsIDipsi      = '23-3'; StimFreq = 450; BeatFreq = 1;
dsIDspon      = '23-3'; SponFreq = 1200; 
    %spontaneous rate = 1.93spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1100 1000]

%Dataset information
DF            = 'A0241';
dsIDipsi      = '42-4'; StimFreq = 1100; BeatFreq = 1;
dsIDspon      = '42-4'; SponFreq = 200; 
    %spontaneous rate = 1.06spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/700 1000]

%Dataset information
DF            = 'A0241';
dsIDipsi      = '47-3'; StimFreq = 700; BeatFreq = 1;
dsIDspon      = '47-3'; SponFreq = 50; 
    %spontaneous rate = 2.46spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%P.anwin = [1000/400 25]

%Dataset information
%DF            = 'A0242';
%dsIDipsi      = '13-3'; StimFreq = 400; BeatFreq = 1;
%dsIDspon      = '13-3'; SponFreq = 1100;
    %spontaneous rate = 3.52spk/s
%dsIpsi   = dataset(DF, dsIDipsi);
%dsSpon   = dataset(DF, dsIDspon);

%[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
%Rin  = [Rin; RinTmp];
%Rmon = [Rmon; RmonTmp];
%Rbin = [Rbin; RbinTmp];

P.anwin    = [100000/1250 1000];   %Analysis window in ms ...

%Dataset information
DF            = 'A0242';
dsIDipsi      = '13-4'; StimFreq = 1250; BeatFreq = 1;
dsIDspon      = '13-4'; SponFreq = 400;
    %spontaneous rate = 3.52spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/550 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '17-4'; StimFreq = 550; BeatFreq = 1;
dsIDspon      = '17-4'; SponFreq = 200;
    %spontaneous rate = 2.79spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/950 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '18-3'; StimFreq = 950; BeatFreq = 1;
dsIDspon      = '18-3'; SponFreq = 200;
    %spontaneous rate = 1.73 spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/900 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '33-4'; StimFreq = 900; BeatFreq = 1;
dsIDspon      = '33-4'; SponFreq = 500;
    %spontaneous rate = 0.199spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/550 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '44-3'; StimFreq = 550; BeatFreq = 1;
dsIDspon      = '44-3'; SponFreq = 1100;
    %spontaneous rate = 0.0665spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1000 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '45-3'; StimFreq = 1000; BeatFreq = 1;
dsIDspon      = '45-3'; SponFreq = 450;
    %spontaneous rate = 0.266spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/750 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '51-3'; StimFreq = 750; BeatFreq = 1;
dsIDspon      = '51-3'; SponFreq = 200;
    %spontaneous rate = 3.13spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/250 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '52-3'; StimFreq = 250; BeatFreq = 1;
dsIDspon      = '52-3'; SponFreq = 50;
    %spontaneous rate = 10.4spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/250 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '60-3'; StimFreq = 250; BeatFreq = 1;
dsIDspon      = '60-3'; SponFreq = 50;
    %spontaneous rate = 1,93spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/500 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '85-3'; StimFreq = 500; BeatFreq = 1;
dsIDspon      = '85-3'; SponFreq = 200;
    %spontaneous rate = 0.266spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/550 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '85-11'; StimFreq = 550; BeatFreq = 1;
dsIDspon      = '85-11'; SponFreq = 1400;
    %spontaneous rate = 0.266spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/150 1000]

%Dataset information
DF            = 'A0242';
dsIDipsi      = '90-5'; StimFreq = 150; BeatFreq = 1;
dsIDspon      = '90-5'; SponFreq = 50;
    %spontaneous rate = 1.06spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat2(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Saving data to disk
save(mfilename, 'Rin', 'Rmon', 'Rbin');
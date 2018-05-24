%Testing timewarping
%Only binaural beat data used
%Subdivision HSR/LSR
%Correction analysis window
    %[100cycles 5000]
    
%After timewarptest.m run figtimewarptest.m

%Resetting vector strength vectors ...
[Rin, Rmon, Rbin] = deal([]);

%Model parameters
P.anwin    = [0 5000];%Analysis window in ms ...
P.ninputs  = 2;       %Number of inputs ...
P.ainputs  = 1;       %Amplitude of the inputs given as a scalar or 
                      %a rowvector with the same length as the number
                      %of inputs ...
P.trefrac  = 0.000;   %Refractory period in ms ...
P.tdecay   = 0.200;   %Decay period of input amplitude in ms ...
P.thr      = 1.25;    %Threshold level ...
P.repmode  = 'pair';  %Handling of repetitions: 'all' or 'pair' ...

%Datasets HSR

P.anwin = [100000/760 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '31-2'; StimFreq = 760; BeatFreq = 1;
dsIDspon      = '31-4'; SponFreq = 999; 
    %spontaneous rate = 74.9spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/590 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '35-3'; StimFreq = 590; BeatFreq = 1;
dsIDspon      = '35-4'; SponFreq = 9999; 
    %spontaneous rate = 68.2spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/690 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '36-2'; StimFreq = 690; BeatFreq = 1;
dsIDspon      = '36-4'; SponFreq = 9999; 
    %spontaneous rate = 55.6spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/690 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '38-2'; StimFreq = 690; BeatFreq = 1;
dsIDspon      = '38-4'; SponFreq = 9999; 
    %spontaneous rate = 44.9spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/1500 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '40-2'; StimFreq = 1500; BeatFreq = 1;
dsIDspon      = '40-4'; SponFreq = 9999; 
    %spontaneous rate = 81spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

P.anwin = [100000/2500 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '40-7'; StimFreq = 2500; BeatFreq = 1;
dsIDspon      = '40-4'; SponFreq = 9999; 
    %spontaneous rate = 74.9spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Datasets LSR

P.anwin = [100000/760 5000]

%Dataset information
DF            = 'A0428';
dsIDipsi      = '39-2'; StimFreq = 760; BeatFreq = 1;
dsIDspon      = '39-4'; SponFreq = 999; 
    %spontaneous rate = 3.99spk/s
dsIpsi   = dataset(DF, dsIDipsi);
dsSpon   = dataset(DF, dsIDspon);

[RinTmp, RmonTmp, RbinTmp] = BinBeat(P, dsIpsi, StimFreq, BeatFreq, dsSpon, SponFreq);
Rin  = [Rin; RinTmp];
Rmon = [Rmon; RmonTmp];
Rbin = [Rbin; RbinTmp];

%Saving data to disk
save(mfilename, 'Rin', 'Rmon', 'Rbin');
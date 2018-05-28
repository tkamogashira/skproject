function BufDBNs = stimgenLINFM(wf, storage);

% STIMGENLINFM -  computes (realizes) LINFM waveform
% SYNTAX:
% function SD = stimgenLINFM(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect stimulus params from different sources
Chan = wf.channel;
sp = wf.stimpar; 
gd = wf.GENdata;
Fsam = sp.samFreq;

% figure out what the instantaneous freq is at each sample
% freq(t) = A*t+B, where t is time from start of *rep*
% 1. up-portion: f(t) = flo+(t-onset)*(fhi-flo)/upDur; onset is delay of channel
A(1) = (sp.Fhigh-sp.Flow)/(sp.upDur+1e-10); % avoid dividing by zero
B(1) = sp.Flow - sp.delay*A(1);
% 2. hold-portion; trivial
A(2) = 0;
B(2) = sp.Fhigh;
% 3. down-portion: f(t) = fhi+(t-onset)*(flo-fhi)/downDur; onset is onset of downramp
downOnset = sp.delay + sp.upDur + sp.holdDur;
A(3) = (-sp.Fhigh+sp.Flow)/(sp.downDur+1e-10); % avoid dividing by zero
B(3) = sp.Fhigh - downOnset*A(3);
% the above constants are in physical units: A in Hz/ms; B in Hz.
% compute time axes in ms of each of the stimulus portions 
Ntotal = gd.Nonset + gd.NsamUp + gd.NsamHold + gd.NsamDown;
Psamms = 1e3/Fsam; % sample period in ms
Tup = Psamms*(gd.Nonset +  (0:gd.NsamUp-1)); % "SC" stands for sample count
Thold = Psamms*(gd.Nonset + gd.NsamUp + (0:gd.NsamHold-1));
Tdown = Psamms*(gd.Nonset + gd.NsamUp + gd.NsamHold + (0:gd.NsamDown-1));
% compute inst frequencies in Hz from the time axes
IFup = A(1)*Tup + B(1);     clear Tup; % save memory
IFhold = A(2)*Thold + B(2); clear Thold;
IFdown = A(3)*Tdown + B(3); clear Tdown;
% starting phase of first up sample. By definition, phase is zero ...
% ... at the onset, but the onset is specified in sub-sample units.
UpStartTimeDev = gd.Nonset/Fsam - 1e-3*sp.delay; % in s 
PhStart = 2*pi*UpStartTimeDev*sp.Flow; % starting phase in radians
% compute the waveform
Samples = [...
      zeros(1,gd.Nonset), ...
      localCalcSweep(PhStart, [IFup IFhold IFdown], Fsam, sp.filterIndex, Chan, gd.critFreq, gd.numAtt)...
   ];

burstDur = sp.upDur+sp.holdDur+sp.downDur;
[Rise, Fall] = gatingrecipes(sp.delay, burstDur, ...
   sp.riseDur, sp.fallDur, Ntotal, 1e6/Fsam);

Samples = ApplyGating(Samples, Rise, Fall);
BufDBNs = storeSamples(Samples, storage);

%figure; plot(real([adaptbuf cycbuf fallbuf])); hold on;
%plot(real(adaptbuf),'r');
%plot(length(adaptbuf)+length(cycbuf)+(1:gd.NsamRamp),real(fallbuf),'r');

%---------------------------------------
function X = localCalcSweep(startPhase, instFreq, Fsam, filterIndex, Chan, limFreq, numAtt);
% computes the samples of a FM sweep.
% calibration amp & phase per sample
%figure;
%plot(instFreq);
%disp('hit <return> to continue');
%pause;
%delete(gcf);
limAm = calibrate(limFreq, filterIndex, Chan);
[Am, Ph] = calibrate(instFreq, filterIndex, Chan);
Am = maxMagDA*db2a(min(Am-limAm, 0)- numAtt); % limAm is hard ceiling
twoPiDeltaT = 2*pi/Fsam; % conversion factor Hz -> (rad/sample)
InstPhase = startPhase + twoPiDeltaT*cumsum(instFreq) + 2*pi*Ph; % Ph is in cycles
clear instFreq Ph
X = Am.*sin(InstPhase);


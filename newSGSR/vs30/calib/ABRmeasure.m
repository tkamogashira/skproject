function YY = ABRmeasure(DAchan, varargin);
% ABRmeasure - perform ABR measurement
%   ABRmeasure(Chan)  Chan=0,1,2 = Left,Right,Both

global SGSR

% parameters 
PP.stimType = 'tone'; % tone/click
PP.frequency = 1000*[0.25 0.5 1 2 4 8]; % Hz tone freq
PP.toneDur = 10; % ms duration of tones
PP.clickDur = 0.1; % ms duration of clicks
PP.doAlternate = 1; % 0/1 alternate polarity
PP.rampDur = 1.5; % ms ramp duration
PP.preDur = 10; % ms recording before tone
PP.postDur = 10; % ms recording before tone
PP.Nrep = 256; % # reps per tone
PP.SPL = 70; % dB SPL ball park level
PP.doPlot = 0; % yes/no debug plot
defFN = fieldnames(PP); % for check of varargin

if isequal('params', DAchan), % return default parameters
   YY = PP;
   return;
end
if nargin>1,
   PP = combineStruct(PP, struct(varargin{:}));
   if ~isequal(defFN, fieldnames(PP)),
      error('Invalid parameter specified; Type "ABRmeasure params" to view params.');
   end
end
YY.params = PP;

% derived params
Nrep = 2*ceil(PP.Nrep/2); % need even # reps to balance alternating polarity
switch lower(PP.stimType),
case 'tone',
   freq = PP.frequency;
   Nfreq = length(freq);
   maxFreq = max(freq);
   stimDur = PP.toneDur;
case 'click',
   Nfreq = 1;
   freq = inf;
   maxFreq = maxStimFreq;
   stimDur = PP.clickDur;
end
Nlevel = length(PP.SPL);
if (Nfreq>1)&(Nlevel>1),
   error('Frequency and SPL cannot both be vectors.');
end
[samfreq, ifilt] = safeSampleFreq(maxFreq);
Nsam = ceil(samfreq*stimDur*1e-3);
NrampSam = round(samfreq*PP.rampDur*1e-3);
NpreSam = round(samfreq*PP.preDur*1e-3);
NpostSam = round(samfreq*PP.postDur*1e-3);
NsamTot = Nsam + NpreSam + NpostSam;

% prepare & generate stim waveform
RiseWin = sin(linspace(0,pi/2,NrampSam)).^2; % rise window
irise = 1:NrampSam;
FallWin = flipLR(RiseWin); % fall window
ifall = (Nsam-NrampSam+1:Nsam);
% plot(irise, RiseWin); xplot(ifall, FallWin,'r');

% prepare plotting
hh = subPlotDivide(figure, -Nfreq*Nlevel, 'time (ms)', [0 1e3/samfreq*NsamTot]-PP.preDur, 'ABR (A.U.)');
if atBigScreen, set(gcf,'position', [113   187   674   493]); end;

iplot = 0;
for ifreq=1:Nfreq,
   for ilevel=1:Nlevel,
      iplot = iplot+1;
      axes(hh(iplot)); set(gca,'nextplot', 'add');
      curSPL = PP.SPL(ilevel);
      Atten = SGSR.defaultMaxSPL - curSPL; % attenuation re max level
      AnaAtten = min(Atten, MaxAnalogAtten); % analog part of attenuation
      NumAtten = Atten - AnaAtten; % numerical part of attenuation
      linAmp = maxMagDa*db2a(-NumAtten); % linear amplitude of tone buffer
      curFreq = freq(ifreq); % current freq 
      title([num2sstr(curFreq) ' Hz  ' num2sstr(curSPL) ' dB' ]);
      if isinf(curFreq), % click
         WF = linAmp*ones(1,Nsam);
      else % tone
         % compute current angular freq in radians per sample
         radPerSam = 2*pi*curFreq/samfreq; 
         WF = linAmp*sin(radPerSam*(1:Nsam));
         % gating
         WF(irise) = WF(irise).*RiseWin;
         WF(ifall) = WF(ifall).*FallWin;
      end
      % add surrounding silence
      WF = [zeros(1,NpreSam) WF zeros(1,NpostSam)];
      RS_DC = 0; RS_AC = 0;
      RepeatCalibPlayRecSys2('prepare', WF, DAchan, ifilt, AnaAtten,1); % pos
      RepeatCalibPlayRecSys2('prepare', -WF, DAchan, ifilt, AnaAtten,2); % neg
      ifreq
      for irep = 1:Nrep,
         pola = 2-rem(irep,2); % 1=+, 2=-
         if ~PP.doAlternate, pola = 1; end;
         [recSig, ANOM] = RepeatCalibPlayRecSys2('playrec', pola);
         Sign = 3-2*pola; % 1=+, -1=-
         RS_DC = RS_DC + recSig;
         RS_AC = RS_AC + Sign*recSig;
      end
      dplot([1e3/samfreq -PP.preDur], RS_DC/Nrep);
      dplot([1e3/samfreq -PP.preDur], RS_AC/Nrep, 'r');
      RepeatCalibPlayRecSys2('cleanup');
      YY.Response_DC(ifreq,:) = RS_DC;
      YY.Response_AC(ifreq,:) = RS_AC;
   end
end;

%-----------locals---------------------------
function localGenStim(PP)









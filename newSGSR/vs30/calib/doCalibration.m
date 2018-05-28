function CD = doCalibration(CS, CalType, DAchan, DefaultStartAtt, micSens, micGain, ...
   maxSPL, PRL, SNhandle);
Fsmooth = 50; % Hz range for runav of levels

if nargin<7, maxSPL = NaN; end; % no SPL limit during calibration
if nargin<8, PRL = []; end; % no PRL compensation for monitoring the SPL
if nargin<9, SNhandle = []; end; % handle for reporting S/N ratio
CD = []; % default value in case of user interrupt
DAchan = channelNum(DAchan);

% CS = calibStim;
DF = CS.bands.DF; % freq spacing of components
minAtt = 0;
minSNratio = 30; % dB minimum S/N ratio or warning

global SGSR CALIBstatus
CALIBstatus.interrupt = 0;

EffMicSens = micSens*db2a(micGain); % effective (mic+Amp) sensitivity in mV/Pa
ADCbitPerPa = 1e-3*EffMicSens/SGSR.ADC_VoltPerBit; % mV/Pa -> ADCbit/Pa
MaxStd = inf; % no upper limit yet, see below
if ~isnan(maxSPL),% convert maximum SPL into max bit RMS at ADC while using PRL transfer
   if ~isempty(PRL), % check compatibility of freq ranges
      if ~CDcompareFilterSettings(PRL, CS),
         localFilterSettingError; 
         return;
      end
   end
   MaxPressure = 20e-6*db2a(maxSPL); % max pressure RMS in Pa - not yet PRL-compensated!!
   MaxStd = MaxPressure*ADCbitPerPa; % convert to ADC bit units
end
% MaxStd = min(MaxStd, maxMagDA/8); % never exceed hardware limit to ADC Voltage

cleanAP2;

% measure background noise
UIinfo('Estimating background noise'); drawnow;
silDur = 1000; % ms
[BGstd, SNratio, fcenter, BGspec] ...
   = localBackground(silDur, DAchan, ADCbitPerPa, minSNratio, SNhandle);

NoiseBackground = CollectInStruct(fcenter, BGspec, SNratio, minSNratio);
% N = length(fcenter);
% fcenter(find(rem(1:N,3)))=NaN;
% f2; labbar(round(fcenter), BGspec);

[Nband, Nfilt] = size(CS.bands.Ncomp);
TRF = cell(Nfilt,1);
Att = 400+zeros(Nband, Nfilt);
MeasStd = nan+zeros(Nband, Nfilt);
MeasSPL = nan+zeros(Nband, Nfilt);
PRLfactor = nan+zeros(Nband, Nfilt);
Ncompare  = 3; % # previous bands with which to compare the attenuator levels
NstartCompare = Ncompare + CS.params.Nlowest; % start comparing after the lowest bands only
for iband=1:Nband,
   for ifilt=1:Nfilt,
      if CALIBstatus.interrupt, 
         UIerror('User interrupt'); 
         return; 
      end;
      SS1switching(DAchan, ifilt);
      [wf cl iwf Flow Fhigh] = ExtractCalStim(CS, iband, ifilt);
      if (iband >= NstartCompare),
         startAtt = min(DefaultStartAtt, max(Att(iband-(1:Ncompare),ifilt))-3);
      else, startAtt = DefaultStartAtt;
      end
      if ~isempty(wf),
         mess = ['band ' num2str(iband) ': ' num2str(round(Flow)) '..' num2str(round(Fhigh)) ' Hz'];
         UIinfo(mess);
         if ~isempty(PRL), % get probe-loss factor of freq range at hand
            prlfac = rms(CDinterpol(PRL, ifilt, Flow:10:Fhigh)); % 10-Hz spacing for integrating
         else, prlfac = 1; % trivial factor
         end
         effMaxStd = MaxStd/prlfac; % PRL correction affects limit to recorded ADC std
         effMaxStd = min(effMaxStd, maxMagDA/8); % never exceed hardware limit to ADC Voltage
         % quick & dirty fix of drifting problems during ERC calibration
         if ~isempty(PRL), % i.e., an ERC measurement
            if Flow>0e3, minAtt=30; effMaxStd = inf; end;
            if Flow>35e3, minAtt=20; effMaxStd = inf; end;
            if Flow>40e3, minAtt=10; effMaxStd = inf; end;
         end
         [recSig, measStd, allAtt{iband,ifilt}, Anom] = ...
            MeasureDAADtrf(wf, DAchan, ifilt, startAtt, minAtt, BGstd, effMaxStd);
         curAtt = allAtt{iband,ifilt}(end);
         if DefaultStartAtt<curAtt-5, % default start atten is clearly too low
            DefaultStartAtt = curAtt - 5; % incease it to a safer value
         end
          % bookkeeping
         BKeffMaxStd(iband,ifilt) = effMaxStd;
         PRLfactor(iband,ifilt) = prlfac;
         Att(iband,ifilt) = curAtt;
         MeasStd(iband,ifilt) = measStd;
         MeasSPL(iband,ifilt) = 94+a2db(prlfac*measStd/ADCbitPerPa); % 1 Pa ~ 94 dB SPL; apply PRL compensation
         mspec = fft((db2a(curAtt)/ADCbitPerPa)*recSig).'; % in Pa with attenuator open
         trf = mspec(cl(1):cl(2))./CS.WavePool(iwf).Spec; % in Pa/DACbit
         TRF{ifilt}((cl(1):cl(2))) = trf;
      end
   end
end
% smooth and, if ERC measurement, apply PRL correction
for ifilt=1:Nfilt,
   % smooth levels in dB domain, angles in complex plane
   Nav = ceil(Fsmooth/DF(ifilt)); % # components for running average
   nz = find(0~=TRF{ifilt});
   RR = log(abs(TRF{ifilt}(nz)));
   AA = exp(i*angle(TRF{ifilt}(nz)));
   TRF{ifilt}(nz)  = TRF{ifilt}(nz) .* exp(runav(RR,Nav)-RR).*exp(i*angle(runav(AA,Nav)))./AA;
   if ~isempty(PRL), % apply PRL correction
      freq = DF(ifilt)*(0:length(TRF{ifilt})-1); % component freqs in Hz
      TRF{ifilt}  = TRF{ifilt}.*CDinterpol(PRL,ifilt,freq); % component-wise correction
   end
end

effMaxStd = BKeffMaxStd;
PRLname = getfieldordef(PRL, 'filename', '');
ADC = CollectInStruct(micSens, micGain, ADCbitPerPa, MeasStd, maxSPL, MaxStd, PRLfactor, effMaxStd, PRLname);
Attenuator = CollectInStruct(Att, DefaultStartAtt, minAtt, allAtt);
Freq = CS.bands; % frequency info of calibration noise bands
calibParams = CS.params;
CD = CollectInStruct(CalType, DAchan, TRF, Freq, calibParams, ADC, ...
   Attenuator, MeasSPL, NoiseBackground);
if ~isempty(PRL), % store name of PRL file used
   CD.PRL = PRL.filename;
end
UIinfo('Transfer function measured'); 

%------------------------------------------
function [stdBG, SNratio, fcenter, BGspec] ...
   = localBackground(dur, chan, ADCbitPerPa, minSN, SNhandle);
global SGSR
Nfilt = length(SGSR.samFreqs);
Fsam = SGSR.samFreqs(Nfilt); % sample rate in Hz
Nsam = ceil(Fsam*dur*1e-3); % ms-># samples
Nsam = 2^nextpow2(Nsam); % upward rounding for faster fft
DF = Fsam/Nsam; % freq spacing in Hz
SS1switching(chan, 1, Nfilt);
[BG ,anom] = CalibPlayRecSys2(zeros(Nsam,1), chan, 1, MaxAnalogAtten);
stdBG = 1e-8+std(BG);
SNratio = a2db(maxmagDA/stdBG)-3;
if SNratio<minSN, % dB signal/noise ratio
   beeps(3);
   wh = warndlg(strvcat('The background noise level is quite high',...
      ['(S/N ratio < ' num2str(minSN) ' dB).'],...
      'This might result in poor calibration data. ',...
      'Try one of the following:',...
      '   - lower the gain of the microphone amp',...
      '   - highpass filter the microphone signal',...
      '   - reduce any rumble'...
      ),'Background noise','modal');
   uiwait(wh);
end
BGspec = abs(fft(BG/ADCbitPerPa/20e-6)/Nsam).^2; % power spec Re 20uPa
BGspec = 2*BGspec(1:Nsam/2); % positive freq only
BGspec(1) = 0; % eliminate DC component
BGspec = cumsum(BGspec); % cumulative spectrum
fsep = 8e3*2.^(1/6+(-40:20)/3); % corner freqs os 1/3 octave bands
isep = 1+round(fsep/DF); % corresponding indices in spectrum
OKindex = find((diff(isep)>5/DF)&(isep(1:end-1)<Nsam/2)); % valid indices of isep
BGspec = BGspec(isep(OKindex)); % cumulative power spec at corner freqs
BGspec = p2db(diff(BGspec)); % power per 1/3-oct band in dB SPL
fcenter = fsep(OKindex)*2^(-1/6); % center freqs of 1/3 octave bands
fcenter = fcenter(2:end);
% try to report S/N ratio
try,
   mess = ['Background S/N ratio: ' num2str(round(SNratio)) ' dB'];
   if ~isempty(SNhandle), setstring(SNhandle, mess); drawnow;
   else, disp(mess);
   end
% catch, lasterr
end


function localFilterSettingError;
mess = strvcat('Specified PRL data were measured with sample-rate settings', ...
   'that are different from current settings.',...
   'A different or new PRL transfer function is needed.');
eh = errordlg(mess, 'Incompatible PRL data', 'modal');
uiwait(eh);





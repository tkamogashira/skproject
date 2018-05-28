function [Y, Stim] = StimDefinitionFS(keyword, varargin);
% StimDefinitionFS - stimulus definition for FS stimulus
%   S = StimDefinitionFS('factoryParamset', CT) returns the default 
%   paramset object for FS stimuli, based on stimulus context CT. 
%   S includes the definition of the OUI.
%
%   [DS, ST] = StimDefinitionFS('check', S, CT, DoCompute) checks if paramset 
%   S is "valid", i.e., if the stimulus defined by the values in S is 
%   realizable, given stimulus context CT. If S is valid, StimDefinitionFS 
%   returns a  dataset object DS which holds the definition of the stimulus.
%   If a problem occurs with the definitions, it is reported using OUIerror
%   and void dataset is returned. 
%   If DoCompute, StimDefinitionFS also computes the stimulus ST. If all 
%   parameters are valid then ST is a stimulus object containing the samples 
%   of the FS stimulus. If something went wrong both DS and ST are void.
%
%   See also StimOUI, StimulusContext, StimulusDashboard, OUIerror.

switch lower(keyword)
case 'factoryparamset', % S = StimDefinitionFS('factoryParamset', CT)
   CT = varargin{1};
   Y = localParamset(CT);
   return
case 'check', % DS = StimDefinitionFS('check', S, CT, DoCompute); 
   [S, CT, DoCompute] = deal(varargin{1:3}); % paramset, stimulus context & DoCompute, resp
   % check parameters and create a dataset
   Y = localDataset(S, CT); % void dataset is returned if something went wrong
   [Stim, OK] = localEvaluateStim(Y, DoCompute); % void Stim is returned if isvoid(Y) or ~DoCompute.
   if ~OK, Y = dataset; end; % return void dataset to indicate something went wrong
otherwise, error(['Invalid keyword ''' keyword '''.']);
end

%===========locals===========================
function FS = localParamset(CT);
% return the factory value of the paramset that defines the stimulus
%-------everything is generic; this is the Ur stimulus paramset --------------
FS = paramset('Stimulus', 'FS', 'Frequency sweep', 1, [430 40], mfilename);
FS = GenericParamSubset(FS, 'frequency', [10 10], CT, 'carrier');
FS = GenericParamSubset(FS, 'modulation', [10 95], CT);
FS = GenericParamSubset(FS, 'spl', [170 10], CT);
FS = GenericParamSubset(FS, 'durations', [170 75], CT);
FS = GenericParamSubset(FS, 'presentation', [300 75], CT);

function DS = localDataset(S, CT);
% initialize "empty" dataset based on stimulus params and context.
% - check validity of parameters
DS = dataset; % pessimistic default: void dataset
Freq = OUIfrequencySweep(S, CT); % convert sweep params -> values per condition; errors are reported
if isvoid(Freq), return; % 
elseif ~OUIcheckDurations(S), return; % standard checking of durations (burstdur<=repdur, etc)
end
OUIdepvarInfo(Freq, 0.1, 'carrier'); % report # conditions
% create dataset that holds the stimulus parameters and more
Specials.CarFreq = Freq.in_Hz;
if isequal('octave', S.stepType), PlotScale='log'; else PlotScale='lin'; end;
DS = InitDataset(S, CT, Freq, {'Carrier Frequency' 'Fcar' PlotScale}, Specials);

function [FS, OK] = localEvaluateStim(DS, DoCompute);
% here's the real work: determine waveform parameters such as 
% buffer sizes, amplitudes, attnuator settings, etc,
% and compute the waveforms themselves, if requested.
[FS, OK] = deal(stimulus, 0); % pessimistic defaults void stimulus object & not okay, resp
if isvoid(DS), return; end; % localDataset already found errors - don't waste time
if DoCompute, FS = stimulus('FS', mfilename); end; % initialize stimulus
% extract stimulus parameters to local numerical variables; if needed extend them to dual-channel values
pset = DS.paramSet;
[fcar, fmod, dmod] = stereoVar(pset.carFreq.in_Hz, pset.modFreq.in_Hz, pset.modDepth.as_1);
fmod = fmod.*double(dmod~=0); % set fmod to zero when dmod==0 (channelwise!)
[burstdur, risedur, falldur, delay] = stereoVar(pset.burstdur.in_ms, pset.risedur.in_ms, pset.falldur.in_ms, pset.delay.in_ms);
SPL = stereoVar(pset.spl.in_dB_SPL);
% derived stimulus parameters
[Fsam, iFilt] = safesampleFreq(max(fcar,[],2)+max(fmod)); % sample freq in Hz
Ncond = size(fcar,1);
iwav = zeros(Ncond,2); % initialize set of waveform indexes (zeros->inactive channels)
maxSPL = repmat(inf,Ncond,2); % initialize maximum SPL values per condition & channel
AnaAtten = nan+maxSPL; % initialize attenuator settings; nans produce errors when inactive DA channels are mistakenly activated
for ichan = allChanNums(pset.activeDA),
   durs = [delay(ichan)+risedur(ichan), burstdur(ichan)-risedur(ichan)-falldur(ichan), falldur(ichan)+delay(3-ichan)];
   durs = [durs pset.RepDur.in_ms-sum(durs)]; % add silent ISI
   steadyDur = durs(2);
   if isequal(0, dmod(ichan)), fm = 0; else, fm = fmod(ichan); end; % zero-mod depth -> set fm=0
   for icond = 1:Ncond,
      fsam = Fsam(icond); ifilt = iFilt(icond);
      [Npre Nsteady Npost Nrepsil] = NsamplesOfChain(durs, 1e6./fsam);
      TS = toneStorage(fcar(icond, ichan), fm, fsam, Nsteady);
      % SAM tones are tone complexes; compute amps, freqs, phases of the three components
      fc = TS.fcar_rounded; fm = TS.fmod_rounded;  % carrier freq & mod freq 
      freqs = [fc-fm fc fc+fm]; % carrier & sidebands
      amps = [0 1 0] + 0.5*dmod(ichan)*[1 0 1]; % mod depth -> relative amplitudes of carrier and sidebands
      phases = [0.5 0 0.5]; % modulation starts at minimum
      [amps, phases, maxspl] = toneComplexCalib(amps, phases, {freqs, ifilt, ichan}, maxMagDA, [0 1 0]); % last arg: only carrier counts in level definition
      maxSPL(icond, ichan) = maxspl; % store for OUI message
      [AnaAtten(icond, ichan), NumAtten, levelOK] = LevelAdjustment(SPL(ichan), maxspl, maxanalogAtten, 10);  % this also reports max SPL to OUI and any error
      if ~levelOK, DoCompute=0; end
      if DoCompute, % compute waveform; put the tone waveforms in 4 segments: preOnset+rise, cyclic, rem, fall+postOffset
         Ntot = Npre+Nsteady+Npost;
         amps = amps*db2a(-NumAtten); % apply numerical attenuation
         SamCounts = [Npre, TS.NsamCycBuf, TS.NsamInRemBuf, Npost];
         [Pre, Cyc, Rem, Post] = ToneComplex(freqs, amps, phases, fsam, SamCounts, delay(ichan), risedur(ichan));
         % impose ramps with sub-sample accuracy
         [Rise Fall]=gatingrecipes(delay(ichan), burstdur(ichan), risedur(ichan), falldur(ichan), [1 Ntot], 1e6/fsam);
         [Pre Post] = simpleGate(Pre, Post, Rise, Fall);
         % store chunks in stimulus; append silence to fill up repDur
         [FS ich] = addChunk(FS, Pre, Cyc, Rem, Post);
         [FS, iwav(icond,ichan)] = defineWaveform(FS, [ich -Nrepsil], [1 TS.NrepCycBuf 1 1 0], ichan, ifilt, fsam);
      end % if DoCompute
   end % cond loop
end % channel loop
% max SPL report; 0 returned if level(s) too high -> OK = 0 when exiting 
if ~LevelReport(maxSPL, SPL, pset.activeDA, pset.carFreq), return; end; 
if DoCompute,
   for icond = 1:Ncond,
      FS = defineDAshot(FS, iwav(icond,:), AnaAtten(icond,:));
   end
end
OK = 1;









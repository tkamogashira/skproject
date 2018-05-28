function P = toneStimSK(P, varargin); 
% toneStim - compute tone stimulus
%   P = toneStim(P) computes the waveforms of tonal stimulus
%   The carrier frequencies are given by P.Fcar [Hz], which is a column 
%   vector (mono) or Nx2 vector (stereo). The remaining parameters are
%   taken from the parameter struct P returned by GUIval. The Experiment
%   field of P specifies the calibration, available sample rates etc
%   In addition to Experiment, the following fields of P are used to
%   compute the waveforms
%           Fcar: carrier frequency in Hz
%      WavePhase: starting phase (cycles) of carrier (0 means cos phase)
%    FreqTolMode: tolerance mode for freq rounding; equals exact|economic.
%        ModFreq: modulation frequency in Hz
%       ModDepth: modulation depth in %
%       ModStartPhase: modulation starting phase in cycles (0=cosine)
%       ModTheta: modulation angle in Cycle (0=AM, 0.25=QFM, other=mixed)
%            ISI: onset-to-onset inter-stimulus interval in ms
%     OnsetDelay: silent interval (ms) preceding onset (common to both DACs)
%       BurstDur: burst duration in ms including ramps
%        RiseDur: duration of onset ramp
%        FallDur: duration of offset ramp
%        FineITD: ITD imposed on fine structure in ms
%        GateITD: ITD imposed on gating in ms
%         ModITD: ITD imposed on modulation in ms
%            DAC: left|right|both active DAC channel(s)
%            SPL: carrier sound pressure level [dB SPL]
%
%   Most of these parameters may be a scalar or a [1 2] array, or 
%   a [Ncond x 1] or [Ncond x 2] or array, where Ncond is the number of 
%   stimulus conditions. The allowed number of columns (1 or 2) depends on
%   the character of the paremeter, i.e., whether it may have separate
%   values for the left and right DA channel. The exceptions are 
%   FineITD, GateITD, ModITD, and ISI, which which are allowed to have
%   only one column, and SPLtype and FreqTolMode, which are a single char 
%   strings that apply to all of the conditions.
%   
%   The output of toneStim is realized by updating/creating the following 
%   fields of P
%         Fsam: sample rate [Hz] of all waveforms.
%         Fcar: adjusted to slightly rounded values to save memory using cyclic
%               storage (see CyclicStorage).
%         Fmod: modulation frequencies [Hz] in Ncond x Nchan matrix or column 
%               array. Might deviate slightly from user-specified values to
%               facilitate storage (see CyclicStorage).
%   CyclicStorage: the Ncond x Nchan struct with outputs of CyclicStorage
%     Duration: stimulus duration [ms] in Ncond x Nchan array. 
%    FineDelay: fine-structure-ITD realizing delays (columns denote Left,Right) 
%    GateDelay: gating-ITD realizing delays (columns denote Left,Right) 
%     ModDelay: modulation-ITD realizing delays (columns denote Left,Right) 
%     Waveform: Ncond x Nchan Waveform object containing the samples and 
%               additional info for D/A conversion.
%     GenericParamsCall: cell array for getting generic stimulus
%               parameters. Its value is 
%                   {@noiseStim struct([]) 'GenericStimParams'}
%               After substituting the updated stimulus struct for
%               struct([]), feval-ing this cell array will yield the 
%               generic stimulus parameters for noiseStim stimuli. 
%
%   For the realization of ITDs in terms of channelwise delays, see
%   ITD2delay.
%
%   toneStim(P, 'GenericStimParams') returns the generic stimulus
%   parameters for this class of tonal stimuli. This call is done via
%   GenericStimParams, based on the GenericParamsCall field described above.
%
%   See also makestimFS, SAMpanel, DurPanel, dePrefix, Waveform,
%   noiseStim, ITD2delay. 

if nargin>1 
    if isequal('GenericStimParams', varargin{1}),
        P = local_genericstimparams(P);
        return;
    else,
        error('Invalid second input argument.');
    end
end
S = [];
% test the channel restrictions described in the help text
error(local_test_singlechan(P,{'FineITD', 'GateITD', 'ModITD', 'ISI'}));
% There are Ncond=size(Fcar,1) conditions and Nch DA channels.
% Cast all numerical params in Ncond x Nch size, so we don't have to check
% sizes all the time.
[Fcar, ModFreq, ModDepth, ModStartPhase, ModTheta, ...
    OnsetDelay, BurstDur, RiseDur, FallDur, ISI, WavePhase, ...
    FineITD, GateITD, ModITD, SPL] ...
    = sameSize(P.Fcar, P.ModFreq, P.ModDepth, P.ModStartPhase, P.ModTheta, ...
    P.OnsetDelay, P.BurstDur, P.RiseDur, P.FallDur, P.ISI, P.WavePhase, ...
    P.FineITD, P.GateITD, P.ModITD, P.SPL);
ModFreq = ModFreq.*(ModDepth~=0); % set ModFreq to zero if ModDepth vanishes ...
ModDepth = ModDepth.*(ModFreq~=0); % ... and vice versa
% sign convention of ITD is specified by Experiment. Convert ITD to a nonnegative per-channel delay spec 
FineDelay = ITD2delay(FineITD(:,1), P.Experiment); % fine-structure binaural delay
GateDelay = ITD2delay(GateITD(:,1), P.Experiment); % gating binaural delay
ModDelay = ITD2delay(ModITD(:,1), P.Experiment); % modulation binaural delay
% Restrict the parameters to the active channels. If only one DA channel is
% active, DAchanStr indicates which one.
[DAchanStr, Fcar, ModFreq, ModDepth, ModStartPhase, ModTheta, ...
    OnsetDelay, BurstDur, RiseDur, FallDur, ISI, WavePhase, ... 
    FineDelay, GateDelay, ModDelay, SPL] ...
    = channelSelect(P.DAC, 'LR', Fcar, ModFreq, ModDepth, ModStartPhase, ModTheta, ...
    OnsetDelay, BurstDur, RiseDur, FallDur, ISI, WavePhase, ...
    FineDelay, GateDelay, ModDelay, SPL);
% find the single sample rate to realize all the waveforms while  ....
%Fsam = sampleRate(Fcar+ModFreq, P.Experiment); % accounting for recording requirements minADCrate
Fsam = sampleRateSK(Fcar+ModFreq, P.Experiment);%Shotaro

% tolerances for memory-saving frequency roundings. 
[CarTol, ModTol] = FreqTolerance(Fcar, ModFreq, P.FreqTolMode);
% compute # samples needed to store the waveforms w/o cyclic storage tricks
NsamTotLiteral = round(1e-3*sum(BurstDur)*Fsam);
[dum, NsamTotLiteral] = samesize(Fcar, NsamTotLiteral);
% now compute the stimulus waveforms condition by condition, ear by ear.
[Ncond, Nchan] = size(Fcar);
[P.Fcar, P.Fmod] = deal(zeros(Ncond, Nchan));
for ichan=1:Nchan,
    chanStr = DAchanStr(ichan); % L|R
    for icond=1:Ncond,
        % select the current element from the param matrices. All params ...
        % are stored in a (iNcond x Nchan) matrix. Use a single index idx 
        % to avoid the cumbersome A(icond,ichan).
        idx = icond + (ichan-1)*Ncond;
        % evaluate cyclic storage to save samples
        C = CyclicStorage(Fcar(idx), ModFreq(idx), Fsam, BurstDur(idx), [CarTol(idx), ModTol(idx)], NsamTotLiteral(ichan));
        % compute the waveform
        [w, fcar, fmod] = local_Waveform(chanStr, P.Experiment, Fsam, ISI(idx), ...
            FineDelay(idx), GateDelay(idx), ModDelay(idx), OnsetDelay(idx), RiseDur(idx), FallDur(idx), ...
            C, WavePhase(idx), ModDepth(idx), ModStartPhase(idx), ModTheta(idx), SPL(idx));
        P.Waveform(icond,ichan) = w;
        % derived stim params
        P.Fcar(icond,ichan) = fcar;
        P.Fmod(icond,ichan) = fmod;
        P.CyclicStorage(icond,ichan) = C;
    end
end
P.Duration = samesize(P.BurstDur, zeros(Ncond,Nchan)); 
P = structJoin(P, collectInStruct(FineDelay, GateDelay, ModDelay, Fsam));
P.GenericParamsCall = {fhandle(mfilename) struct([]) 'GenericStimParams'};


%===================================================
%===================================================
function  [W, Fcar, Fmod] = local_Waveform(DAchan, EXP, Fsam, ISI, ...
    FineDelay, GateDelay, ModDelay, OnsetDelay, RiseDur, FallDur, ...
    C, WavePhase, ModDepth, ModStartPhase, ModTheta, SPL);
% Generate the waveform from the elementary parameters
%=======TIMING, DURATIONS & SAMPLE COUNTS=======
BurstDur = C.Dur;
% get sample counts of subsequent segments
SteadyDur = BurstDur-RiseDur-FallDur; % steady (non-windowd) part of tone
[NonsetDelay, NgateDelay, Nrise, Nsteady, Nfall] = ...
    NsamplesofChain([OnsetDelay, GateDelay, RiseDur, SteadyDur, FallDur], Fsam/1e3);
% For uniformity, cast literal storage in the form of a fake cyclic storage
useCyclicStorage = C.CyclesDoHelp && (Nsteady>=C.Nsam);
if useCyclicStorage, % cyclic storage
    NsamCyc = C.Nsam;  % # samples in cyclic buffer
    NrepCyc = floor(Nsteady/NsamCyc); % # reps of cyclic buffer
    NsamTail = rem(Nsteady,NsamCyc); % Tail containing remainder of cycles
    Fcar = C.FcarProx; Fmod = C.FmodProx; % actual frequencies used in waveforms
else, % literal storage: phrase as single rep of cyclic buffer + empty tail buffer
    NsamCyc = Nsteady;  % total # samples in steady-state portion
    NrepCyc = 1; % # reps of cyclic buffer
    NsamTail = 0; % No tail buffer
    Fcar = C.Fcar; Fmod = C.Fmod; % actual frequencies used in waveforms
end
%=======FREQUENCIES, PHASES, AMPLITUDES and CALIBRATION=======
isModulated = ~isequal(0,ModDepth) && ~isequal(0,Fmod);
% SAM is implemented as 3-tone stim. Get the tone freqs.
if isModulated, freq = Fcar+[-1 0 1]*Fmod; % [Hz] lower sideband, carrier, upper sideband
else, freq = Fcar; % [Hz] only carrier
end
%%%[calibDL, calibDphi] = calibrate(EXP, Fsam, DAchan, freq);Shotaro
% waveform is generated @ the target SPL. Scaling is divided
% between numerical scaling and analog attenuation later on.
%%%Amp = dB2a(SPL)*sqrt(2)*dB2A(calibDL); % numerical linear amplitudes of the carrier ...
Amp = dB2a(SPL)*sqrt(2);%Shotaro
if isModulated, Amp = Amp.*[ModDepth/200 1 ModDepth/200]; end %.. and sidebands if any
% Compute phase of numerical waveform at start of onset, i.e., first sample of rising portion of waveform.
%%%StartPhase = WavePhase + calibDphi - 1e-3*FineDelay.*freq; % fine structure delay is realized in freq domain
StartPhase = WavePhase  - 1e-3*FineDelay.*freq;%Shotaro
if isModulated, % implement modulation phase by adjusting sideband phases
    % (1) Start phases [cycle] of the 3 tones at onset, excluding any ongoing delay
    StartPhase = StartPhase + [-1 0 1]*ModStartPhase; % 0/0.5 -> start at max/min envelope.
    % (2) Theta determines modulation type: 0=SAM; 0.25 = QFM; other values
    % produce mixed modulation (see vd Heijden & Joris, JARO 2010)
    StartPhase = StartPhase + [1 0 1]*ModTheta;
    % (3) whole waveform was already delayed a few lines above (using FineDelay). If the
    % requested modulation delay is different from the fine structure delay, we must
    % compensate for this.
    StartPhase = StartPhase - 1e-3*(ModDelay-FineDelay).*(freq-freq(2));
end

dt = 1e3/Fsam; % sample period in ms
% compute dur of stored tone, whether useCyclicStorage or not
StoreDur = dt*(NgateDelay + Nrise + (NsamCyc + NsamTail) + Nfall); % only a single cycled buf is used
wtone = toneComplex(Amp, freq, StartPhase, Fsam, StoreDur); % ungated waveform buffer; starting just after OnsetDelay
if logical(EXP.StoreComplexWaveforms); % if true, store complex analytic waveforms, real part otherwise
    wtone = wtone+ i*toneComplex(Amp, freq, StartPhase+0.25, Fsam, StoreDur);
end
wtone = exactGate(wtone, Fsam, StoreDur-GateDelay, GateDelay, RiseDur, FallDur);
%set(gcf,'units', 'normalized', 'position', [0.519 0.189 0.438 0.41]); %xdplot(dt,wtone, 'color', rand(1,3)); error kjhkjh

% parameters stored w waveform. Mainly for debugging purposes.
NsamHead = NgateDelay + Nrise; % # samples in any gating delay + risetime portion
Nsam = collectInStruct(NonsetDelay, NgateDelay, Nrise, Nsteady, Nfall, NsamHead);
Durs = collectInStruct(BurstDur, RiseDur, FallDur, OnsetDelay, GateDelay, SteadyDur, FallDur);
Delays = collectInStruct(FineDelay, GateDelay, ModDelay, OnsetDelay);
Param = CollectInStruct(C, Nsam, Durs, Delays, freq, Amp, StartPhase, SPL, useCyclicStorage);
% Patch together the segments of the tone, using the cycled storage format,
% or the fake version of it.
W = Waveform(Fsam, DAchan, NaN, SPL, Param, ...
    {0              wtone(1:NsamHead)  wtone(NsamHead+(1:NsamCyc))   wtone(NsamHead+NsamCyc+1:end)},...
    [NonsetDelay    1                  NrepCyc                       1]);
%    ^onset delay   ^gate_delay+rise   ^cyclic part                  ^remainder steady+fall  
W = AppendSilence(W, ISI); % pas zeros to ensure correct ISI

function Mess = local_test_singlechan(P, FNS);
% test whether specified fields of P have single chan values
Mess = '';
for ii=1:numel(FNS),
    fn = FNS{ii};
    if size(P.(fn),2)~=1,
        Mess = ['The ''' fn ''' field of P struct must have a single column.'];
        return;
    end
end

function P = local_genericstimparams(S);
% extracting generic stimulus parameters. Note: this only works after
% SortCondition has been used to add a Presentation field to the
% stimulus-defining struct S.
Ncond = S.Presentation.Ncond;
dt = 1e3/S.Fsam; % sample period in ms
Nx1 = zeros(Ncond,1); % dummy for resizing
Nx2 = zeros(Ncond,2); % dummy for resizing
%
ID.StimType = S.StimType;
ID.Ncond = Ncond;
ID.Nrep  = S.Presentation.Nrep;
ID.Ntone = 1;
% ======timing======
T.PreBaselineDur = channelSelect('L', S.Baseline);
T.PostBaselineDur = channelSelect('R', S.Baseline);
T.ISI = samesize(S.ISI, Nx1);
T.BurstDur = samesize(channelSelect('B', S.Duration), Nx2);
T.OnsetDelay = samesize(dt*floor(S.OnsetDelay/dt), Nx1); % always integer # samples
T.RiseDur = samesize(channelSelect('B', S.RiseDur), Nx2);
T.FallDur = samesize(channelSelect('B', S.FallDur), Nx2);
T.ITD = samesize(S.ITD, Nx1);
T.ITDtype = S.ITDtype;
T.TimeWarpFactor = ones(Ncond,1);
% ======freqs======
F.Fsam = S.Fsam;
F.Fcar = samesize(channelSelect('B', S.Fcar),Nx2);
F.Fmod = samesize(channelSelect('B', S.ModFreq), Nx2);
F.LowCutoff = nan(Ncond,2);
F.HighCutoff = nan(Ncond,2);
F.FreqWarpFactor = ones(Ncond,1);
% ======startPhases & mod Depths
Y.CarStartPhase = nan([Ncond 2 ID.Ntone]);
Y.ModStartPhase = samesize(channelSelect('B', S.ModStartPhase), Nx2);
Y.ModTheta = samesize(channelSelect('B', S.ModTheta), Nx2);
Y.ModDepth = samesize(channelSelect('B', S.ModDepth), Nx2);
% ======levels======
L.SPL = samesize(channelSelect('B', S.SPL), Nx2);
L.SPLtype = 'per tone';
L.DAC = S.DAC;
P = structJoin(ID, '-Timing', T, '-Frequencies', F, '-Phases_Depth', Y, '-Levels', L);
P.CreatedBy = mfilename; % sign





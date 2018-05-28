function Y = EvalBinRev(varargin);

% EVALBINREV    Calculates revcor for each ear from binaural datasets of uncorrelated noise 
%   Y = EvalBinRev(ds,'dsp',dsp,'dsn',dsn);
%   
%   Input params:
%             DS: dataset.
%          icond: selection of conditions (subsequence). If more than one
%                 is selected, the impulse responses are pooled across subseqs.
%                 A zero value means all conditions measured.
%      AnaWindow: analysis window in ms; [] means burst duration; this is
%                 also the default. Specification of analysis window as in AnWin.
%      CorSpan: the range of times of the impulse response as a vector [t1
%      t2] in ms.
%                a single number t is interpreted as [0 t]. Default is [0 25].
%       doPlot: 1/0 = make plot / don't. Deafult: do plot.
%   DelayEstimate: estimate of group delay around CF. This estimate is
%                  used for optimal phase unwrapping. Default: 0 ms.
%          Cdelay: compensating delay  [ms]. Phases are advanced by cdelay
%                  to highlight details in phase curves. Default: 0 ms.
%            dsNP: NTD dataset to correlated nosie
%            dsNN: NTD dataset to anticorrelated noise
%      FiltParam: [dBMeasure dBFit] - A two element vector specifying  how
%                  many dB below the peak of the filter to measure the bandwidth (i.e. lower and higher cutoff)
%                  and to fit the polynomial.
%
%   EvalBinRev returns struct Y with fields
%     Param: input parameters passed to revcorrev
%      time: time axis of impulse response
%        IR: impulse response (vector or Nx2 matrix)
%      freq: frequency axis in kHz of spectra
%   MagSpec: magnitude spectrum in dB. Estimated noise floor is set to 0 dB
%  Phase Spec: phase spectrum in cycles. Phase unwrapping optimed using
%             DelayEstimate input parameter (see above).
%
%
% Examples:
%   DF = 'M0545';
%   id = '11-6-NTD';
%   ds = dataset(DF, id);
%   dsp = dataset(DF,'11-4');
%   dsn = dataset(DF,'11-5'); 
%   T = EvalBinRev(ds,'dsp',dsp,'dsn',dsn);


% MMCL 31/10/2008 - added crosscorrealtion with difcor
% MMCL 08/08/2009 - added THR info
% MMCL 05/05/2009 - added spike shuffeling noise floor

%% ---------------- CHANGELOG -----------------------
%  Tue Mar 29 2011  Abel   
%   - Changed all code for THR to lower case fieldnames (see getThr4Cell)
%		example thr.CF -> thr.cf

%% ----------------------------- Set Parameters -----------------------------
% if nargin<2, icond = 1; end % default: only first condition
% if nargin<3, AnaWin = []; end % Anwin function will use burst dur
% if nargin<4, CorSpan = 25; end % ms default correlation span
% if nargin<5, doPlot = 1; end % do/don't plot results
% if nargin<6, DelayEstimate = 0; end % ms estimate of delay used for phase unwrapping
% if nargin<7, Cdelay = 0; end % ms compensating delay
% if nargin<8,
%     doDifCor = 0;
% elseif ~isempty(dsNP)
%     doDifCor = 1;
% else
%     doDifCor = 0;
% end
% if nargin<10, flipIpsiContra = 0; end % flip Ipsi and contra channels - depends on recording side and which speaker is on which ear
% if nargin<11, Nscram = 20; end % number of scrambled spiketrains
% % collect paramaters
% Param = collectinstruct(icond,AnaWin,CorSpan,doPlot,DelayEstimate,Cdelay,doDifCor,flipIpsiContra,Nscram);

DefParam.icond = 0;             % default zero: all conditions
DefParam.anawin = [];           % Anwin function will use burst dur
DefParam.corspan = [0 25];      % ms default correlation span
DefParam.plot = 'yes';          % do/don't plot results
DefParam.delayestimate = 0;     % ms estimate of delay used for phase unwrapping
DefParam.cdelay = 0;            % ms compensating delay
DefParam.flipipsicontra = 0;    %
DefParam.nscram = 20;           %
DefParam.recside = 'left';      % recording side

[DS,dsNP,dsNN,Param] = ParseArgs(DefParam,varargin{:});
if isempty(DS) % return factory settings
    Y = Param;
    return
end
%----------------------------- Main Function -----------------------------

% Calculate revcor
for n = 1:length(DS)
    if n == 1
        Param.Datafile = DS(n).filename;
        Param.seqID = DS(n).seqID;
    end
    [Y(n),Param] = calcrevcor(DS(n),Param);
end
Y = combineIR(Y);
Y = localSpectrum(Y, Param,DS(1));

% Calculate difcor and crosscorrelate with revcor
if Param.doDifCor
    [Y,Param] = calcDifCor(Y,Param,dsNP,dsNN);
end

% get threshold info
try
    Y.thr = getThr4Cell(DS(1).filename,DS(1).iCell);
catch
end

% Calculate filter measurements
Y = calcfiltermeasure(Y);

% Plot data
if strcmpi(Param.plot,'yes')
    localPlot(Y, Param);
end

% Format return argument
Y = makeyout(Y,Param,DS,dsNP,dsNN);

%----------------------------- Locals -----------------------------
function [DS,dsNP,dsNN,Param] = ParseArgs(DefParam,varargin);

if strcmpi(varargin{1},'factory')
    DS = [];
    dsNP = [];
    dsNN = [];
    Param = DefParam;
    DefParam
else
    kind = 1:length(varargin);
    DS = varargin{1};
    kind(1) = NaN;

    dspind = find(strcmpi(varargin,'dsp')==1);
    if isempty(dspind)
        dsNP = [];
    else
        dsNP = varargin{dspind+1};
        kind(dspind:dspind+1) = NaN;
    end

    dsnind = find(strcmpi(varargin,'dsn')==1);
    if isempty(dsnind)
        dsNN = [];
    else
        dsNN = varargin{dsnind+1};
        kind(dsnind:dsnind+1) = NaN;
    end
    kind = denan(kind);

    Param = checkproplist(DefParam, varargin{kind});
    if isempty(dsNP) | isempty(dsNN)
        Param.doDifCor = 0;
    else
        Param.doDifCor = 1;
    end
end
%------------------------------------------------------------------
function [Y,Param] = calcrevcor(DS,Param)

if length(Param.corspan)==1, Param.corspan=[0 Param.corspan]; end

DS = getdataset(DS); % returns dataset variable, even if DS is specified as char str (see help)

if isequal(0, Param.icond), Param.icond=1:DS.nrec; end % icond==0 means all recorded subseqs
Ncond = length(Param.icond);
Nscram = Param.nscram;
IR = 0;
h = waitbar(0,'Please wait...');

spt = anwin(DS, Param.anawin, 0, Param.icond(1)); % extract spike times from DS: all reps; single condition; respect analysis window
spt = cat(2,spt{:}).'; % pool spikes across reps

% get stimulus waveforms
[wv, dt] = GetStimSamples(DS, Param.icond(1));
Nchan = size(wv, 2);

% Taken from Bram's revcorr -
%Account for ITD in stimulus playback. This is only necessary for Madison datasets,
%because for SGSR datasets the ITD is already taken care of in the waveforms returned
%by GETSTIMSAMPLES.M.  For Madison datasets the ITD is not enforced by shifting the
%waveforms, but by taking another part of the IR ...
if isa(DS, 'EDFdataset'),
    [M, N] = size(DS.Stimulus.StimParam.Delay); NSub = DS.nsub;
    MasterDelay = repmat(DS.Stimulus.StimParam.Delay, NSub-M+1, Nchan-N+1);
    NShift = round(MasterDelay(Param.icond(1), 1:Nchan)/dt);
    ExtraN = max([0, NShift]);
else, NShift = zeros(1, Nchan); ExtraN = 0; end

dt = 1e-3*dt; % us -> ms
[time, ir] = local_compute_revcor(dt, wv, spt, Param.corspan,ExtraN,NShift);
IR = IR + ir; % sum of indiv IRs

if Nscram ~= 0
    IRScram = zeros(length(IR(:,1)),2*Nscram);
    for n = 1:Nscram
        sptScram = ScrambleSpkTr(spt')';
        [timeScram, irScram] = local_compute_revcor(dt, wv, sptScram, Param.corspan,ExtraN,NShift);
        IRScram(:,n*2-1:n*2) = IRScram(:,n*2-1:n*2) + irScram; % sum of indiv IRs
        waitbar(n/(Ncond*Nscram),h)
    end
else
    IRScram = 2e3*rand(length(IR(:,1)),2);
    timeScram = time;
    waitbar(1/Ncond,h)
end

for ii=2:1:Ncond,
    spt = anwin(DS, Param.anawin, 0, Param.icond(ii)); % extract spike times from DS: all reps; single condition; respect analysis window
    spt = cat(2,spt{:}).'; % pool spikes across reps
    [wv, dt] = GetStimSamples(DS, Param.icond(ii));

    % Taken from Bram's revcorr -
    %Account for ITD in stimulus playback. This is only necessary for Madison datasets,
    %because for SGSR datasets the ITD is already taken care of in the waveforms returned
    %by GETSTIMSAMPLES.M.  For Madison datasets the ITD is not enforced by shifting the
    %waveforms, but by taking another part of the IR ...
    if isa(DS, 'EDFdataset'),
        [M, N] = size(DS.Stimulus.StimParam.Delay); NSub = DS.nsub;
        MasterDelay = repmat(DS.Stimulus.StimParam.Delay, NSub-M+1, Nchan-N+1);
        NShift = round(MasterDelay(Param.icond(ii), 1:Nchan)/dt);
        ExtraN = max([0, NShift]);
    else, NShift = zeros(1, Nchan); ExtraN = 0; end
    dt = 1e-3*dt; % us -> ms
    [time, ir] = local_compute_revcor(dt, wv, spt, Param.corspan,ExtraN,NShift);
    IR = IR + ir; % sum of indiv IRs

    % scramble spike train and calc noise floor
    if Nscram ~= 0
        for n = 1:Nscram
            sptScram = ScrambleSpkTr(spt')';
            [timeScram, irScram] = local_compute_revcor(dt, wv, sptScram, Param.corspan,ExtraN,NShift);
            IRScram(:,n*2-1:n*2) = IRScram(:,n*2-1:n*2) + irScram; % sum of indiv IRs
            waitbar(((ii-1)*Nscram+n)/(Ncond*Nscram),h)
        end
    else
        waitbar(ii/Ncond,h)
    end
end
close(h)

%------------ Take care of flipping: Map left and right channels -----------
% Put stimulus from left ear in data column 1 and from right ear in
% data column 2. Determine recording side where possible.
[IRnew,recside,isflipped] = mapchannel2side(DS,IR);
if ~isempty(IRnew)
    IR = IRnew;
end
if ~isempty(recside)
    Param.recside = recside;
end

% Make data column one ipsi and data column two contra
% If recording side is left then column 1 is already ipsi (left ear) and column 2 is
% contra (right ear) - so do nothing
% If recording side is right, then flip column 1 and 2.
if strcmpi(Param.recside,'right')
    IR = IR(:,[2 1]);
    % keep track of flipping
    if isflipped == 0
        isflipped = 1;
    else
        isflipped = 0;
    end
end

% if desired flip ipsi and contra channels - should normally not be used
if Param.flipipsicontra == 1
    IR = IR(:,[2 1]);
    % keep track of flipping
    if isflipped == 0
        isflipped = 1;
    else
        isflipped = 0;
    end
end

IR = IR/Ncond; % mean of all IRs
IRScram = IRScram/Ncond; % mean of all IRs
dt = diff(time([1 2])); % spacing of time axis in ms
Y = CollectInStruct(time, IR,timeScram, IRScram, dt);
Param.isflipped = isflipped;

%------------------------------------------
function Ycom = combineIR(Y)

if length(Y)==1
    Ycom = Y;
else
    IRScram = zeros(size(Y(1).IRScram));
    for n = 1:length(Y)
        IR1(:,n) = Y(n).IR(:,1);
        IR2(:,n) = Y(n).IR(:,2);
        IRScram = IRScram + Y(n).IRScram;
    end
    Ycom.IR(:,1) = mean(IR1');
    Ycom.IR(:,2) = mean(IR2');
    Ycom.time = Y(1).time;
    %Ycom.IRScram = IRScram;
	Ycom.IRScram = IRScram/length(Y);
    Ycom.timeScram = Y(1).timeScram;
    Ycom.dt = Y(1).dt;
end

%------------------------------------------
function Yout = makeyout(Y,Param,DS,dsNP,dsNN);

Yout.ds1.filename = DS(1).filename;
Yout.ds1.seqid = DS(1).seqid;
Yout.ds1.icell = DS(1).icell;
Yout.ds1.spl = DS(1).SPL(1);
if isa(DS(1), 'EDFdataset'),
    Yout.ds1.seed = [];
    Yout.ds1.flow = [];
    Yout.ds1.high = [];
else
    Yout.ds1.seed = DS(1).Stimulus.StimParam.RandomSeed;
    Yout.ds1.flow = DS(1).Stimulus.StimParam.Flow;
    Yout.ds1.high = DS(1).Stimulus.StimParam.Fhigh;
end

if ~isempty(dsNP)
    Yout.dsnp.filename = dsNP(1).filename;
    Yout.dsnp.seqid = dsNP(1).seqid;
    Yout.dsnp.icell = dsNP(1).icell;
    Yout.dsnp.spl = dsNP(1).SPL(1);
    if isa(dsNP(1), 'EDFdataset'),
        Yout.dsnp.seed = [];
        Yout.dsnp.flow = [];
        Yout.dsnp.high = [];
    else
        Yout.dsnp.seed = dsNP(1).Stimulus.StimParam.RandomSeed;
        Yout.dsnp.flow = dsNP(1).Stimulus.StimParam.Flow;
        Yout.dsnp.high = dsNP(1).Stimulus.StimParam.Fhigh;
    end
else
    Yout.dsnp.filename = [];
    Yout.dsnp.seqid = [];
    Yout.dsnp.icell = [];
    Yout.dsnp.spl = [];
    Yout.dsnp.seed = [];
    Yout.dsnp.flow = [];
    Yout.dsnp.high = [];
end
if ~isempty(dsNN)
    Yout.dsnn.filename = dsNN(1).filename;
    Yout.dsnn.seqid = dsNN(1).seqid;
    Yout.dsnn.icell = dsNN(1).icell;
    Yout.dsnn.spl = dsNN(1).SPL(1);
    if isa(dsNN(1), 'EDFdataset'),
        Yout.dsnn.seed = [];
        Yout.dsnn.flow = [];
        Yout.dsnn.high = [];
    else
        Yout.dsnn.seed = dsNN(1).Stimulus.StimParam.RandomSeed;
        Yout.dsnn.flow = dsNN(1).Stimulus.StimParam.Flow;
        Yout.dsnn.high = dsNN(1).Stimulus.StimParam.Fhigh;
    end
else
    Yout.dsnn.filename = [];
    Yout.dsnn.seqid = [];
    Yout.dsnn.icell = [];
    Yout.dsnn.spl = [];
    Yout.dsnn.seed = [];
    Yout.dsnn.flow = [];
    Yout.dsnn.high = [];

end


Yout.param.corspan = Param.corspan;
Yout.param.delayestimate = Param.delayestimate;
Yout.param.cdelay = Param.cdelay;
Yout.param.recside = Param.recside;
Yout.param.isflipped = Param.isflipped;

if isfield(Y,'DiffRate')
    Yout.difcor.corco = Y.corco;
    Yout.difcor.bd = Y.BD;
    Yout.difcor.df = Y.DFdifcor;
    Yout.difcor.predicteddf =  Y.DFpredictedDifcor; 
else
    Yout.difcor.corco = [];
    Yout.difcor.bd = [];
    Yout.difcor.df =[];
    Yout.difcor.predicteddf = [];
end

if isempty(Y.Filter.DF)
    Yout.df = [];
    Yout.dfmag = [];
    Yout.meanfreq = [];
    Yout.fintersectlow = [];
    Yout.fintersecthigh = [];
    Yout.bw = [];
    Yout.freqdif = [];
    Yout.octdif = [];
    Yout.ratio = [];
    Yout.octdifdf = [];
    Yout.ratiodf = [];

    Yout.fit.df = [];
    Yout.fit.fintersectlow = [];
    Yout.fit.fintersecthigh = [];
    Yout.fit.bw = [];

    Yout.phase.slope = [];

    Yout.DifMag = [];
    Yout.DifPhase = [];
    Yout.DifFreq = [];
    Yout.DifCrossFreq = [];
    Yout.DFDifMag = [];
else
    Yout.df = Y.Filter.DF;
    Yout.dfmag = Y.Filter.DFMag;
    Yout.meanfreq = mean(Y.Filter.DF);
    Yout.fintersectlow = Y.Filter.Fintersect(:,1)';
    Yout.fintersecthigh = Y.Filter.Fintersect(:,2)';
    Yout.bw(1,1) = max(Y.Filter.Fintersect(1,:)) - min(Y.Filter.Fintersect(1,:));
    Yout.bw(1,2) = max(Y.Filter.Fintersect(2,:)) - min(Y.Filter.Fintersect(2,:));
    Yout.freqdif = Y.Filter.xcor.freqDif;
    Yout.octdif = Y.Filter.xcor.octDif;
    Yout.ratio = Y.Filter.xcor.ratio;
    Yout.octdifdf = Y.Filter.xcor.octDifDF;
    Yout.ratiodf = Y.Filter.xcor.ratioDF;

    Yout.fit.df = Y.Filter.fit.DF;
    Yout.fit.fintersectlow = Y.Filter.fit.Fintersect(:,1)';
    Yout.fit.fintersecthigh = Y.Filter.fit.Fintersect(:,2)';
    Yout.fit.bw(1,1) = max(Y.Filter.fit.Fintersect(1,:)) - min(Y.Filter.fit.Fintersect(1,:));
    Yout.fit.bw(1,2) = max(Y.Filter.fit.Fintersect(2,:)) - min(Y.Filter.fit.Fintersect(2,:));

    Yout.phase.slope = Y.Filter.Phase.fit.slope;

    [dum crossind] = min(abs(Y.Filter.DifFreq-Y.Filter.DifCrossFreq));
    DifFilter = Y.Filter.DifFilter - Y.Filter.DifFilter(crossind);
    Yout.DifMag = DifFilter';
    Yout.DifPhase = Y.Filter.DifPhase';
    Yout.DifFreq = Y.Filter.DifFreq;
    Yout.DifCrossFreq = Y.Filter.DifCrossFreq;
    Yout.DFDifMag = Y.Filter.DFMagDif;
end


if isfield(Y,'thr')
    Yout.thr.cf = Y.thr.cf;
    Yout.thr.sr = Y.thr.sr;
    Yout.thr.thr = Y.thr.thr;
    Yout.thr.bw = Y.thr.bw;
    Yout.thr.q10 = Y.thr.q10;
else
    Yout.thr.cf = [];
    Yout.thr.sr = [];
    Yout.thr.thr = [];
    Yout.thr.bw = [];
    Yout.thr.q10 = [];
end

%------------------------------------------
function  [Y,Param] = calcDifCor(Y,Param,dsNP,dsNN);

% add params
Param.dsNPseqID = dsNP.seqID;
Param.dsNNseqID = dsNN.seqID;

% get difcor data
Y.Rpos = ucrate('compute',dsNP);
Y.Rneg = ucrate('compute',dsNN);

% -- check that dsN and dsN match - cut or resample if necessary --
% only work with overlapping parts of functions
[indp indn] = overlap(Y.Rpos.Xval,Y.Rneg.Xval);
Y.Rpos.Xval = Y.Rpos.Xval(indp);
Y.Rneg.Xval = Y.Rneg.Xval(indn);
Y.Rpos.Rate = Y.Rpos.Rate(indp);
Y.Rneg.Rate = Y.Rneg.Rate(indn);

% resmaple if necesary
delXpos = Y.Rpos.Xval(2) - Y.Rpos.Xval(1);		%Get increment Rpos
delXneg = Y.Rneg.Xval(2) - Y.Rneg.Xval(1);		%Get increment Rneg
if delXpos < delXneg % resample to higher sampling rate
    Y.Rneg.Rate = interp1(Y.Rneg.Xval,Y.Rneg.Rate,Y.Rpos.Xval);
    Y.Rneg.Xval = Y.Rpos.Xval;
elseif delXpos > delXneg
    Y.Rpos.Rate = interp1(Y.Rpos.Xval,Y.Rpos.Rate,Y.Rneg.Xval);
    Y.Rpos.Xval = Y.Rneg.Xval;
end

% % cut if necessary
% if length(Y.Rpos.Xval) ~= length(Y.Rneg.Xval)
%     [IndP,IndN] = match(Y.Rpos.Xval,Y.Rneg.Xval);
%     Y.Rpos.Xval = Y.Rpos.Xval(IndP);
%     Y.Rneg.Xval = Y.Rneg.Xval(IndN);
%     Y.Rpos.Rate = Y.Rpos.Rate(IndP);
%     Y.Rneg.Rate = Y.Rneg.Rate(IndN);
% end

% calculate difcor  = Y.Rpos.Rate - Y.Rneg.Rate;
Y.DiffRate = Y.Rpos.Rate - Y.Rneg.Rate; % no resampling - simple subtraction
Y.rITD = -1e-3*Y.Rpos.Xval;

% normalize XIR for plotting
MaxDif = max(abs(Y.DiffRate));
Y.nXIR = MaxDif*Y.XIR/max(abs(Y.XIR));
ITD = Y.dt*[0:length(Y.XIR)-1] + Y.XIR_timeoffset ;

% interpolate NTDto ITD values from rate curves
[dum MinCut] = min(abs(ITD - min(Y.rITD)));
[dum MaxCut] = min(abs(ITD - max(Y.rITD)));
ITD = ITD(MinCut-1:MaxCut+1);
Y.nXIRshort = Y.nXIR(MinCut-1:MaxCut+1);
PredDif = interp1(ITD, Y.nXIRshort, Y.rITD);
if any(isnan(PredDif)),
    warning('interpolation outside ITD range.')
end
% computed corr between measured & predicted diffrate fcns
corco = xcorr(PredDif, Y.DiffRate, 0, 'coeff');
Y.PredDif = PredDif;
Y.corco = 0.01*round(100*corco);

% find best delay
[dum ind] = max(Y.DiffRate);
Y.BD = Y.rITD(ind);

%---- compute spectra ----

% compute magn & phase spectrum;
dt = abs(Y.rITD(2)-Y.rITD(1));
nsam = length(Y.PredDif);
Dur = nsam*dt; % duration in ms
df = 1/Dur; % freq spacing in kHz
Y.DiffCorSpecFreq = df*(0:nsam-1).'; % freq in Hz

% compute & apply hann window, compute complex fft spectrum
hanwin = hann(nsam)';
PredDifSpec = fft(Y.PredDif.*hanwin); % complex spec after windowing
%nXIRSpec = fft(Y.nXIR.*hanwin); % complex spec after windowing
DiffRateSpec = fft(Y.DiffRate.*hanwin); % complex spec after windowing
% magnitude
Y.PredDifMagSpec = abs(PredDifSpec);
%Y.nXIRMagSpec = abs(nXIRSpec);
Y.DiffRateMagSpec = abs(DiffRateSpec);
% amp to power
Y.PredDifMagSpec = Y.PredDifMagSpec.^2;
%Y.nXIRMagSpec = Y.nXIRMagSpec.^2;
Y.DiffRateMagSpec = Y.DiffRateMagSpec.^2;

% restrict to 2kHz
kind = find(Y.DiffCorSpecFreq<=2);
Y.DiffCorSpecFreq = Y.DiffCorSpecFreq(kind);
Y.PredDifMagSpec = Y.PredDifMagSpec(kind);
%Y.nXIRMagSpec = Y.nXIRMagSpec(kind);
Y.DiffRateMagSpec = Y.DiffRateMagSpec(kind);

[dum Pind] = max(Y.PredDifMagSpec);
%[dum Xind] = max(Y.nXIRMagSpec);
[dum Dind] = max(Y.DiffRateMagSpec);

Y.DFpredictedDifcor = Y.DiffCorSpecFreq(Pind);
%Y.DFpredictedDifcor = Y.DiffCorSpecFreq(Xind);
Y.DFdifcor = Y.DiffCorSpecFreq(Dind);

%--------------------------------------------
function Y = calcfiltermeasure(Y,Param)

% extract params from raw data
[val1 where1] = max(Y.MagSpecUp(:,1)-Y.NoiseFloor);
[val2 where2] = max(Y.MagSpecUp(:,2)-Y.NoiseFloor);
DF(1) = Y.freqUp(where1);
DF(2) = Y.freqUp(where2);
DFMag(1) = val1;
DFMag(2) = val2;
indDF(1) = where1;
indDF(2) = where2;

% find intersection of Magnitude spectrum and noise floor
[Xp1, Yp1, ind1] = funintersect(Y.freqUp, Y.MagSpecUp(:,1), Y.NoiseFloor);
[Xp2, Yp2, ind2] = funintersect(Y.freqUp, Y.MagSpecUp(:,2), Y.NoiseFloor);
if ~isnan(ind1(1)) & ~isnan(ind2(1))
    Fintersect(1,:) = Xp1;
    Fintersect(2,:) = Xp2;

    % fit polynomical to data
    fit.Freq1 = Y.freqUp(ind1(1):ind1(2));
    fit.Freq2 = Y.freqUp(ind2(1):ind2(2));
    fit.MagReal1 = Y.MagSpecUp(ind1(1):ind1(2),1);
    fit.MagReal2 = Y.MagSpecUp(ind2(1):ind2(2),2);
    p1 = polyfit(fit.Freq1,fit.MagReal1,2);
    p2 = polyfit(fit.Freq2,fit.MagReal2,2);
    fit.Mag1 = polyval(p1,fit.Freq1);
    fit.Mag2 = polyval(p2,fit.Freq2);

    % extract params from fit
    [val2 where1] = max(fit.Mag1);
    [val2 where2] = max(fit.Mag2);
    fit.DF(1) = fit.Freq1(where1);
    fit.DF(2) = fit.Freq2(where2);
    fullMag1 = polyval(p1,Y.freqUp);
    fullMag2 = polyval(p2,Y.freqUp);

    [fit.Fintersect(1,:), Yp] = funintersect(Y.freqUp, fullMag1, Y.NoiseFloor);
    [fit.Fintersect(2,:), Yp] = funintersect(Y.freqUp, fullMag2, Y.NoiseFloor);

    % extract phase params
    Phase.PhSpec1 = Y.PhaseSpecUp(ind1(1):ind1(2),1);
    Phase.PhSpec2 = Y.PhaseSpecUp(ind2(1):ind2(2),2);
    [Phase.fit.Ph1,LineParam1] = regline(fit.Freq1,Phase.PhSpec1);
    [Phase.fit.Ph2,LineParam2] = regline(fit.Freq2,Phase.PhSpec2);
    Phase.fit.slope(1) = LineParam1.grad;
    Phase.fit.slope(2) = LineParam2.grad;

    % crosscor to get frequency difference
    MagAboveNoise(ind1(1):ind1(2),1) = Y.MagSpecUp(ind1(1):ind1(2),1);
    MagAboveNoise(ind2(1):ind2(2),2) = Y.MagSpecUp(ind2(1):ind2(2),2);
    PhaseAboveNoise(ind1(1):ind1(2),1) = Y.PhaseSpecUp(ind1(1):ind1(2),1);
    PhaseAboveNoise(ind2(1):ind2(2),2) = Y.PhaseSpecUp(ind2(1):ind2(2),2);
    if length(MagAboveNoise(:,1))>1
        [c lags] = xcorr(MagAboveNoise(:,1),MagAboveNoise(:,2));
        auto1 = xcorr(MagAboveNoise(:,1),0);
        auto2 = xcorr(MagAboveNoise(:,2),0);
        normc = c/sqrt(auto1*auto2); % normalize cross correlation
        [val indc] = max(normc);
        df = Y.freqUp(2)-Y.freqUp(1); % Get increment of freqUp
        xcor.dfreqs = lags*df;
        xcor.cor = normc;
        xcor.indPeak = indc;
        xcor.freqDif = xcor.dfreqs(indc);

        if isempty(Y.thr.cf)
            xcor.octDif = [];
            xcor.ratio = [];
        elseif xcor.freqDif*1e3 > Y.thr.cf
            xcor.octDif = [];
            xcor.ratio = [];
        else
            if xcor.freqDif>0 % Ch1 > Ch2
                xcor.octDif = -log2((Y.thr.cf - xcor.freqDif*1e3)/Y.thr.cf); % log(<1) = -
            else% Ch1 < Ch2
                xcor.octDif = log2((Y.thr.cf - abs(xcor.freqDif*1e3))/Y.thr.cf); % log(>1) = +
            end
            xcor.ratio = (xcor.freqDif*1e3)/Y.thr.cf;
        end


        if isempty(DF(1))
            xcor.octDifDF = [];
            xcor.ratioDF = [];
        elseif xcor.freqDif > mean(DF(:))
            xcor.octDifDF = [];
            xcor.ratioDF = [];
        else
            meanDF = mean(DF(:))*1e3;
            if xcor.freqDif>0 % Ch1 > Ch2
                xcor.octDifDF = -log2((meanDF - xcor.freqDif*1e3)/meanDF); % log(<1) = -
            else% Ch1 < Ch2
                xcor.octDifDF = log2((meanDF - abs(xcor.freqDif*1e3))/meanDF); % log(>1) = +
            end
            xcor.ratioDF = (xcor.freqDif*1e3)/meanDF;
        end


        %----- divide to get filter - Ch2/Ch1 -----

        % first get index for overlapping parts
        F1 = MagAboveNoise(:,1);
        F2 = MagAboveNoise(:,2);
        NonZeroInd1 = find(F1~=0);
        NonZeroInd2 = find(F2~=0);
        KeepInd = intersect(NonZeroInd1,NonZeroInd2);
        %         if DFMag(1)<DFMag(2)
        %             F1 = MagAboveNoise(:,1) + diff(DFMag);
        %             F2 = MagAboveNoise(:,2);
        %         else
        %             F2 = MagAboveNoise(:,2) + diff(DFMag);
        %             F1 = MagAboveNoise(:,1);
        %         end
        %


        % change to dB
        F1 = a2dB(F1);
        F2 = a2dB(F2);

        % normalize to zero
        F1 = F1 - max(F1);
        F2 = F2 - max(F2);

        % find frequency at which filters cross
        if isempty(KeepInd) % - filters do not cross
            DifFilter = [];
            DifPhase = [];
            DifFreq = [];
            DFMagDif = [];
            DifCrossFreq = [];
        else % - filter do cross -  get difference filter measures
            if DF(1)<DF(2)
                for n = indDF(1):length(F1)
                    if F1(n)<=F2(n)
                        crossInd = n;
                        break
                    end
                end
            else
                for n = indDF(2):length(F2)
                    if F2(n)<=F1(n)
                        crossInd = n;
                        break
                    end
                end
            end

            DifCrossFreq = Y.freqUp(crossInd);

            % in dB so subtract is same as linear divide
            DifFilter = F2-F1;
            DifFilter = DifFilter(KeepInd);
            DifPhase = PhaseAboveNoise(:,2) - PhaseAboveNoise(:,1);
            DifPhase = DifPhase(KeepInd);
            DifFreq = Y.freqUp(KeepInd)';

            [dum DifInd1] = min(abs(DifFreq-DF(1)));
            [dum DifInd2] = min(abs(DifFreq-DF(2)));
            DFMagDif(1) = DifFilter(DifInd1);
            DFMagDif(2) = DifFilter(DifInd2);
        end
    else
        DF = [];
        DFMag = [];
        Fintersect = [];
        fit = []
        Phase = [];
        xcor.dfreqs = [];
        xcor.cor = [];
        xcor.indPeak = [];
        xcor.freqDif = [];
        xcor.octDif = [];
        xcor.ratio = [];
        xcor.octDifDF = [];
        xcor.ratioDF = [];
        DifFilter = [];
        DifPhase = [];
        DifFreq = [];
        DFMagDif = [];
        DifCrossFreq = [];
    end

else
    DF = [];
    Fintersect = [];
    fit = []
    Phase = [];
    xcor.dfreqs = [];
    xcor.cor = [];
    xcor.indPeak = [];
    xcor.freqDif = [];
    xcor.octDif = [];
    xcor.ratio = [];
    xcor.octDifDF = [];
    xcor.ratioDF = [];
    DifFilter = [];
    DifPhase = [];
    DifFreq = [];
    DFMagDif = [];
    DifCrossFreq = [];
end

Y.Filter = collectInStruct(DF,DFMag,Fintersect,fit,Phase,xcor,DifFilter,DifPhase,DifCrossFreq,DifFreq,DFMagDif);

%--------------------------------------------
function [Time, IR] = local_compute_revcor(PbPer, y, SpkTimes, CorSpan,ExtraN,NShift);

Nwin = round(CorSpan(end)/PbPer); %Conversion from ms->us->samples ...
NSamples = size(y, 1); Nchan = size(y, 2);

NSpikes = length(SpkTimes);

%Construct binary spike signal at correct sample rate ...
TimeEdges = (0:NSamples)*PbPer; %Binning edges in ms ...
if isempty(SpkTimes), SpkTimes = Inf; end
BinnedSpikes = histc(SpkTimes, TimeEdges);

IR = zeros(Nwin, Nchan); %Pre-allocation of impulse response ...

for n = 1:Nchan,
    xc = flipud(xcorr(y(:, n), BinnedSpikes, Nwin+ExtraN)/NSpikes);
    IR(:, n) = xc((1:Nwin)+(Nwin+ExtraN+1)+NShift(n));
end
Time = TimeEdges(1:Nwin)';

%---------------------------------------------------------
function Y = localSpectrum(Y, Param,ds);

dt = Y.dt;
tau_est = Param.delayestimate;
Cdelay = Param.cdelay;
% compute magn & phase spectrum; max freq is 5 kHz
[nsam, nchan] = size(Y.IR);
Dur = nsam*dt; % duration in ms
df = 1/Dur; % freq spacing in kHz
TimeOffset = Param.corspan(1); % the deviation in ms from time=zero of the first sample of the IR
Y.freq = df*(0:nsam-1).'; % freq in Hz
% compute & apply hann window, compute complex fft spectrum
hanwin = repmat(hann(nsam),1,nchan);
Spec = fft(Y.IR.*hanwin); % complex spec after windowing
hanwin = repmat(hann(nsam),1,length(Y.IRScram(1,:)));
SpecScram = fft(Y.IRScram.*hanwin); % complex spec after windowing
% magnitude
Y.MagSpec = abs(Spec);
Y.MagSpecScram = abs(SpecScram);

% change amp to power
Y.MagSpec = Y.MagSpec.^2;
Y.MagSpecScram = Y.MagSpecScram.^2;

[dum, ipeak] = max(Y.MagSpec); % location of spectral peak, per channel
% phase
ang = angle(Spec); % angle in radians
%TimeOffset, tau_est, minFreq = min(Y.freq), maxFreq = max(Y.freq), df = diff(Y.freq(1:2))
ang = local_delay(ang, Y.freq, TimeOffset-tau_est); % delay/advance according to time axis of IR & estimated delay
ang = local_delay(unwrap(ang), Y.freq, tau_est-Cdelay)/2/pi; % unwrap, undo Tau estimate shift, add Cdelay, and convert to cycles
% set phase near magnitude peak to near zero cycle
ang_at_peak = [ang(ipeak(1),1) ang(ipeak(end),end)];
ang(:,1) = ang(:,1)-round(ang_at_peak(1));
ang(:,end) = ang(:,end)-round(ang_at_peak(end));
Y.PhaseSpec = ang;

% % restrict everything to freqs <= 5 kHz; use freqs>5 kHz as noise floor
% iHF = find(Y.freq<=5);
% if ~isempty(iHF)
%     Y.MagSpec = Y.MagSpec - median(Y.MagSpec(iHF));
% end

% restrict to less than 2kH
iLF = find(Y.freq<=2);
[Y.freq, Y.MagSpec, Y.PhaseSpec, Y.MagSpecScram] = deal(Y.freq(iLF,:), Y.MagSpec(iLF,:), Y.PhaseSpec(iLF,:), Y.MagSpecScram(iLF,:));

% restrict to lower noise boundary
if isa(ds, 'EDFdataset')
    iHF = find(Y.freq>=100/1e3);
else
    iHF = find(Y.freq>=ds.Stimulus.StimParam.Flow/1e3);
end
[Y.freq, Y.MagSpec, Y.PhaseSpec, Y.MagSpecScram] = deal(Y.freq(iHF,:), Y.MagSpec(iHF,:), Y.PhaseSpec(iHF,:), Y.MagSpecScram(iHF,:));


% upsample by factor of 10
UpFac = 10;
dFreq  = Y.freq(2)-Y.freq(1);
Y.freqUp = [Y.freq(1):dFreq/UpFac:Y.freq(end)];
Y.MagSpecUp = interp1(Y.freq,Y.MagSpec,Y.freqUp,'linear');
Y.MagSpecScramUp = interp1(Y.freq,Y.MagSpecScram,Y.freqUp,'linear');
Y.PhaseSpecUp = interp1(Y.freq,Y.PhaseSpec,Y.freqUp,'linear');
Y.freqUp = Y.freqUp';

% determine noise floor
Y.meanMagSpecScramUp = mean(Y.MagSpecScramUp')';
Y.stdMagSpecScramUp = std(Y.MagSpecScramUp')';
Y.NoiseFloor = Y.meanMagSpecScramUp + 2*Y.stdMagSpecScramUp;

% % set zero value
% GenNoiseFloor = max(mean(Y.MagSpecScramUp)+2*std(Y.MagSpecScramUp));%
% Y.MagSpec = Y.MagSpec - GenNoiseFloor; % make noise floor zero
% Y.MagSpecScram = Y.MagSpecScram - GenNoiseFloor; % make noise floor zero
% Y.MagSpecUp = Y.MagSpecUp - GenNoiseFloor; % make noise floor zero
% Y.MagSpecScramUp = Y.MagSpecScramUp - GenNoiseFloor; % make noise floor zero
% Y.meanMagSpecScramUp = Y.meanMagSpecScramUp - GenNoiseFloor;
% Y.stdMagSpecScramUp = Y.stdMagSpecScramUp - GenNoiseFloor;
% Y.NoiseFloor = Y.NoiseFloor - GenNoiseFloor;

Y.XIR = xcorr(Y.IR(:,end),Y.IR(:,1));
Y.XIR_timeoffset = -dt*(numel(Y.XIR)-1)/2;
Y.dt = dt; Y.df = df;

%---------------------------------------------------------
function ang = local_delay(ang, freq, tau);
% delay angle vector (in rad) tau ms; freq in kHz
nchan = size(ang,2);
Shifter = -2*pi*tau*freq; % lin phase vector corresponding delay of tau
Shifter = repmat(Shifter, 1, nchan); % adjust size to # channels
ang = ang + Shifter;

%---------------------------------------------------------
function localPlot(Y, Param);
%plot function

FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), [Param.Datafile '  ' Param.seqID]),...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%---------- Dataset Info ------------
subplot(5,2,1);
axis off
if strcmpi(Param.recside,'left')
    ch1string = ['Data Column 1 = Left ear = Ipsi' ];
    ch2string = ['Data Column 2 = Right ear = Contra'];
elseif strcmpi(Param.recside,'right')
    ch1string = ['Data Column 1 = Right ear = Ipsi' ];
    ch2string = ['Data Column 2 = Left ear = Contra'];
end
text(0.1,0.8,{['Recording side is  ' Param.recside]; 'Data are now arranged as follows:'; ch1string; ch2string},...
    'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 10);

%------THR---------
if isfield(Y,'thr')
    if ~isempty(Y.thr.thr)
        if ~isnan(Y.thr.thr)
            subplot(5,2,2);
            ds = dataset(Param.Datafile,Y.thr.seqnr);
            Freq = ds.Data.OtherData.thrCurve.freq/1e3;
            Thr = ds.Data.OtherData.thrCurve.threshold;
            [dum kind] = denan(Thr);
            LimFreq = Freq(kind);
            MinX = min(LimFreq); MaxX = max(LimFreq);
            MinY = 0; MaxY = max(Thr);
            line(Freq, Thr, 'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
            xlabel('Frequency (kHz)'); ylabel('Threshold (dB SPL)');
            xlim([MinX MaxX])
            ylim([MinY MaxY])
            text(0.1,0.8,{['Seq ID = ' ds.id.SeqID]; ...
                ['Seq Num = ' num2str(ds.id.iSeq)]; ...
                sprintf('CF = %.0fHz', Y.thr.cf); ...
                sprintf('THR = %.0fdB', Y.thr.thr)}, ...
                'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);
        end
    end
end

%------IR Noise floor---------
subplot(5,2,3);
hold on
plot(Y.time, Y.IRScram(:,1),'r');
plot(Y.time, Y.IRScram(:,2),'m');
legend('Noise Floor 1','Noise Floor 2');
legend boxoff
xlim([min(Y.time) max(Y.time)]);
xlabel('Time (ms)');
ylabel('Amplitude (A.U.)');
ds = dataset(Param.Datafile,Param.seqID);
if isa(ds, 'EDFdataset')
    Str = strvcat(Param.Datafile,Param.seqID,['subseq: ' paramstring(Param.icond.')],['SPL: ' num2str(ds.spl)]);
else
    Str = strvcat(Param.Datafile,Param.seqID,['subseq: ' paramstring(Param.icond.')],['SPL: ' num2str(ds.spl)],['Stim BW: ' num2str(ds.Flow) '-' num2str(ds.Fhigh)]);
end
text(0.05,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);

%------XCOR---------
subplot(5,2,4);
hold on
if ~isempty(Y.Filter.DF)
    plot(Y.Filter.xcor.dfreqs, Y.Filter.xcor.cor,'b');
    plot(Y.Filter.xcor.freqDif, Y.Filter.xcor.cor(Y.Filter.xcor.indPeak),'kx');
end
xlim([-0.2 0.2]);
xlabel('\Delta Frequency (kHz)');
ylabel('Correlation');
Str = strvcat(['\DeltaF = ', num2str(round(Y.Filter.xcor.freqDif*1e3)) ' Hz'],...
    ['Oct  = ' num2str(round(Y.Filter.xcor.octDif*100)/100)],...
    ['Ratio  = ' num2str(round(Y.Filter.xcor.ratio*100)/100)],...
    ['Oct DF  = ' num2str(round(Y.Filter.xcor.octDifDF*100)/100)],...
    ['Ratio DF  = ' num2str(round(Y.Filter.xcor.ratioDF*100)/100)],...
    ['mean DF  = ' num2str(round(mean(Y.Filter.DF(:))*1e3*100)/100)]);
text(0.05,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);

%------IR---------
subplot(5,2,5);
hold on
plot(Y.time, Y.IR(:,1),'b');
plot(Y.time, Y.IR(:,2),'g');
legend('Ipsi','Contra');
legend boxoff
xlim([min(Y.time) max(Y.time)]);
xlabel('Time (ms)');
ylabel('Amplitude (A.U.)');

% colofon
awin = Param.anawin;
if isempty(awin), awinstr = '[]'; else, awinstr = ['[' trimspace(num2str(awin)) '] ms']; end
corspan = Param.corspan;
if isempty(corspan), cstr = '[]'; else, cstr = ['[' trimspace(num2str(corspan)) '] ms']; end
Str = strvcat(['Analysis window: ', awinstr], ['IR span: ' cstr]);
text(0.1,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);

setylim = ylim;
subplot(5,2,3);
ylim(setylim);

% ----difcor-------
if isfield(Y,'DiffRate')
    subplot(5,2,6); hold on
    DS = dataset(Param.Datafile,Param.dsNPseqID);
    if isa(DS, 'EDFdataset')
        rITD = 1e-3*Y.Rpos.Xval;
    else
        rITD = -1e-3*Y.Rpos.Xval;  % STANDARD ITD in ms (PXJ)
    end
    plot(rITD, Y.Rpos.Rate, 'm^-','linewidth', 1,'markersize', 4);
    xplot(rITD, Y.Rneg.Rate, 'cv-','linewidth', 1,'markersize', 4);
    xlim([min(rITD) max(rITD)]);
    ylim([min([Y.Rpos.Rate Y.Rneg.Rate]) 1.1*max([Y.Rpos.Rate Y.Rneg.Rate])]);
    xlabel('ITD (ms)')
    ylabel('Rate (spikes/s)')
    legend({'+' '-'},1);
    legend boxoff;
    try
        dsNP = dataset(Param.Datafile,Param.dsNPseqID);
        dsNN = dataset(Param.Datafile,Param.dsNNseqID);
        if isa(dsNP, 'EDFdataset')
            Str = strvcat(Param.Datafile,[Param.dsNPseqID '  SPL: ' num2str(dsNP.spl)],...
                [Param.dsNNseqID '  SPL: ' num2str(dsNP.spl)]);
        else
            Str = strvcat(Param.Datafile,[Param.dsNPseqID '  SPL: ' num2str(dsNP.spl) '  Stim BW: ' num2str(dsNP.Flow) '-' num2str(dsNP.Fhigh)],...
                [Param.dsNNseqID '  SPL: ' num2str(dsNP.spl) '  Stim BW: ' num2str(dsNP.Flow) '-' num2str(dsNP.Fhigh)]);
        end
    catch
        Str = 'Can not get ds info';
    end        
    text(0.05,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);
end

%-------mag spec-----
subplot(5,2,7);
hold on
GNF = a2dB(max(mean(Y.MagSpecScramUp)+2*std(Y.MagSpecScramUp)));% set general noise floor as zero dB
if ~isempty(Y.Filter.DF)
    plot(Y.Filter.fit.Freq1, a2dB(Y.Filter.fit.Mag1)-GNF,'b--')
    plot(Y.Filter.fit.Freq2, a2dB(Y.Filter.fit.Mag2)-GNF,'g--')
    l = legend(['DF=' num2str(round(Y.Filter.DF(1)*1e3)) 'Hz'], ['DF=' num2str(round(Y.Filter.DF(2)*1e3)) 'Hz']);
    set(l,'fontsize',8)
    legend boxoff
end

lgray = [0.5 0.5 0.5];
plot(Y.freq, a2dB(Y.MagSpecScram)-GNF,'color',lgray);

plot(Y.freqUp,a2dB(Y.meanMagSpecScramUp)-GNF,'k')
plot(Y.freqUp,a2dB(Y.NoiseFloor)-GNF,'k','linewidth',1.5)

plot(Y.freqUp, a2dB(Y.MagSpecUp(:,1))-GNF,'b');
plot(Y.freqUp, a2dB(Y.MagSpecUp(:,2))-GNF,'g');
if ~isempty(Y.Filter.DF)
    plot(Y.Filter.fit.Freq1,a2dB(Y.Filter.fit.MagReal1)-GNF,'b','linewidth',2)
    plot(Y.Filter.fit.Freq2,a2dB(Y.Filter.fit.MagReal2)-GNF,'g','linewidth',2)
    [dum indC] = min(abs(Y.Filter.DifFreq-Y.Filter.DifCrossFreq));
    plot(Y.Filter.DifFreq,Y.Filter.DifFilter,'r')
end

xlog125
xlabel('Frequency (kHz)')
ylabel('Magnitude (dB)')

[vals ind] = max(mean(Y.MagSpecScramUp)+2*std(Y.MagSpecScramUp));
MeanNoise = a2dB(mean(Y.MagSpecScramUp(:,ind))) - GNF;
ylim([MeanNoise-10 1.05*max(a2dB(Y.MagSpecUp(:))-GNF)]);
xlim([min(Y.freq) max(Y.freq)]);

%----crosscorr --
subplot(5,2,8);
hold on
if exist('rITD','var')
    if isfield(Y,'DiffRate')
        plot(1,1,'color',[1 1 1]);
        if isa(DS, 'EDFdataset')
            dplot(-[Y.dt Y.XIR_timeoffset], Y.nXIR);
        else
            dplot([Y.dt Y.XIR_timeoffset], Y.nXIR);
        end
        xplot(rITD, Y.PredDif,'k');
        xplot(rITD, Y.DiffRate, 'o', 'color', 'g', 'markerfacecolor', 'g', 'markersize', 4, 'LineStyle', '-','linewidth', 1);
        [yt xt] = max(Y.DiffRate);
        l = legend(['r=' num2str(Y.corco)]);
        set(l,'fontsize',8)
        legend boxoff
        %text(2*rITD(xt),0.9*yt,0.8,['r=' num2str(Y.corco)], 'fontsize',8);
        ylim([1.2*min([Y.nXIR' Y.DiffRate Y.PredDif]) 1.2*max([Y.nXIR' Y.DiffRate Y.PredDif])]);
    else
        dplot([Y.dt Y.XIR_timeoffset], Y.XIR);
    end
    xlim([min(rITD) max(rITD)]);
    xlabel('delay L vs R (ms)');
    if isfield(Y,'BD')
        Str = strvcat(['BD: ' num2str(Y.BD) 'ms']);
        text(0.05,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);
    end
end

% ----phase spec-------
subplot(5,2,9);
hold on
if ~isempty(Y.Filter.DF)
    comp_delay1 = Y.Filter.Phase.fit.Ph1(1,:)*Param.cdelay;
    comp_delay2 = Y.Filter.Phase.fit.Ph2(1,:)*Param.cdelay;
    plot(Y.Filter.Phase.fit.Ph1(1,:), Y.Filter.Phase.fit.Ph1(2,:) + comp_delay1 ,'b--')
    plot(Y.Filter.Phase.fit.Ph2(1,:), Y.Filter.Phase.fit.Ph2(2,:) + comp_delay2,'g--')
    l = legend([num2str(round(Y.Filter.Phase.fit.slope(1)*100)/100) 'ms'], [num2str(round(Y.Filter.Phase.fit.slope(2)*100)/100) 'ms']);
    set(l,'fontsize',8)
    legend boxoff
end
comp_delay = + Y.freq*Param.cdelay;
plot(Y.freq, Y.PhaseSpec(:,1) + comp_delay ,'b');
plot(Y.freq, Y.PhaseSpec(:,2) + comp_delay,'g');
xlim([min(Y.freq) max(Y.freq)]);
xlim([0 1])
xlabel('Frequency (kHz)')
ylabel('Phase (cycle)');

% ----difcor spec-------
subplot(5,2,10);
hold on
%plot(Y.DiffCorSpecFreq,Y.nXIRMagSpec)
plot(Y.DiffCorSpecFreq/1e3,Y.PredDifMagSpec,'b')
plot(Y.DiffCorSpecFreq/1e3,Y.DiffRateMagSpec,'g')
Str = strvcat(['predicted DF = ' num2str(round(Y.DFpredictedDifcor*1e3)) ' Hz'],['DF = ' num2str(round(Y.DFdifcor*1e3)) ' Hz']);
l = legend('Predicted Difcor Mag Spec','Difcor Mag Spec');
set(l,'fontsize',8)
legend boxoff
text(0.05,0.8, Str, 'units', 'normalized', 'horizontalalign', 'left', 'VerticalAlignment', 'middle', 'fontsize', 8);
xlabel('Frequency (kHz)')
ylabel('Power')

figure(FigHdl)

%----------------------------------------------------
function [Line,LineParam] = regline(x,y,xrange)

% REGLINE - Use linear regression to fit a line to data points
%   [LINE,LINEPARAM] = REGLINE(X,Y) - uses linear regression to
%   fit a LINE to the data points given by X and Y. LINEPARAM
%   contains the gradient (.grad), y-intercept (.yintercept),
%   p-value (.p) and r-squared (.rsq) value of the LINE.
%   Example:
%   x = [1:10];
%   y = x+rand(1,10);
%   [line,lineparam] = regline(x,y);
%   figure; hold on
%   plot(x,y,'o')
%   plot(line(1,:),line(2,:))
%   textstring{1} = ['r^{2} = ' num2str(round(lineparam.rsq*100)/100)];
%   textstring{2} = ['p = ' num2str(round(lineparam.p*10000)/10000)];
%   textstring{3} = ['y = ' num2str(round(lineparam.grad*1000)/1000) 'x + ' num2str(round(lineparam.yintercept*100)/100)];
%   text(max(x)/2,max(y)/2,textstring)


% MMCL 11/08/2007

% format and check data
if min(size(x))>1
    error('x data must be a vector')
end
if min(size(y))>1
    error('y data must be a vector')
end
if length(x)~=length(y)
    error('x and y data must be the same length')
end
y = reshape(y,length(y),1);
x = reshape(x,length(x),1);

% fit line
% regress doesn't work in matlab 6 - only matlab 7
% [b,bint,r,rint,stats] = regress(y,[ones(length(x),1),x]);
% yintercept = b(1);
% grad = b(2);
% rsq = stats(1);
% p = stats(3);

% works in both matlab 6 and 7
b = polyfit(x,y,1);
yintercept = b(2);
grad = b(1);
rsq = NaN;
p = NaN;

LineParam = collectinstruct(yintercept,grad,rsq,p);

% make line
Npoints = 100;
if nargin<3
    xrange = [min(x) max(x)];
end
xstep = (xrange(2) - xrange(1))/(Npoints-1);
xval = xrange(1):xstep:xrange(2);
yval = grad*xval + yintercept;
Line(1,:) = xval;
Line(2,:) = yval;

%-------------------------------------------------------------
function [index,index2] = match(a,b)

% MATCH - Return an index of matching numbers
%   IND = MATCH(A,B) - where A and B are numeric vectors
%   MATCH returns an index IND into A of numbers which
%   appear in both A and B
%
%   [IND IND2] = MATCH(A,B) - where index IND2 is and index into Bof numbers which
%   appear in both A and B

% MMCL 28/03/2007

% make both vectors horizontal
sizea = size(a);
if sizea(1)~=1
    a = a';
end

sizeb = size(b);
if sizeb(1)~=1
    b = b';
end

% find matching numbers
index = same([a b]);
index = index(1:2:end);

% repeat with a and b switched
index2 = same([b a]);
index2 = index2(1:2:end);

%-------------------------------------------------------------
function [indexa,indexb] = overlap(a,b)

% OVERLAP - Return an index of overlapping numbers
%   [IND1 IND2] = OVERLAP(A,B) - where A and B are numeric ascending vectors
%   OVERLAP returns an index IND1 into A of numbers which numerically
%   overlap in both A and B. IND2
%

% MMCL 03/11/2008

% get starting index
if min(a)>min(b) % start at min(a)
    startinda = 1;
    [dum startindb] = min(abs(b - a(1)));
elseif min(b)>min(a)  % start at min(b)
    [dum startinda] = min(abs(a - b(1)));
    startindb = 1;
elseif min(a) == min(b)
    startinda = 1;
    startindb = 1;
end

% get ending index
if max(a)>max(b) % end at max(b)
    [dum endinda] = min(abs(a - b(end)));
    endindb = length(b);
elseif max(b)>max(a)  % end at max(a)
    endinda = length(a);
    [dum endindb] = min(abs(b - a(end)));
elseif max(a) == max(b)
    endinda = length(a);
    endindb = length(b);
end

indexa = startinda:endinda;
indexb = startindb:endindb;

%--------------------------------------------------------------------------------------------------
function SpkOut = ScrambleSpkTr(SpkIn)
% shuffle spike train by randomizing the ISI's
NInt = length(SpkIn);
D = diff([0 sort(SpkIn)]); % first sort to make sure diff gives the ISI's
SpkOut = cumsum(D(randperm(NInt)));

%--------------------------------------------------------------------------------------------------
function [xp,yp,index] = funintersect(x,y1,y2);

%FUNINTERSECT gets intersection points of two functions
%   [Xp, Yp, Ind] = FUNINTERSECT(X, Y1, Y2) gets intersection points of functions Y1 with Y2 having common x-values X.
%   Y1 must have a maximum and be greater than Y2, and only the two intersection points closest to the maximum are given.
%   If no interesection points are given the end points are returned.

%MMCL 14-05-2009

% find max and split functions in two
[valdif maxind] = max(y1-y2); % find biggest difference between y1 and y2
if valdif<0
    index = [NaN NaN];
    xp = [NaN NaN];
    yp = [NaN NaN];
else
    y1up = y1(maxind:end);
    y2up = y2(maxind:end);
    y1down = y1(1:maxind-1);
    y2down = y2(1:maxind-1);

    % find intersection points
    inddown = find(y1down(1:end-1)<y2down((1:end-1)) & y1down(2:end)>=y2down((2:end)));
    if isempty(inddown)
        index(1) = 1;
    else
        index(1) = inddown(end);
    end
    indup = find(y1up(1:end-1)>=y2up((1:end-1)) & y1up(2:end)<y2up((2:end)));
    if isempty(indup)
        index(2) = length(y1);
    else
        index(2) = maxind+indup(1);
    end

    % check if point is really the closests
    mval = mean(y2(index(1):index(1)+1));
    stay = abs(y1(index(1))-mval);
    shift = abs(y1(index(1)+1)-mval);
    if shift<stay
        index(1) = index(1)+1;
    end
    mval = mean(y2(index(2)-1:index(2)));
    stay = abs(y1(index(2))-mval);
    shift = abs(y1(index(2)-1)-mval);
    if shift<stay
        index(2) = index(2)-1;
    end

    % get x and y vals
    xp = x(index);
    yp = y1(index);
end

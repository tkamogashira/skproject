function varargout = RevCorr(varargin);
%REVCORR            reverse correlation analysis.
%   [IR, time, Gain, Phase, freq] = REVCORR(ds, iSubSeq) calculates the reverse
%   correlation for the given subsequence of the supplied dataset ds. The impulse
%   response (vectors IR and time), magnitude (vectors freq and Gain) and phase
%   (vectors freq and Phase) is returned.
%   S = REVCORR(ds, iSubSeq) returns the results as a structure array S. Multiple
%   subsequences of the same dataset can be evaluated at once by supplying a vector
%   for the subsequences.
%
%   E.g.:
%       ds = dataset('R00001', 410);
%       S = revcorr(ds, 1);
%       S = revcorr(ds, 1:ds.nrec, 'poolsubseqs', 'yes')
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view a list of all possible properties and their default values,
%   use 'factory' as only input argument.

%B. Van de Sande 08-08-2005
%??? spectana.m gebruiken ???
%??? check backward compatibility ???

%---------------------------------template-----------------------------------
Template.ds.filename    = '';        %Datafile name for dataset
Template.ds.icell       = NaN;       %Cell number of dataset
Template.ds.iseq        = NaN;       %Sequence number of dataset
Template.ds.seqid       = '';        %Identifier of dataset
Template.ds.isubseq     = NaN;       %Subsequence number
Template.tag            = 0;         %General purpose tag field
Template.createdby      = mfilename; %Name of MATLAB function that generated the data
Template.revcorr.time   = NaN;       %Time in ms
Template.revcorr.ir     = NaN;       %Impulse response for all channels
Template.revcorr.ir1    = NaN;       %Impulse response for first channel
Template.revcorr.ir2    = NaN;       %Impulse response for second channel
Template.fft.freq       = NaN;       %Frequency in kHz
Template.fft.gain1      = NaN;       %Gain for first channel
Template.fft.gain2      = NaN;       %Gain for second channel
Template.fft.phase1     = NaN;       %Phase for first channel
Template.fft.phase2     = NaN;       %Phase for second channel
Template.thr.cf         = NaN;       %Characteristic frequency retrieved from threshold curve
Template.thr.sr         = NaN;       %Spontaneous rate retrieved from threshold curve
Template.thr.thr        = NaN;       %Threshold at characteristic frequency
Template.thr.q10        = NaN;       %Q10 retrieved from threshold curve
Template.thr.bw         = NaN;       %Width 10dB above threshold (Hz)

%-------------------------------default parameters---------------------------
%Calculation parameters ...
DefParam.poolsubseqs = 'no';    %'yes' or 'no' ...
DefParam.maxwin      = 20;      %Width of time window in ms ...
DefParam.runav       = 0;       %Running-average window in ms ...
%Spectrum analysis: 'yes' or 'no' ...
if (nargout == 2), DefParam.fftana = 'no'; else, DefParam.fftana = 'yes'; end
DefParam.cdelay      = 0;       %Compensating delay in ms in spectrum ...
DefParam.maxfreq     = 5;       %Maximum frequency in kHz in spectrum ...
%Plotting parameters ...
DefParam.plot        = 'yes';   %'yes' or 'no' ...

%----------------------------------main program------------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); disp(DefParam);
    return;
else, [ds, iSubSeq, Info, Param] = ParseArgs(DefParam, varargin{:}); end

%Retrieving data from SGSR server ...
try,
    UD = getuserdata(ds.filename, ds.icell); if isempty(UD), error('To catch block ...'); end
    %Threshold curve information ...
    if ~isempty(UD.CellInfo) & ~isnan(UD.CellInfo.THRSeq),
        dsTHR = dataset(ds.filename, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        s = sprintf('Threshold curve:');
        s = strvcat(s, sprintf('%s <%s>', dsTHR.FileName, dsTHR.seqID));
        s = strvcat(s, sprintf('CF = %s @ %s', Param2Str(CF, 'Hz', 0), Param2Str(Thr, 'dB', 0)));
        s = strvcat(s, sprintf('SR = %s', Param2Str(SR, 'spk/sec', 1)));
        s = strvcat(s, sprintf('BW = %s', Param2Str(BW, 'Hz', 1)));
        s = strvcat(s, sprintf('Q10 = %s', Param2Str(Q10, '', 1)));
        Str = s;
        Thr = lowerfields(CollectInStruct(CF, SR, Thr, BW, Q10, Str));
    else, Thr = struct([]); end   
catch, 
    warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr)); 
    Thr = struct([]);
end

%Multiple subsequences are handled with recursion ...
NSubSeqs = prod(size(iSubSeq));
if (NSubSeqs > 1),
    if strcmpi(Param.poolsubseqs, 'yes'),
        for n = 1:NSubSeqs,
            S(n) = revcorr(ds, iSubSeq(n), 'poolsubseqs', 'no', 'fftana', 'no', ...
                'plot', 'no', 'maxwin', Param.maxwin, 'runav', Param.runav);
        end
        %Pooling IRs ...
        [Data, FNames] = destruct(S);
        Nchan = unique(cellfun('size', Data(:, find(ismember(FNames, 'revcorr.ir'))), 2));
        if (length(Nchan) ~= 1), error('Subsequences don''t use same number of channels.'); end
        Time = Data(:, find(ismember(FNames, 'revcorr.time'))); Time = unique(cat(1, Time{:}));
        Nwin = length(Time);
        IR = zeros(Nwin, NSubSeqs); PooledIR = zeros(Nwin, Nchan);
        for ChanNr = 1:Nchan,
            for i = 1:NSubSeqs, IR(:, i) = interp1(S(i).revcorr.time, S(i).revcorr.ir(:, ChanNr), Time); end
            PooledIR(:, ChanNr) = mean(IR, 2); 
        end
        
        %Adding information to structure-array ...
        CalcData.revcorr.time = Time;
        CalcData.revcorr.ir   = PooledIR;
        CalcData.revcorr.ir1 = PooledIR(:, 1);
        if (Nchan == 2), CalcData.revcorr.ir2 = PooledIR(:, 2);
        else, CalcData.revcorr.ir2 = repmat(NaN, Nwin, 1); end

        %Compute spectrum if requested ...
        if strcmpi(Param.fftana, 'yes') | (nargout == 5), CalcData.fft = CalcSpectrum(Time, PooledIR, Param); end
        
        %Plotting data if requested ...
        if strcmpi(Param.plot, 'yes'), MakeFigure(Info, Thr, Param, CalcData); end
        
        %Return data if requested ...
        if (nargout == 1),
            CalcData.ds = Info; CalcData.thr = Thr;
            varargout{1} = structtemplate(CalcData, Template, 'reduction', 'off');
        elseif (nargout == 2),
            [varargout{1:2}] = deal(CalcData.revcorr.ir, CalcData.revcorr.time);
        elseif (nargout == 5),
            [varargout{1:5}] = deal(CalcData.revcorr.ir, CalcData.revcorr.time, CalcData.fft.gain, ...
                CalcData.fft.phase, CalcData.fft.freq);
        end
    else,
        for n = 1:NSubSeqs, S(n) = revcorr(ds, iSubSeq(n), Param); end
        %Return data if requested ...
        if (nargout == 1), varargout{1} = S;
        elseif (nargout > 1), error('Wrong number of output arguments.'); end
    end
    return;
end    

%Get stimulus waveform ...
[y, PbPer] = GetStimSamples(ds, iSubSeq);
NSamples = size(y, 1); Nchan = size(y, 2);
Nwin = round(Param.maxwin*1e3/PbPer); %Conversion from ms->us->samples ...
Nav  = round(Param.runav*1e3/PbPer);  %Conversion from ms->us->samples ...

%Get spiketimes of requested subsequence, pooled over repetitions ...
SpkTimes = ds.spt; SpkTimes = cat(2, SpkTimes{iSubSeq, :})';
NSpikes = length(SpkTimes);

%Construct binary spike signal at correct sample rate ...
TimeEdges = (0:NSamples)*PbPer*1e-3; %Binning edges in ms ...
if isempty(SpkTimes), SpkTimes = Inf; end
BinnedSpikes = histc(SpkTimes, TimeEdges);

%Account for ITD in stimulus playback. This is only necessary for Madison datasets, 
%because for SGSR datasets the ITD is already taken care of in the waveforms returned
%by GETSTIMSAMPLES.M.  For Madison datasets the ITD is not enforced by shifting the
%waveforms, but by taking another part of the IR ...
if isa(ds, 'EDFdataset'),
    [M, N] = size(ds.Stimulus.StimParam.Delay); NSub = ds.nsub;
    MasterDelay = repmat(ds.Stimulus.StimParam.Delay, NSub-M+1, Nchan-N+1);
    NShift = round(MasterDelay(iSubSeq, 1:Nchan)/PbPer);
    ExtraN = max([0, NShift]);
else, NShift = zeros(1, Nchan); ExtraN = 0; end
IR = zeros(Nwin, Nchan); %Pre-allocation of impulse response ...
for n = 1:Nchan,
    xc = runav(flipud(xcorr(y(:, n), BinnedSpikes, Nwin+ExtraN)/NSpikes), Nav);
    IR(:, n) = xc((1:Nwin)+(Nwin+ExtraN+1)+NShift(n));
end
Time = TimeEdges(1:Nwin)';

%Adding information to structure-array ...
CalcData.revcorr.time = Time;
CalcData.revcorr.ir   = IR;
CalcData.revcorr.ir1 = IR(:, 1);
if (Nchan == 2), CalcData.revcorr.ir2  = IR(:, 2);
else, CalcData.revcorr.ir2 = repmat(NaN, Nwin, 1); end

%Compute spectrum if requested ...
if strcmpi(Param.fftana, 'yes') | (nargout == 5), CalcData.fft = CalcSpectrum(Time, IR, Param); end

%Plotting data if requested ...
if strcmpi(Param.plot, 'yes'), MakeFigure(Info, Thr, Param, CalcData); end

%Return data if requested ...
if (nargout == 1),
    CalcData.ds = Info; CalcData.thr = Thr;
    varargout{1} = structtemplate(CalcData, Template, 'reduction', 'off');
elseif (nargout == 2),
    [varargout{1:2}] = deal(CalcData.revcorr.ir, CalcData.revcorr.time);
elseif (nargout == 5),
    [varargout{1:5}] = deal(CalcData.revcorr.ir, CalcData.revcorr.time, CalcData.fft.gain, ...
        CalcData.fft.phase, CalcData.fft.freq);
end

%-------------------------------local functions------------------------------
function [ds, iSubSeq, Info, Param] = ParseArgs(DefParam, varargin)

%Checking mandatory parameters ...
if (nargin < 2), error('Wrong number of input arguments.'); end
if ~any(strcmpi(class(varargin{1}), {'dataset', 'EDFdataset'})), error('First argument should be dataset.'); end
ds = varargin{1};
if ~isnumeric(varargin{2}) | (length(varargin{2}) == 0) | ~all(ismember(varargin{2}, 1:ds.nrec)), 
    error('Second argument should be valid subsequence number for supplied dataset.'); 
end
iSubSeq = varargin{2};

%Collecting information on dataset ...
Info.filename = ds.filename;
Info.icell    = ds.icell;
Info.iseq     = ds.iseq;
Info.seqid    = ds.seqid;
Info.isubseq  = iSubSeq;
[CellNr, TestNr] = unraveldsID(Info.seqid);
Info.idstr    = sprintf('%s <%d-%d> @ #%s', Info.filename, CellNr, TestNr, RAPRange2Str(iSubSeq));

%Checking properties and their values ...
Param = CheckPropList(DefParam, varargin{3:end});
CheckParam(Param);

%Format parameter information ...
s = sprintf('MaxWin = %s', Param2Str(Param.maxwin, 'ms', 2));
s = strvcat(s, sprintf('RunAv = %s', Param2Str(Param.runav, 'ms', 2)));
s = strvcat(s, sprintf('Cdelay = %s', Param2Str(Param.cdelay, '', 2)));
s = strvcat(s, sprintf('MaxFreq = %s', Param2Str(Param.maxfreq, 'kHz', 2)));
Param.str = s;

%----------------------------------------------------------------------------
function CheckParam(Param)

if ~isnumeric(Param.maxwin) | (length(Param.maxwin) ~= 1) | (Param.maxwin <= 0), error('Invalid value for property ''maxwin''.'); end
if ~isnumeric(Param.runav) | (length(Param.runav) ~= 1) | (Param.runav < 0), error('Invalid value for property ''runav''.'); end
if ~any(strcmpi(Param.fftana, {'yes', 'no'})), error('Property ''fftana'' must be ''yes'' or ''no''.'); end
if ~isnumeric(Param.cdelay) | (length(Param.cdelay) ~= 1) | (Param.cdelay < 0), error('Invalid value for property ''cdelay''.'); end
if ~isnumeric(Param.maxfreq) | (length(Param.maxfreq) ~= 1) | (Param.maxfreq <= 0), error('Invalid value for property ''maxfreq''.'); end
if ~any(strcmpi(Param.plot, {'yes', 'no'})), error('Property ''plot'' must be ''yes'' or ''no''.'); end
if ~any(strcmpi(Param.poolsubseqs, {'yes', 'no'})), error('Property ''poolsubseqs'' must be ''yes'' or ''no''.'); end

%----------------------------------------------------------------------------
function Str = Param2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) | all(isequal(C{:})), Str = sprintf([int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2), Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], V(1), Unit, V(2), Unit);
elseif any(Sz == 1), 
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], min(V(:)), Unit, max(V(:)), Unit); 
else, 
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), Unit, max(V(:, 2)), Unit); 
end

%----------------------------------------------------------------------------
function S = CalcSpectrum(Time, IR, Param)

Nchan = size(IR, 2); Nwin = size(IR, 1);
Dur = max(Time)-min(Time)+diff(Time(1:2)); %Duration of impulse response in ms ...
df = 1/Dur; %Freq spacing in kHz ...
NPosSamples = floor(Param.maxfreq/df);
for n = 1:Nchan, Spec(:, n) = IR(:, n).*hann(Nwin); end
Spec = fft(Spec); Spec = Spec(1:NPosSamples, :); %Keep positive frequencies only ...
Gain = a2db(abs(Spec)); Gain = Gain-repmat(max(Gain), NPosSamples, 1);
Freq = ((0:NPosSamples-1)*df)';
%unwrap, advance and add int#cycles towards zero ...
effDelay = Param.cdelay; %+Param.maxwin/2 **MH why including the window? delay should be true stim-to-response delay
for n = 1:Nchan, 
   Phase(:, n) = delayphase(angle(Spec(:, n))/2/pi, Freq, effDelay, 2); 
end
%Adding information to structure-array ...
S = lowerfields(CollectInStruct(Freq, Gain, Phase));
S.gain1 = Gain(:, 1);
if (Nchan == 2), S.gain2 = Gain(:, 2); else, S.gain2 = repmat(NaN, Nwin, 1); end    
S.phase1 = Phase(:, 1);
if (Nchan == 2), S.phase2 = Phase(:, 2); else, S.phase2 = repmat(NaN, Nwin, 1); end    

%----------------------------------------------------------------------------
function MakeFigure(Info, Thr, Param, CalcData)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s', upper(mfilename), upper(Info.idstr)), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'portrait');

%Plotting curves ...
AxIR = subplot(2, 2, 1);
Hdl = plot(CalcData.revcorr.time, CalcData.revcorr.ir);
set(AxIR, 'Box', 'off', 'TickDir', 'out');
xlabel('Time (ms)'); ylabel('IR'); 
if (length(Hdl) == 2), legend(Hdl, {'Left Channel', 'Right Channel'}); end
if strcmpi(Param.fftana, 'yes'), 
    AxGain = subplot(2, 2, 3);
    PMSK = pmask(CalcData.fft.freq>0); % omit usesless DC comp
    plot(CalcData.fft.freq+PMSK, CalcData.fft.gain);
    set(AxGain, 'Box', 'off', 'TickDir', 'out');
    xlabel('Freq. (kHz)'); ylabel('Gain');
    AxPhase = subplot(2, 2, 4);
    plot(CalcData.fft.freq+PMSK, CalcData.fft.phase);
    set(AxPhase, 'Box', 'off', 'TickDir', 'out');
    xlabel('Freq. (kHz)'); ylabel('Phase');
else,
    CreateEmptyAxis(subplot(2, 2, 3));
    CreateEmptyAxis(subplot(2, 2, 4));
end

%Plotting information ...
AxParam = subplotplus(2, 2, 2); set(AxParam, 'Visible', 'off');
text(0.5, 0.75, Param.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
if ~isempty(Thr)
    text(0.5, 0.25, Thr.str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
end

%Plot header ...
Str = { upper(Info.idstr), sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))};
AxHDR = axes('Position', [0.40 0.90 0.15 0.10], 'Visible', 'off');
text(0.5, 0.5, Str, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 12);

%----------------------------------------------------------------------------
function CreateEmptyAxis(AxHdl)

%Create axis object ... 
set(AxHdl, 'Box', 'on', 'Color', [0.8 0.8 0.8], 'Units', 'normalized', ...
    'YTick', [], 'YTickLabel', [], 'XTick', [], 'XTickLabel', []);

%Create Text object ...
TxtHdl = text(0.5, 0.5, sprintf('No plot to be\ngenerated'));
set(TxtHdl, 'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'center', ...
             'Color', 'k', ...
             'FontAngle', 'normal', ...
             'FontSize', 12, ...
             'FontWeight', 'normal');

%----------------------------------------------------------------------------
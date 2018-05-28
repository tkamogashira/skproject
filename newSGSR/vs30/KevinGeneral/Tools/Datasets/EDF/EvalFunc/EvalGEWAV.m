function varargout = EvalGEWAV(GEWAVds, varargin)
%EVALGEWAV  evaluate general waveform dataset
%   EVALGEWAV(GEWAVds) displays general waveform in time and frequency
%   domain.
%
%   NoiseBW = EVALGEWAV(GEWAVds) also returns the noise bandwidth as a
%   two element vector.
%
%   [EffSPL, NoiseBW] = EVALGEWAV(GEWAVds, CALIBds) also calculates and 
%   returns the overall effective spl.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   All calculations are cached. To clear the current cache use 'clrcache' 
%   as only input argument.

%B. Van de Sande 15-06-2004

%Default parameters ...
DefParam.verbose  = 'yes';       %'yes' or 'no' ...
DefParam.plot     = 'yes';       %'yes' or 'no' ...
DefParam.cache    = 'yes';       %'yes' or 'no' ...
DefParam.nharm    = 1;           %harmonic number for calibration data ...
DefParam.numprec  = 5e1;         %numerical precision for noise bandwidth ...
DefParam.filtercf = [];          %center frequency used for effective spl 
                                 %computation ...
DefParam.filterbw = [];          %bandwidth of filter used for effective spl 
                                 %computation ...
%When supplying a center frequency then the bandwidth of the filter must
%also be given in octaves as a numerical scalar.
%The bandwidth of the filter can also be given as a two-element vector
%with the onset and offset in Hz. If the bandwidth is supplied in this
%way, a center frequecny cannot be given.
%When no center frequency, nor a bandwidth is supplied then the bandwidth
%of the general waveform is estimated and the overall effective SPL is 
%computed.

%Checking input arguments ...
if (nargin < 1),
    error('Wrong number of input arguments.');
elseif (nargin == 1) & ischar(GEWAVds) & strcmpi(GEWAVds, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin == 1) & ischar(GEWAVds) & strcmpi(GEWAVds, 'clrcache'),
    emptycachefile(mfilename);
    return;
elseif ~isa(GEWAVds, 'dataset') | ~strcmpi(GEWAVds.ID.FileFormat, 'EDF') | ~strcmpi(GEWAVds.SchData.SchName, 'SCH005'), 
    error('First argument should be an EDF dataset containing a general waveform.');
end

if (nargin >= 2) & isa(varargin{1}, 'dataset'), 
    CALIBds = varargin{1};
    if ~strcmpi(CALIBds.ID.FileFormat, 'EDF') | ~strcmpi(CALIBds.SchData.SchName, 'CALIB'), 
        error('Second dataset should be an EDF dataset containing calibration data.');
    end    
    Pidx = 2;
else, CALIBds = []; Pidx = 1; end

Param = checkproplist(DefParam, varargin{Pidx:end});
CheckParam(Param);

%Calculating data ...
if isempty(CALIBds), %When no effective SPL computation is requested, no caching is done ...
    FFT    = CalcFFT(GEWAVds, Param);
    EffSPL = NaN;
    
    CalcData = CollectInStruct(FFT, EffSPL);
else, %Caching is only done when requested ...
    SearchParam = structcat( ...
        struct('gewavfilename', GEWAVds.filename, 'gewaviseq', GEWAVds.iseq, 'calibfilename', CALIBds.filename, 'calibiseq',  CALIBds.iseq), ...
        getfields(Param, {'numprec', 'filtercf', 'filterbw'})); %Calculation parameters ...
    CalcData = FromCacheFile(mfilename, SearchParam);
    if strcmpi(Param.cache, 'yes') & ~isempty(CalcData),
        if strcmpi(Param.verbose, 'yes'), fprintf('Data retrieved from cache ...\n'); end
    else, 
        FFT    = CalcFFT(GEWAVds, Param);
        EffSPL = CalcEffSPL(FFT, CALIBds, Param);
        
        CalcData = CollectInStruct(FFT, EffSPL);
        if strcmpi(Param.cache, 'yes'), ToCacheFile(mfilename, +1024, SearchParam, CalcData); end
    end
end

%Display of calculated data ...
if strcmpi(Param.plot, 'yes'), 
    Info = AssembleInfo(GEWAVds, CALIBds, Param, CalcData);
    DisplayData(Info, GEWAVds, CALIBds, CalcData, Param); 
end

%Returning output parameters ...
if (isempty(CALIBds) & (nargout > 1)) | (nargout > 2), error('Wrong number of output arguments.');
elseif isempty(CALIBds) & (nargout == 1), varargout{1} = CalcData.FFT.NoiseBW;
elseif ~isempty(CALIBds) & (nargout == 1), varargout{1} = CalcData.EffSPL;
elseif ~isempty(CALIBds) & (nargout == 2), [varargout{1:2}] = deal(CalcData.EffSPL, CalcData.FFT.NoiseBW); end

%----------------------------local functions-----------------------
function CheckParam(Param)

if ~ischar(Param.verbose) | ~any(strcmpi(Param.verbose, {'yes', 'no'})),
    error('Property verbose should be ''yes'' or ''no''.');
end
if ~ischar(Param.plot) | ~any(strcmpi(Param.plot, {'yes', 'no'})),
    error('Property plot should be ''yes'' or ''no''.');
end
if ~ischar(Param.cache) | ~any(strcmpi(Param.cache, {'yes', 'no'})),
    error('Property cache should be ''yes'' or ''no''.');
end
if ~isnumeric(Param.nharm) | (length(Param.nharm) ~= 1) | (Param.nharm < 0),
    error('Invalid value for property nharm.');
end
if ~isnumeric(Param.numprec) | (length(Param.numprec) ~= 1) | (Param.numprec <= 0),
    error('Invalid value for property numprec.');
end
if ~isnumeric(Param.filtercf) | ~any(length(Param.filtercf) == [0, 1]) | (Param.filtercf < 0),
    error('Invalid value for property filtercf.');
end
if ~isnumeric(Param.filterbw) | ~any(length(Param.filterbw) == 0:2) | any(Param.filterbw < 0) | ...
        (diff(Param.filterbw) < 0),
    error('Invalid value for property filterbw.');
end

%Check for inconsistencies in filter properties ...
if (~isempty(Param.filtercf) & ((length(Param.filterbw) == 2) | isempty(Param.filterbw))) | ...
        ((length(Param.filterbw) == 1) & ~isempty(Param.filterbw) & isnan(Param.filtercf)),
    error('Filter properties are inconsistent.');
end

%------------------------------------------------------------------
function FFT = CalcFFT(GEWAVds, Param)

Time      = GEWAVds.Data.OtherData.WaveForm.time; %In microsecs ...
Amplitude = GEWAVds.Data.OtherData.WaveForm.amplitude;

N = length(Time); 
dt = GEWAVds.PbPer; Tmax = 1e3*GEWAVds.BurstDur;
NSamples = 2^nextpow2(N);

%Resampling data to next power of two using linear interpolation ...
TimeR      = linspace(dt/2, Tmax-dt/2, NSamples);
AmplitudeR = interp1(Time, Amplitude, TimeR, 'linear');

%Discrete Fourier Transform ...
Amplitude = (2/NSamples)*abs(fft(AmplitudeR));
df = 1/(1e-6*Tmax); %Frequency in Hz ...
Freq = (0:length(Amplitude)-1) * df;

%Estimation of noise bandwidth ...
Threshold = 0.5*(max(Amplitude)-min(Amplitude));
idx = find(Amplitude(1:round(end/2)) > Threshold);
NoiseBW = Freq([min(idx), max(idx)]);
NoiseBW = round(NoiseBW/Param.numprec)*Param.numprec;

FFT = CollectInStruct(Freq, Amplitude, NoiseBW);

%------------------------------------------------------------------
function EffSPL = CalcEffSPL(FFT, CALIBds, Param)

%Extracting bandwidth of rectangular filter ...
BW = InterpretFilterParam(Param, FFT.NoiseBW);
idx = find((FFT.Freq >= BW(1)) & (FFT.Freq <= BW(2)));

CALIB = AssembleCALIB(CALIBds, Param);

%Extrapolation of calibration data if necessary ...
if (min(CALIB.Freq) > BW(1)),
    FreqInc = CALIB.Freq(2)-CALIB.Freq(1);
    Freqs = 0:FreqInc:(min(CALIB.Freq)-FreqInc); N = length(Freqs);
    CALIB.Freq = [Freqs, CALIB.Freq];
    CALIB.SPL  = [repmat(CALIB.SPL(1), 1, N), CALIB.SPL];
end
if (max(CALIB.Freq) < BW(2)),
    FreqInc = CALIB.Freq(2)-CALIB.Freq(1);
    Freqs = (CALIB.Freq(end)+FreqInc):FreqInc:BW(2); N = length(Freqs);
    CALIB.Freq = [CALIB.Freq, Freqs];
    CALIB.SPL  = [CALIB.SPL, repmat(CALIB.SPL(end), 1, N)];
end

%Effective SPL computation ...
Amax     = 2^15;
NoisedB  = 20*log10(Amax./FFT.Amplitude(idx));
CalibdB  = interp1(CALIB.Freq, CALIB.SPL, FFT.Freq(idx), 'linear');
CordB    = CalibdB-NoisedB;

EffSPL = 20*log10(sqrt(sum(10.^(CordB/10))));

%------------------------------------------------------------------
function BW = InterpretFilterParam(Param, NoiseBW)

%Calculate overall effective SPL ...
if isempty(Param.filtercf) & isempty(Param.filterbw),
    BW = NoiseBW;
%Calulate effective SPL using rectangular filter ...
elseif ~isempty(Param.filtercf),
    Oct   = 0.5*Param.filterbw;
    BW(1) = max([0, Param.filtercf*2^-Oct]);
    BW(2) = Param.filtercf*2^+Oct;
else, BW = Param.filterbw; end

if (BW(1) < NoiseBW(1)) | (BW(2) > NoiseBW(2)),
    warning('Requested filter bandwidth exceeds bandwidth of general waveform.');
end

%------------------------------------------------------------------
function CALIB = AssembleCALIB(CALIBds, Param)

if (Param.nharm > CALIBds.Stimulus.StimParam.Nharm), 
    error('Requested harmonic number doesn''t exist in calibration dataset.');
end

CALIB.Freq = CALIBds.indepval(:)';
CALIB.SPL  = CALIBds.Data.OtherData.calibCurve.magnitude(Param.nharm, :);

%------------------------------------------------------------------
function Info = AssembleInfo(GEWAVds, CALIBds, Param, CalcData)

Info.titlestr = {sprintf('\\bf\\fontsize{12}%s <%s>', GEWAVds.filename, GEWAVds.seqid)};
if ~isempty(CALIBds),
    Info.titlestr = [Info.titlestr; {sprintf('\\rm\\fontsize{9}Calibration data retrieved from %s <%s>', CALIBds.filename, CALIBds.seqid)}];
end
Info.titlestr = [Info.titlestr; {sprintf('\\rm\\fontsize{9}Created by %s @ %s', upper(mfilename), datestr(now))}];

Info.paramstr = {sprintf('\\bf\\fontsize{9}Eff. SPL computation:')};
if isempty(Param.filtercf) & isempty(Param.filterbw),
    Info.paramstr = [Info.paramstr; {sprintf('\\rm\\fontsize{9}Overall')}];
elseif ~isempty(Param.filtercf),
    Info.paramstr = [Info.paramstr; {sprintf('\\rm\\fontsize{9}Center Freq. = %d (Hz)', Param.filtercf); ...
            sprintf('\\rm\\fontsize{9}BandWidth = %.2f (Oct)', Param.filterbw)}];
else, 
    Info.paramstr = [Info.paramstr; {sprintf('\\rm\\fontsize{9}Filter BandWidth = [%d %d] (Hz)', Param.filterbw)}];
end

Info.calcstr = {sprintf('\\bf\\fontsize{9}Calculated data:'); ...
        sprintf('\\rm\\fontsize{9}Noise BandWidth = [%d %d](Hz)', CalcData.FFT.NoiseBW); ...
        sprintf('\\rm\\fontsize{9}Eff. SPL = %.0f (dB)', CalcData.EffSPL)};

%------------------------------------------------------------------
function DisplayData(Info, GEWAVds, CALIBds, CalcData, Param)

%Creating figure ...
FigHdl = figure('Name', sprintf('%s: %s <%s>', upper(mfilename), GEWAVds.filename, GEWAVds.seqid), ...
    'NumberTitle', 'off', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0.025 1 0.975], ... %Maximize figure (not in the MS Windows style!) ...
    'PaperType', 'A4', ...
    'PaperPositionMode', 'manual', ...
    'PaperUnits', 'normalized', ...
    'PaperPosition', [0.05 0.05 0.90 0.90], ...
    'PaperOrientation', 'landscape');

if isempty(CALIBds),
    Ax_INFO = axes('Position', [0.05 0.85 0.90 0.10], 'visible', 'off');
    text(1/2, 1/2, Info.titlestr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');

    Ax_WAVE = axes('Position', [0.10 0.10 0.35 0.7], 'box', 'on', 'xgrid', 'on', 'ygrid', 'on');
    line(GEWAVds.Data.OtherData.WaveForm.time, GEWAVds.Data.OtherData.WaveForm.amplitude, 'linestyle', '-', ...
        'marker', 'none', 'color', 'b');
    title('Time Domain', 'fontsize', 12);
    xlabel('Time (\mus)', 'interpreter', 'tex');
    ylabel('Amplitude'); ylim([-2^15-1, +2^15]);

    Ax_FFT = axes('Position', [0.55 0.10 0.35 0.7], 'box', 'on');
    line(CalcData.FFT.Freq, CalcData.FFT.Amplitude, 'linestyle', '-', 'marker', 'none', 'color', 'b');
    title('Frequency Domain', 'fontsize', 12);
    xlabel('Frequency (Hz)'); xlim([0 max(CalcData.FFT.Freq)/2]);
    ylabel('Amplitude');
else,
    Ax_INFO = axes('Position', [0.10 0.55 0.35 0.35], 'visible', 'off');
    text(1/2, 2/3+1/6, Info.titlestr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
    text(0, 2/6, Info.paramstr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
    text(1/2, 2/6, Info.calcstr, 'Units', 'normalized', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');

    Ax_WAVE = axes('Position', [0.10 0.10 0.35 0.35], 'box', 'on', 'xgrid', 'on', 'ygrid', 'on');
    line(GEWAVds.Data.OtherData.WaveForm.time, GEWAVds.Data.OtherData.WaveForm.amplitude, 'linestyle', '-', ...
        'marker', 'none', 'color', 'b');
    title('Time Domain', 'fontsize', 12);
    xlabel('Time (\mus)', 'interpreter', 'tex');
    ylabel('Amplitude'); ylim([-2^15-1, +2^15]);
    
    BW = InterpretFilterParam(Param, CalcData.FFT.NoiseBW);
    
    Ax_FFT = axes('Position', [0.55 0.55 0.35 0.35], 'box', 'on');
    patch(BW([1 1 2 2]), [0 150 150 0], [0.6 0.6 0.6], 'edgecolor', [0.6 0.6 0.6]);
    line(CalcData.FFT.Freq, CalcData.FFT.Amplitude, 'linestyle', '-', 'marker', 'none', 'color', 'b');
    title('Frequency Domain', 'fontsize', 12);
    xlabel('Frequency (Hz)'); xlim([0 32000]);
    ylabel('Amplitude'); ylim([0 150]);
    
    Ax_CALIB = axes('Position', [0.55 0.10 0.35 0.35], 'box', 'on');
    patch(BW([1 1 2 2]), [0 140 140 0], [0.6 0.6 0.6], 'edgecolor', [0.6 0.6 0.6]);
    line(CALIBds.indepval(:)', CALIBds.Data.OtherData.calibCurve.magnitude(Param.nharm, :), 'linestyle', '-', ...
        'marker', 'none', 'color', 'b');
    title('Calibration Data', 'fontsize', 12);
    xlabel('Frequency (Hz)'); xlim([0 max(CalcData.FFT.Freq)/2]);
    ylabel('Amplitude (dB)');
end

%------------------------------------------------------------------
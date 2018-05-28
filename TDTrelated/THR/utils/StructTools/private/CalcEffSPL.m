function EffSPL = CalcEffSPL(ds, varargin)
%CALCEFFSPL calculate effective SPL for noise dataset
%   EffSPL = CALCEFFSPL(ds) calculates effective SPL for the given noise
%   dataset. If the dataset is binaural then the effective SPL corresponding
%   with the average power of both channels is returned.
%
%   The effective SPL is returned as a matrix with the number of rows defined
%   by the total number of subsequences and with the same number of columns as
%   active channels used in the collection of data, except when the average of
%   both playback channel is requested.
%
%   When a tone was administrated at a playback channel then the SPL of that
%   tone is returned for that playback channel.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 07-03-2005

%-------------------------------default parameters---------------------------
DefParam.channel  = 0;       %'master', 'slave', 'left', 'right', 1 or 2. Also
                             %'avg' or 0 and 'both' or -2 are possible ...
DefParam.nharm    = 1;       %harmonic number for calibration data (EDF only) ...
DefParam.numprec  = 5e1;     %numerical precision for noise bandwidth (E DF only) ...
DefParam.calibds  = [];      %calibration dataset (EDF only) ...
DefParam.filtercf = [];      %center frequency used for effective spl 
                             %computation ...
DefParam.filterbw = [];      %bandwidth of filter used for effective spl 
                             %computation ...
%When supplying a center frequency then the bandwidth of the filter must
%also be given in octaves as a numerical scalar.
%The bandwidth of the filter can also be given as a two-element vector
%with the onset and offset in Hz. If the bandwidth is supplied in this
%way, a center frequency cannot be given.
%When no center frequency, nor a bandwidth is supplied then the bandwidth
%of the general waveform is estimated and the overall effective SPL is 
%computed.

%----------------------------------main program------------------------------
%Checking input arguments ...
if (nargin < 1),
    error('Wrong number of input arguments.');
elseif (nargin == 1) & ischar(ds) & strcmpi(ds, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
elseif ~isa(ds, 'dataset'), error('First argument should be a dataset.'); end

Param = CheckPropList(DefParam, varargin{:});
Param = CheckParam(Param);

%Calculation is different for SGSR or Madison dataset ...
FileFormat = ds.fileformat;
if strcmpi(FileFormat, 'EDF'), 
    Nchan = ds.dssnr; if (Nchan ~= 0), EffSPL = CalcEDF(ds, Param); 
    else, error('Dataset doesn''t contain spiketime data.'); end
else, 
    Nchan = 2 - sign(ds.Special.ActiveChan); if ~isnan(Nchan), EffSPL = CalcSGSR(ds, Param);
    else, error('Dataset doesn''t contain spiketime data.'); end
end

%Returning the requested effective SPL ...
if any(Param.channel == [-2, 2]) & (Nchan ~= 2), error('Only one playback channel used for dataset.'); end
switch Param.channel
case 1, EffSPL = EffSPL(:, 1);
case 2, EffSPL = EffSPL(:, 2);
case 0, EffSPL = CombineSPLs(EffSPL); end

%------------------------------local functions-------------------------------
function Param = CheckParam(Param)

if ischar(Param.channel) & any(strncmpi(Param.channel, {'m', 'l'}, 1)), Param.channel = 1;
elseif ischar(Param.channel) & any(strncmpi(Param.channel, {'s', 'r'}, 1)), Param.channel = 2;   
elseif ischar(Param.channel) & strncmpi(Param.channel, 'a', 1), Param.channel = 0;       
elseif ischar(Param.channel) & strncmpi(Param.channel, 'b', 1), Param.channel = -2;           
elseif ~isnumeric(Param.channel) | ~any(Param.channel == [-2, 0, 1, 2]),
    error('Property channel must be ''master'', ''slave'', ''left'', ''right'', ''both'', ''avg'', 0, 1, 2 or -2.'); 
end
if ~isnumeric(Param.nharm) | (length(Param.nharm) ~= 1) | (Param.nharm < 0),
    error('Invalid value for property nharm.');
end
if ~isnumeric(Param.numprec) | (length(Param.numprec) ~= 1) | (Param.numprec <= 0),
    error('Invalid value for property numprec.');
end
if ~isempty(Param.calibds) & ~(isa(Param.calibds, 'edfdataset') & strcmpi(Param.calibds.schname, 'calib')),
    error('Property calibds should contain dataset with calibration data.');
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

%----------------------------------------------------------------------------
function SPL = CalcEDF(ds, Param)

Nchan = ds.dssnr; 
Nsub  = ds.nsub; 
DSSNames = {'m', 's'};

%The SPL that is stored in the dataset is the attenuator settings for noise tokens
%and the actual SPL for single tones ...
SPL = ExtractSPL(ds); [Nrow, Ncol] = size(SPL);
SPL = repmat(SPL, Nsub-Nrow+1, Nchan-Ncol+1);

for n = 1:Nchan,
    %??????????????????????????????????????????????????????????????????????????????????????
    %Checking if effective SPL was calculated while collecting data ...
    if ~isnan(ds.GWParam.EffSPL(n)), error('Effective SPL computation already performed while collecting data.'); end
    %Attention! When DSS-mode is set to GAM, then a general waveform is amplitudo modulated
    %with a tone or the other way round. The calculation of the effective SPL for these kind
    %of datasets is not yet implemented ...
    if strcmpi(ds.DSS(n).Mode, 'gam'), error('GAM DSS mode not yet implemented.'); end
    %??????????????????????????????????????????????????????????????????????????????????????
    
    %When no noise token is administered for a playback channel then the attenuator
    %setting is the effective SPL ...
    if ~any(strcmpi(ds.DSS(n).Mode, {'gws', 'gwr', 'gam'})), continue; end
    
    %Finding the appropriate calibration dataset ...
    if isempty(Param.calibds),
        CALIBds = GetCALIB4ds(ds, DSSNames{n});
        if isempty(CALIBds), error('No standard calibration dataset for this dataset.'); end
    else, CALIBds = Param.calibds; end

    %Finding the appropriate general waveform dataset ...
    if iscellstr(ds.GWParam.FileName), [dummy, dummy, GWFile] = unravelVMSPath(ds.GWParam.FileName{n});
    else, [dummy, dummy, GWFile] = unravelVMSPath(ds.GWParam.FileName); end
    if iscellstr(ds.GWParam.ID), GWID = ds.GWParam.ID{n}; else, GWID = ds.GWParam.ID; end
    if strcmpi(ds.indepshortname, 'dsnr') & strcmpi(GWID, 'none'),
        NSubSeq = ds.nsub;
        for iSubSeq = 1:NSubSeq,
            %Loading the general waveform dataset ...
            GWiSubSeq = ds.GWParam.DSNr(iSubSeq, n);
            try, GEWAVds = dataset(GWFile, GWiSubSeq);
            catch, error(sprintf('The general waveform dataset #%d <%s> cannot be found.', GWFile, GWiSubSeq)); end    
            
            %Calculation of effective spl ...
            EffSPL(iSubSeq, n) = EvalGEWAV(GEWAVds, CALIBds, 'filtercf', Param.filtercf, 'filterbw', Param.filterbw, ...
                'numprec', Param.numprec, 'nharm', Param.nharm, 'plot', 'no', 'verbose', 'no');
        end
    else,
        %Loading the general waveform dataset ...
        try, GEWAVds = dataset(GWFile, GWID);
        catch, error(sprintf('The general waveform dataset %s <%s> cannot be found.', GWFile, GWID)); end    
        
        %Calculation of effective spl ...
        EffSPL = EvalGEWAV(GEWAVds, CALIBds, 'filtercf', Param.filtercf, 'filterbw', Param.filterbw, ...
            'numprec', Param.numprec, 'nharm', Param.nharm, 'plot', 'no', 'verbose', 'no');
    end
    %The analog attenuator is set by the SPL setting of the dataset. When
    %the attenuator is set not active the maximum numerical amplitude
    %corresponds with 127dB ...
    SPL(:, n) = EffSPL - (127-SPL(:, n));
end

%----------------------------------------------------------------------------
function SPL = CalcSGSR(ds, Param)

Nchan = 2 - sign(ds.Special.ActiveChan);
Nsub  = ds.nsub;

%??????????????????????????????????????????????????????????????????????????????????????
%Attention! For WAV-datasets the effective SPL must be calculated based on the FFT of
%the noise token and a calibration file ...
%??????????????????????????????????????????????????????????????????????????????????????
if strcmpi(ds.StimType, 'wav'), 
    warning('Effective SPL calculation of WAV-files not yet implemented.');
    SPL = repmat(NaN, Nsub, Nchan);
    return;
end

%The SPL that is stored in the dataset is the effective SPL ...
SPL = ExtractSPL(ds); [Nrow, Ncol] = size(SPL);
SPL = repmat(SPL, Nsub-Nrow+1, Nchan-Ncol+1);

for n = 1:Nchan,
    NoiseBW = GetNoiseBW(ds, 'channel', n); %Extract noise bandwidth ...
    if isnan(NoiseBW), continue; end %No noise token is administered for the playback channel ...
    ReqBW = InterpretFilterParam(Param, NoiseBW); %Extract requested bandwidth ...
    if isequal(ReqBW, NoiseBW), continue; end
    EffPdB = db2p(SPL(:, n))/abs(diff(NoiseBW));
    SPL(:, n) = p2dB(EffPdB*abs(diff(ReqBW)));
end

%----------------------------------------------------------------------------
function BW = InterpretFilterParam(Param, NoiseBW)

%Calculate overall efective SPL ...
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

%----------------------------------------------------------------------------
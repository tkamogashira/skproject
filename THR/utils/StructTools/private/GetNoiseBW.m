function BW = GetNoiseBW(ds, varargin)
%GETNOISEBW return noise bandwidth for dataset
%   BW = GETNOISEBW(ds) returns the bandwidth of the noise used in the
%   supplied dataset as a two-element vector. If the requested playback
%   channel for the dataset wasn't used to administrate a noise token,
%   then NaN is returned.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 19-07-2004

%-------------------------------default parameters---------------------------
DefParam.channel = 1;   %'master', 'slave', 'left', 'right', 1 or 2 ...
DefParam.numprec = 5e1; %numerical precision for noise bandwidth ...

%----------------------------------main program------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(ds) & strcmpi(ds, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
elseif ~isa(ds, 'dataset'), error('First argument should be dataset.'); end

Param = CheckPropList(DefParam, varargin{:});
Param = CheckParam(Param);

if strcmpi(ds.fileformat, 'edf'), BW = GetNoiseBW4EDF(ds, Param);
elseif any(strcmpi(ds.fileformat, {'sgsr', 'idf/spk'})), BW = GetNoiseBW4SGSR_IDF_SPK(ds, Param);
elseif strcmpi(ds.fileformat, 'mdf'),
    if any(strcmpi(ds.ID.OrigID(1).FileFormat, {'sgsr', 'idf/spk'})),
        BW = GetNoiseBW4SGSR_IDF_SPK(ds, Param);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'edf'),    
        BW = GetNoiseBW4EDF(ds, Param);    
    else, BW = Try2GetNoiseBW(ds, Param); end    
else, BW = Try2GetNoiseBW(ds, Param); end

%------------------------------local functions-------------------------------
function Param = CheckParam(Param)

if ischar(Param.channel) & any(strncmpi(Param.channel, {'m', 'l'}, 1)), Param.channel = 1;
elseif ischar(Param.channel) & any(strncmpi(Param.channel, {'s', 'r'}, 1)), Param.channel = 2;   
elseif ~isnumeric(Param.channel) | ~any(Param.channel == [1, 2]),
    error('Property channel must be ''master'', ''slave'', ''left'', ''right'', 1 or 2.'); 
end
if ~isnumeric(Param.numprec) | (length(Param.numprec) ~= 1) | (Param.numprec <= 0),
    error('Invalid value for property numprec.');
end

%----------------------------------------------------------------------------
function BW = GetNoiseBW4EDF(ds, Param)

DSSidx = Param.channel;
if (ds.dssnr == 0), error('Dataset doesn''t contain spiketime data.'); end
if (DSSidx > ds.dssnr), error('Slave DSS not used for EDF dataset.'); end

if any(strcmpi(ds.DSS(DSSidx).Mode, {'gws', 'gwr', 'gam'})),
    %Loading the general waveform dataset ...
    FileName = cellstr(ds.GWParam.FileName);
    [dummy, dummy, GWFile] = unravelVMSPath(FileName{DSSidx});
    GWID = cellstr(ds.GWParam.ID);
    GWID = GWID{DSSidx};
    try, GEWAVds = dataset(GWFile, GWID);
    catch, error(sprintf('The general waveform dataset %s <%s> cannot be found.', GWFile, GWID)); end    
    
    %Using EVALGEWAV.M to extract the bandwidth ...
    BW = EvalGEWAV(GEWAVds, 'numprec', Param.numprec, 'verbose', 'no', 'plot', 'no');
else, BW = NaN; end

%----------------------------------------------------------------------------
function BW = GetNoiseBW4SGSR_IDF_SPK(ds, Param)

Nchan = 2 - sign(ds.Special.ActiveChan); %Number of channels ...
if isnan(Nchan), error('Dataset doesn''t contain spiketime data.'); end
if (Param.channel > Nchan), error('Second playback channel not used for dataset.'); end

switch upper(ds.StimType),
%The following datasets don't have a noise component in their stimulus, so 
%no noise bandwidth can be extracted ...
case {'THR', 'SPL', 'FM', 'IID', 'LMS', 'IMS', 'PS', 'BB', 'BMS', 'CFS', 'CSPL', 'CTD', 'ICI', 'FS', 'FSLOG'},
    BW = NaN; return;
%??????????????????????????????????????????????????????????????????????????????????????
%For WAV-datasets no bandwidth information is present in the datasets. However the
%bandwidth can be extimated by taking an FFT of the sampled signal ... (Not yet implemeneted)
%??????????????????????????????????????????????????????????????????????????????????????
case 'WAV',
    warning('Bandwidth estimation for WAV-files not yet implemented.'); BW = NaN; 
    return;
%All other known datasets have bandwidth information ...    
case {'NSPL', 'NTD', 'ARMIN'}, BW = [ds.StimParam.Flow(:), ds.StimParam.Fhigh(:)];
case 'NRHO', BW = [ds.StimParam.lowFreq(:), ds.StimParam.highFreq(:)];
case 'BERT', BW = [ds.StimParam.NoiseLF(:), ds.StimParam.NoiseHF(:)];
%For unknown datasets ...
otherwise, BW = Try2GetNoiseBW(ds, Param); return; end

if (size(BW, 1) > 1), BW = BW(Param.channel, :); end

%----------------------------------------------------------------------------
function BW = Try2GetNoiseBW(ds, Param)
%Lowest frequency   -> 'flow', 'lowfreq', 'noiseHF'
%Highest frequency  -> 'fhigh', 'highfreq', 'noiseLF'

Nchan = 2 - sign(ds.Special.ActiveChan); %Number of channels ...
if isnan(Nchan), error('Dataset doesn''t contain spiketime data.'); end 
if (Param.channel > Nchan), error('Second playback channel not used for dataset.'); end
Nsub  = ds.nsub;

LoFreq = Try2ExtractVF(ds, {'flow', 'lowfreq', 'noiseLF'});
HiFreq = Try2ExtractVF(ds, {'fhigh', 'highfreq', 'noiseHF'});
if all(isnan(LoFreq)) | all(isnan(HiFreq)), BW = NaN;
else,
    %Lowest and highest frequencies in the noise token can be varied with
    %subsequence and playback channel ...
    LoFreq = ExpandParam(LoFreq, Nsub, Nchan);
    HiFreq = ExpandParam(HiFreq, Nsub, Nchan);
    BW = SqueezeParam(abs(HiFreq-LoFreq));
end
    
if (size(BW, 2) > 1), BW = BW(:, Param.channel); end
    
%----------------------------------------------------------------------------
function V = ExpandParam(V, Nsub, Nchan)

[Nrow, Ncol] = size(V);
if ~any(Nrow == [1, Nsub]) | ~any(Ncol == [1, Nchan]), V = NaN;
else, V = repmat(V, (Nsub-Nrow)+1, (Nchan-Ncol)+1); end

%----------------------------------------------------------------------------
function Val = Try2ExtractVF(ds, VirtualFName)
%Try to retrieve value of virtual field ...

VirtualFName = cellstr(VirtualFName); 
N = length(VirtualFName);
for n = 1:N,
    try, 
        Val = eval(sprintf('ds.%s;', VirtualFName{n}));
        return;
    end
end
Val = NaN;

%----------------------------------------------------------------------------
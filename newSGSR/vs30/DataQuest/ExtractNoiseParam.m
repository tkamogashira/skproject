function ArgOut = ExtractNoiseParam(ds, ParamType)
%EXTRACTNOISEPARAM  extract noise parameters from dataset.
%   Val = EXTRACTNOISEPARAM(ds, ParamType) returns the noise related
%   parameter given by ParamType of dataset ds. ParamType must be a
%   character string which specifies the requested parameter, thus
%   'spl', 'lowfreq' (or 'lofreq'), 'highfreq' (or 'hifreq'), 
%   'correlation'(or 'rho'), 'polarity'(or 'sign'), 'randomseed'( or
%   'rseed', 'seed'), 'filename'(or 'fname') and 'seqid'(or 'id').
%   The requested parameter is always returned as a matrix with the most
%   economical size. If the parameter varies with subsequence number, 
%   it will be returned as a matrix for which different rows correspond
%   to different subsequences. If the parameter is different for both
%   playback channels, the parameter will be a matrix where the different
%   columns correspond with the different playback channels. If the 
%   requested parameter is not applicable for a dataset, then NaN is
%   returned.
%   
%   S = EXTRACTNOISEPARAM(ds) returns a structure S with all the noise
%   parameters for the given dataset. Each field of this structure is a
%   numerical matrix or a cell-array of strings with the most economical
%   size.
%
%   Attention! Unit for SPL is dB and Hz for frequency parameters.

%B. Van de Sande 28-07-2004

%This routine extracts noise parameters for known dataset formats.
%However for an unknown type of dataset this routine still tries to 
%extract these parameter using the virtual fields:
%    SPL                -> 'spl'
%    Lowest frequency   -> 'flow', 'lowfreq', 'noiseHF'
%    Highest frequency  -> 'fhigh', 'highfreq', 'noiseLF'
%    Correlation        -> 'rho'
%    Polarity           -> 'noisesign', 'noisepolarity'
%    Random number seed -> 'randomseed', 'rseed'
%To make sure that for new dataset types these parameters can still be
%extracted, these new kind of datasets must have these virtual fields
%implemented. The SPL should always be the overall effective SPL.

%An SPL setting must always be returned when a noise token is present for a
%dataset, even for a noise token which is modulated by a tone. The SPL returned
%should always be the overall effective SPL. For SGSR datasets this isn't a
%problem because this is stored in the dataset itself, but for EDF datasets
%the setting of the attenuator is only saved. The effective SPL must be
%calculated based on the FFT and a calibration file ...

%Check input arguments ...
if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end
if (nargin == 2), FName = ParseParamType(ParamType); else, FName = ''; end

%Number of channels ...
Nchan = 2 - sign(ds.Special.ActiveChan); 
if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR'), [Nsub, Nrec] = deal(ds.nsub - 1);
else, Nsub = ds.nsub; Nrec = ds.nrec; end 

%Extract noise paremeters ...
if isnan(Nchan), S = NoNoiseParam;
elseif strcmpi(ds.FileFormat, 'EDF'), %EDF datasets ...
    S = ExtractNoiseParam4EDF(ds, Nchan);
elseif any(strcmpi(ds.FileFormat, {'SGSR', 'IDF/SPK'})), %Pharmington (IDF/SPK) and SGSR datasets ...
    S = ExtractNoiseParam4SGSR_IDF_SPK(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'MDF'), %MDF datasets ...
    if any(strcmpi(ds.ID.OrigID(1).FileFormat, {'SGSR', 'IDF/SPK'})),
        S = ExtractNoiseParam4SGSR_IDF_SPK(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'),    
        S = ExtractNoiseParam4EDF(ds, Nchan);
    else, S = Try2ExtractNoiseParam(ds, Nchan); end 
else, S = Try2ExtractNoiseParam(ds, Nchan); end

%Reduce parameters to most economical size ...
S.SPL       = SqueezeParam(AdjustParam(S.SPL, Nsub, Nrec));
S.LowFreq   = SqueezeParam(AdjustParam(S.LowFreq, Nsub, Nrec));
S.HighFreq  = SqueezeParam(AdjustParam(S.HighFreq, Nsub, Nrec));
S.Rho       = SqueezeParam(AdjustParam(S.Rho, Nsub, Nrec));
S.Polarity  = SqueezeParam(AdjustParam(S.Polarity, Nsub, Nrec));
S.RSeed     = SqueezeParam(AdjustParam(S.RSeed, Nsub, Nrec));
S.FileName  = SqueezeParam(AdjustParam(S.FileName, Nsub, Nrec));
S.SeqID     = SqueezeParam(AdjustParam(S.SeqID, Nsub, Nrec));

%Return requested field ...
if isempty(FName), ArgOut = S;
else, ArgOut = getfield(S, FName); end

%--------------------------------local functions------------------------
function FName = ParseParamType(Str)

if ~ischar(Str), error('Second argument should be character array.'); end

if strcmpi(Str, 'spl'), FName = 'SPL';
elseif any(strcmpi(Str, {'lofreq', 'lowfreq'})), FName = 'LowFreq';
elseif any(strcmpi(Str, {'hifreq', 'highfreq'})), FName = 'HighFreq';
elseif any(strcmpi(Str, {'correlation', 'rho'})), FName = 'Rho';
elseif any(strcmpi(Str, {'polarity', 'sign'})), FName = 'Polarity';
elseif any(strcmpi(Str, {'randomseed', 'rseed', 'seed'})), FName = 'RSeed';
elseif any(strcmpi(Str, {'filename', 'fname'})), FName = 'FileName';
elseif any(strcmpi(Str, {'seqid', 'id'})), FName = 'SeqID';    
else, error('Requested noise parameter doesn''t exist.'); end

%-----------------------------------------------------------------------
function S = ExtractNoiseParam4SGSR_IDF_SPK(ds, Nchan)

S = NoNoiseParam; %To keep order of fieldnames constant ...

%Attention! The code to extract noise parameters doesn't take the version
%of a stimulus into account. This my cause problems for ARMIN, BN, NRHO
%datasets ...
switch upper(ds.Stimtype)
case {'THR', 'SPL', 'FM', 'IID', 'LMS', 'IMS', 'PS', 'BB', 'BMS', 'CFS', 'CSPL', 'CTD', 'ICI', 'BFS', 'FS', 'FSLOG'},
    return;
case 'NTD',
    S.Rho       = ds.StimParam.Rho;
    S.Polarity  = 1;
    S.RSeed     = ds.StimParam.RandomSeed;
case 'NSPL',
    S.Rho       = ds.StimParam.Rho;
    S.Polarity  = ds.StimParam.noiseSign;
    S.RSeed     = ds.StimParam.RandomSeed;
case 'ARMIN', %Settings of constant noise token ...
    S.Rho       = 1;
    S.Polarity  = ds.StimParam.polaconst;
    S.RSeed     = ds.StimParam.seedC;
case 'NRHO',
    S.Rho       = ds.StimParam.rho; %A vector ...
    S.Polarity  = ds.StimParam.noisePolarity;
    S.RSeed     = ds.StimParam.Rseed;
case 'BERT',
    S.Rho       = 1;
    S.Polarity  = 1;
    S.RSeed     = ds.StimParam.Rseed;
case 'BN',
    S.Rho       = 1;
    S.Polarity  = 1;
    S.RSeed     = ds.StimParam.Rseed;
case 'WAV',   
    S.Rho       = 1;
    S.Polarity  = 1;
    S.RSeed     = NaN;
otherwise, S = Try2ExtractNoiseParam(ds, Nchan); return; end

if (Nchan > 1)
    S.SPL   = CalcEffSPL(ds, 'channel', 'b');
    BWleft  = GetNoiseBW(ds, 'channel', 'l');
    BWright = GetNoiseBW(ds, 'channel', 'r');    
    S.LowFreq   = [min(BWleft), min(BWright)];
    S.HighFreq = [max(BWleft), max(BWright)];
else,
    S.SPL = CalcEffSPL(ds); 
    BW = GetNoiseBW(ds);
    S.LowFreq   = min(BW);
    S.HighFreq = max(BW);
end

%FileName only contains the filename and its extension. Information on path should
%be discarded ...
if strcmpi(ds.StimType, 'WAV'), S.FileName  = ds.StimParam.WAVdetails.ShortName';
else, S.FileName  = ''; end
S.SeqID = '';

%-----------------------------------------------------------------------
function S = ExtractNoiseParam4EDF(ds, Nchan)

%Datasets who have a fieldname with name GWParam in the StimParam structure,
%possibly have a noise as stimulus. For datasets with schemate CALIB, SCH005
%and SCH008 this is certainly not the case ...
try,
    if (Nchan == 1) & ~isempty(ds.StimParam.GWParam.FileName) & ...
            ~isempty(ds.StimParam.GWParam.ID),
        S.SPL       = CalcEffSPL(ds); 
        BW = GetNoiseBW(ds);
        S.LowFreq   = min(BW);
        S.HighFreq  = max(BW);
        S.Rho       = 1;
        S.Polarity  = 1;
        S.RSeed     = NaN;
        S.FileName  = FormatVMSFileName(ds.StimParam.GWParam.FileName);
        S.SeqID     = ds.StimParam.GWParam.ID;
    elseif (Nchan == 2) & ~all(cellfun('isempty', ds.StimParam.GWParam.FileName)) & ...
            ~all(cellfun('isempty', ds.StimParam.GWParam.ID)),
        S.SPL       = CalcEffSPL(ds, 'channel', 'b');
        BWmaster = GetNoiseBW(ds, 'channel', 'm');
        BWslave  = GetNoiseBW(ds, 'channel', 's');    
        S.LowFreq    = [min(BWmaster), min(BWslave)];
        S.HighFreq  = [max(BWmaster), max(BWslave)];
        S.Rho       = 1;
        S.Polarity  = 1;
        S.RSeed     = NaN;
        S.FileName  = {FormatVMSFileName(ds.StimParam.GWParam.FileName{1}), ...
                FormatVMSFileName(ds.StimParam.GWParam.FileName{2})};
        S.SeqID     = ds.StimParam.GWParam.ID;
    else, S = NoNoiseParam; end
catch, S = NoNoiseParam; end    

%-----------------------------------------------------------------------
function FileName = FormatVMSFileName(FullFileName)

%FileName must only contains the filename and its extension. Information
%on path should be discarded ...
[dummy, dummy, FileName, FileExt] = unravelVMSPath(FullFileName);
if isempty(FileExt), FileExt = '.dat';
elseif (FileExt(1) ~= '.'), FileExt = ['.', FileExt]; end
FileName = lower([FileName, FileExt]);

%-----------------------------------------------------------------------
function S = Try2ExtractNoiseParam(ds, Nchan)

S = NoNoiseParam; %To keep order of fieldnames constant ...

%The random number seed is used to check if dataset has noise component
%in the stimulus ...
RSeed = Try2ExtractVF(ds, {'randomseed', 'rseed'});
if ~isnan(RSeed),
    S.SPL       = ExtractSPL(ds);
    S.LowFreq   = Try2ExtractVF(ds, {'flow', 'lowfreq', 'noiseLF'});
    S.HighFreq  = Try2ExtractVF(ds, {'fhigh', 'highfreq', 'noiseHF'});
    S.Rho       = Try2ExtractVF(ds, 'rho');
    S.Polarity  = Try2ExtractVF(ds, {'noisesign', 'noisepolarity'});
    S.RSeed     = RSeed;
end

%Noise token specified by sampled data is exceptional (Only WAV-datasets
%and all EDF datasets) ...
S.FileName = '';
S.SeqID    = '';

%-----------------------------------------------------------------------
function S = NoNoiseParam

S = struct('SPL', NaN, 'LowFreq', NaN, 'HighFreq', NaN, 'Rho', NaN, ...
    'Polarity', NaN, 'RSeed', NaN, 'FileName', '', 'SeqID', '');

%-----------------------------------------------------------------------
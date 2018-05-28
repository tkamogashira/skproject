function [X, Y] = sptcorrsh(varargin)
%SPTCORRSH  calculate correlation between two spiketrains.
%   [X, Y] = SPTCORRSH(Spt1, Spt2, CalcParam) calculates the crosscorrelogram of vector Spt1 and vector Spt2. These
%   vectors should contain spiketimes in milliseconds. The crosscorrelogram is given by two vectors, X is the delay
%   in milliseconds between the two spiketrains, ranging from -CalcParam.cormaxlog to +CalcParam.cormaxlag. Y is the
%   correlation between the two spiketrains in spikes per seconds.
%   The convention of time order matches that of XCORR: if t1 and t2 are spiketimes from SPT1 and SPT2, respectively, 
%   then t1 > t2 will count as a positive interval.
%   
%   [X, Y] = SPTCORRSH(Spt, CalcParam) is the autocorrelogram of vector Spt.
%
%   The calculation parameters are given as a structure with the following fields: coranwin is the analysiswindow 
%   in ms, corbinwidth is the binwidth in ms, cormaxlag is maximum lag between the spiketrains in ms.
%
%   Attention! Calculating crosscorrelograms is time-consuming, these calculations can therefore be cached.
%   [X, Y] = SPTCORRSH(Spt1, Spt2, CalcParam, CacheParam, FullFileName) caches the results in the file
%   FullFileName. If no directory is given the current directory is assumed. CacheParam is a structure with
%   uniquely identifies the calculated data.

%B. Van de Sande 24-03-2003

switch nargin
case 2
    spt1         = varargin{1}; 
    spt2         = spt1;
    CalcParam    = lowerfields(varargin{2});
    CacheParam   = struct([]);
    FullFileName = '';
case 3
    spt1         = varargin{1}; 
    spt2         = varargin{2};
    CalcParam    = lowerfields(varargin{3});
    CacheParam   = struct([]);
    FullFileName = '';
case 4
    spt1         = varargin{1};
    spt2         = spt1;
    CalcParam    = lowerfields(varargin{2});
    CacheParam   = lowerfields(varargin{3});
    FullFileName = varargin{4};
case 5
    spt1         = varargin{1};
    spt2         = varargin{2};
    CalcParam    = lowerfields(varargin{3});
    CacheParam   = lowerfields(varargin{4});
    FullFileName = varargin{5};
otherwise, error('Wrong number of input parameters.'); end

if ~isempty(FullFileName),
    [Path, FileName, FileExt] = fileparts(FullFileName);
    if isempty(Path),    Path = cwd; end
    if isempty(FileExt), FileExt = ['.' mfilename '.cache']; end
    if isempty(FileName), error('Invalid cache filename.'); end
    FullFileName = fullfile(Path, [FileName FileExt]);
end    
if ~isempty(CacheParam), CacheParam = lowerfields(rofields(structcat(CacheParam, getfields(CalcParam, {'corbinwidth', 'cormaxlag', 'coranwin'})), 'alpha')); end    

N = size(spt1, 2); M = size(spt2, 2);
AnDur = CalcParam.coranwin(2) - CalcParam.coranwin(1);

if ~isequal(spt1,spt2) %CrossCorrelatie berekenen ...
    Y = local_FromCorrCache(FullFileName, CacheParam);
    if isempty(Y)
        [Y, X] = sptcorr(anwin(spt1,[CalcParam.coranwin(1), CalcParam.coranwin(2)]), ...
                         anwin(spt2,[CalcParam.coranwin(1), CalcParam.coranwin(2)]), ...
                         CalcParam.cormaxlag, CalcParam.corbinwidth);
        local_ToCorrCache(FullFileName, Y, CacheParam);
    else, [Dum, X] = sptcorr([], [], CalcParam.cormaxlag, CalcParam.corbinwidth); end    
    Y = (1000 * Y) / (AnDur *(N*M));
else %AutoCorrelatie berekenen ...
    Y = local_FromCorrCache(FullFileName, CacheParam);
    if isempty(Y)
        [Y,X] = sptcorr(anwin(spt1,[CalcParam.coranwin(1), CalcParam.coranwin(2)]), 'nodiag', ...
                        CalcParam.cormaxlag, CalcParam.corbinwidth);
        local_ToCorrCache(FullFileName, Y, CacheParam);
    else, [Dum, X] = sptcorr([], [], CalcParam.cormaxlag, CalcParam.corbinwidth); end    
    Y = (1000 * Y) / (AnDur *(N*(N-1)));
end

%----------------------locals-------------------------------
function local_ToCorrCache(FileName, SptY, SParam)

if isempty(FileName), return; end

Data = ZipNumericData(SptY);
PutInHashFile(FileName, SParam, Data, +1021);

function SptY = local_FromCorrCache(FileName, SParam)

SptY = [];

if isempty(FileName), return; end

Data = GetFromHashFile(FileName, SParam);
if isempty(Data), return; end

SptY = UnZipNumericData(Data);

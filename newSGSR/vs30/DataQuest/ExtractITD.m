function ITD = ExtractITD(ds)
%EXTRACTITD   get parameter interaural delay for dataset.
%   ITD = EXTRACTITD(ds) returns the interaural delay of dataset ds.
%   The interaural delay is always returned as a matrix with the most
%   economical size. If the delay varies with subsequence number, the
%   duration will be returned as a matrix for which different rows 
%   correspond to different subsequences. If interaural delay is not
%   applicable for the dataset, e.g. a monaural dataset, then NaN is
%   returned.
%
%   Attention! Delays are returned in microseconds.

%B. Van de Sande 28-07-2004

%This routine extracts the interaural delay for known dataset formats. 
%However for an unknown type of dataset this routine still tries to extract
%this parameter using the virtual field 'itd'(binaural) and if that doesn't
%work it uses the virtual field 'delay'(monaural) and takes the difference
%of the two columns in the value of this field. To make sure that for new
%dataset types this parameter can still be extracted, these new kind of 
%datasets must have one of those virtual fields implemented.

%Check input arguments ...
if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end

Nchan = 2 - sign(ds.Special.ActiveChan); if isnan(Nchan), Nchan = 0; end %Number of channels ...
if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR'), [Nsub, Nrec] = deal(ds.nsub - 1);
else, Nsub = ds.nsub; Nrec = ds.nrec; end 

%For monaural datasets the interaural delay is not a meaningful parameter and is
%therefore set to NaN ...
if (Nchan < 2), ITD = NaN; return; end

%Extract interaural delay ...
if strcmpi(ds.FileFormat, 'EDF'), %EDF datasets ...
    ITD = ExtractITD4EDF(ds);
elseif strcmpi(ds.FileFormat, 'IDF/SPK'), %Pharmington (IDF/SPK) datasets ...
    ITD = ExtractITD4IDF_SPK(ds);
elseif strcmpi(ds.FileFormat, 'SGSR'), %SGSR datasets ...
    ITD = ExtractITD4SGSR(ds);
elseif strcmpi(ds.FileFormat, 'MDF'), %MDF datasets ...
    if strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK'),
        ITD = ExtractITD4IDF_SPK(ds);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'SGSR'),
        ITD = ExtractITD4SGSR(ds);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'),    
        ITD = ExtractITD4EDF(ds);
    else, ITD = Try2ExtractITD(ds); end 
else, ITD = Try2ExtractITD(ds); end

%Reduce interaural delay to most economical size ...
ITD = SqueezeParam(AdjustParam(ITD, Nsub, Nrec));

%For binaural datasets when an ITD cannot be extracted it is assumed 
%to be zero ...
if all(isnan(ITD)), ITD = 0; end

%--------------------------------local functions------------------------
function ITD = ExtractITD4EDF(ds)

if any(strcmpi(ds.SchName, {'CALIB', 'SCH005'})), ITD = NaN;
elseif strcmpi(ds.SchName, 'SCH008'), ITD = diff(ds.StimParam.delay, 1, 2);
elseif any(strcmpi(ds.SchName, {'SCH006', 'SCH012', 'SCH016'})), ITD = diff(ds.StimParam.Delay, 1, 2);
else, ITD = Try2ExtractITD(ds); end

%-----------------------------------------------------------------------
function ITD = ExtractITD4SGSR(ds)

if any(strcmpi(ds.StimType, {'THR', 'NRHO', 'ARMIN'})), ITD = diff(ds.StimParam.delay, 1, 2);
elseif any(strcmpi(ds.StimType, {'BN', 'PS', 'BERT', 'WAV'})), ITD = NaN;
else, ITD = Try2ExtractITD(ds); end

%-----------------------------------------------------------------------
function ITD = ExtractITD4IDF_SPK(ds)

if any(strcmpi(ds.StimType, {'NTD', 'CTD'})), ITD = ds.indepval;
elseif any(strcmpi(ds.StimType, {'NSPL', 'SPL', 'FM', 'IID', 'LMS', 'IMS', 'BMS', 'CFS', 'CSPL', 'FS', 'FSLOG'})),   
    Delay = [ds.StimParam.indiv.stim{1}.delay, ds.StimParam.indiv.stim{2}.delay];
    ITD = diff(Delay, 1 , 2);
elseif any(strcmpi(ds.StimType, {'BB', 'BFS', 'ICI'})), ITD = NaN;
else, ITD = Try2ExtractITD(ds); end        

%-----------------------------------------------------------------------
function ITD = Try2ExtractITD(ds)

ITD = Try2ExtractVF(ds, 'itd');
if all(isnan(ITD)), 
    Delay = Try2ExtractVF(ds, 'delay');
    if ~all(isnan(Delay)) & (size(Delay, 2) == 2), ITD = diff(Delay, 1, 2); end    
end

%-----------------------------------------------------------------------
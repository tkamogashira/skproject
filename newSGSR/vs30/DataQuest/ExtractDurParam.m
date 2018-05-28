function ArgOut = ExtractDurParam(ds, DurType)
%EXTRACTDURPARAM    get duration parameters for dataset.
%   Dur = EXTRACTDURPARAM(ds, DurType) returns the duration of dataset
%   ds given by DurType. DurType must be a character string which specifies
%   the requested duration, thus 'stimulus'(abbreviated as 'burst' or
%   'stim'), 'repetition' (or 'interval', 'rep', 'int'), 'stimulusrise'
%   (or 'stimrise', 'rise') or 'stimulusfall'(or 'stimfall', 'fall').
%   The requested duration is always returned as a matrix with the most
%   economical size. If the duration varies with subsequence number, the
%   duration will be returned as a matrix for which different rows 
%   correspond to different subsequences. If the duration is different
%   for both playback channels, the duration will be a matrix where the
%   different columns correspond with the different playback channels.
%   If requested duration is not applicable for a dataset, then NaN is
%   returned.
%   
%   S = EXTRACTDURPARAM(ds) returns a structure S with all the duration
%   parameters for the given dataset. Each field of this structure is a
%   numerical matrix with the most economical size.
%
%   Attention! All durations are returned in milliseconds.

%B. Van de Sande 28-07-2004

%This routine extracts the burst and repetition duration using the fields
%'BurstDur' and 'RepDur' respectively, which should be present in the 
%Special structure of the dataset. For the stimulus rise and fall
%duration this routine knows where to find these parameters for a lot of
%dataset types, however for an unknown type of dataset this routine still
%tries to extract the parameters using the virtual fields 'risedur' and
%'falldur'. To make sure that for new dataset types these parameters can
%still be extracted, these new kind of datasets must have those virtual
%fields implemented.

%Check input arguments ...
if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end
if (nargin == 2), FName = ParseDurType(DurType); else, FName = ''; end

Nchan = 2 - sign(ds.Special.ActiveChan); if isnan(Nchan), Nchan = 0; end %Number of channels ...
if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR'), [Nsub, Nrec] = deal(ds.nsub - 1);
else, Nsub = ds.nsub; Nrec = ds.nrec; end 

%Create structure with all common duration related stimulus parameters ...
S.RepDur   = SqueezeParam(AdjustParam(ds.Special.RepDur, Nsub, Nrec));
S.BurstDur = SqueezeParam(AdjustParam(ds.Special.BurstDur, Nsub, Nrec));
[S.RiseDur, S.FallDur] = ExtractAuxDur(ds, Nchan);
S.RiseDur = SqueezeParam(AdjustParam(S.RiseDur, Nsub, Nrec)); 
S.FallDur = SqueezeParam(AdjustParam(S.FallDur, Nsub, Nrec));

%Return requested field ...
if isempty(FName), ArgOut = S;
else, ArgOut = getfield(S, FName); end

%--------------------------------local functions------------------------
function FName = ParseDurType(Str)

if ~ischar(Str), error('Second argument should be character array.'); end

if any(strcmpi(Str, {'stimulus', 'burst', 'burstdur', 'stim', 'stimdur'})), 
    FName = 'RepDur';
elseif any(strcmpi(Str, {'repetition', 'interval', 'rep', 'repdur', 'int', 'intdur'})), 
    FName = 'BurstDur';
elseif any(strcmpi(Str, {'stimulusrise', 'stimrise', 'burstrise', 'rise', 'risedur'})),
    FName = 'RiseDur';
elseif any(strcmpi(Str, {'stimulusfall', 'stimfall', 'burstfall', 'fall', 'falldur'})),
    FName = 'FallDur';
else, error('Requested duration doesn''t exist.'); end

%-----------------------------------------------------------------------
function [RiseDur, FallDur] = ExtractAuxDur(ds, Nchan)

if strcmpi(ds.FileFormat, 'EDF'), %EDF datasets ...
    [RiseDur, FallDur] = ExtractAuxDur4EDF(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'IDF/SPK'), %Pharmington (IDF/SPK) datasets ...
    [RiseDur, FallDur] = ExtractAuxDur4IDF_SPK(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'SGSR'), %SGSR datasets ...
    [RiseDur, FallDur] = ExtractAuxDur4SGSR(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'MDF'), %MDF datasets
    if strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK'),
        [RiseDur, FallDur] = ExtractAuxDur4IDF_SPK(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'SGSR'),
        [RiseDur, FallDur] = ExtractAuxDur4SGSR(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'),    
        [RiseDur, FallDur] = ExtractAuxDur4EDF(ds, Nchan);
    else,
        RiseDur = Try2ExtractVF(ds, 'risedur');
        FallDur = Try2ExtractVF(ds, 'falldur');
    end    
else,
    RiseDur = Try2ExtractVF(ds, 'risedur');
    FallDur = Try2ExtractVF(ds, 'falldur');
end

%-----------------------------------------------------------------------
function [RiseDur, FallDur] = ExtractAuxDur4EDF(ds, Nchan)

if any(strcmpi(ds.SchName, {'CALIB', 'SCH006', 'SCH012', 'SCH016'})),
    RiseDur = ds.StimParam.RiseDur;
    FallDur = ds.StimParam.FallDur;
elseif strcmpi(ds.SchName, 'SCH008'),
    RiseDur = ds.StimParam.riseDur;
    FallDur = ds.StimParam.fallDur;
elseif strcmpi(ds.SchName, 'SCH005'), [RiseDur, FallDur] = deal(NaN);
else,
    RiseDur = Try2ExtractVF(ds, 'risedur');
    FallDur = Try2ExtractVF(ds, 'falldur');
end    

%-----------------------------------------------------------------------
function [RiseDur, FallDur] = ExtractAuxDur4IDF_SPK(ds, Nchan)

if any(strcmpi(ds.StimType, {'NSPL', 'SPL', 'NTD', 'FM', 'IID', 'IMS', 'LMS', 'BB', 'BMS', 'FS', 'BFS', 'FSLOG'})),
    RiseDur = ds.StimParam.indiv.stim{1}.rise;
    FallDur = ds.StimParam.indiv.stim{1}.fall;
    if (Nchan > 1),
        RiseDur(2) = ds.StimParam.indiv.stim{2}.rise;
        FallDur(2) = ds.StimParam.indiv.stim{2}.fall;
    end    
elseif any(strcmpi(ds.StimType, {'CFS', 'CSPL', 'CTD', 'ICI'})), [RiseDur, FallDur] = deal(NaN);
else, 
    RiseDur = Try2ExtractVF(ds, 'risedur');
    FallDur = Try2ExtractVF(ds, 'falldur');
end

%-----------------------------------------------------------------------
function [RiseDur, FallDur] = ExtractAuxDur4SGSR(ds, Nchan)

if any(strcmpi(ds.StimType, {'THR', 'NRHO', 'PS', 'BERT', 'ARMIN'})),
    RiseDur = ds.StimParam.riseDur;
    FallDur = ds.StimParam.fallDur;
elseif strcmpi(ds.StimType, 'BN'), [RiseDur, FallDur] = deal(ds.StimParam.RampDur);
elseif strcmpi(ds.StimType, 'WAV'), [RiseDur, FallDur] = deal(NaN);
else, 
    RiseDur = Try2ExtractVF(ds, 'risedur');
    FallDur = Try2ExtractVF(ds, 'falldur');
end

%-----------------------------------------------------------------------
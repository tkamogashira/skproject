function ModDepth = ExtractModDepth(ds)
%EXTRACTMODDEPTH   get modulation depth for dataset.
%   ModDepth = EXTRACTMODDEPTH(ds) returns the modulation depth of
%   dataset ds. The modulation depth is always returned as a matrix
%   with the most economical size. If the depth varies with subsequence
%   number, the depth will be returned as a matrix for which different
%   rows correspond to different subsequences. If the modulation depth
%   is different for both playback channels, the depth will be a matrix
%   where the different columns correspond with the different playback
%   channels. If modulation depth is not applicable for the dataset, 
%   then NaN is returned.
%
%   Attention! Modulation depth is returned in percent.

%B. Van de Sande 28-07-2004

%This routine extracts the modulation depth for known dataset formats.
%However for an unknown type of dataset this routine still tries to 
%extract this parameter using the virtual field 'moddepth'. To make sure
%that for new dataset types this parameter can still be extracted, these
%new kind of datasets must have this virtual field implemented.

%Check input arguments ...
if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end

Nchan = 2 - sign(ds.Special.ActiveChan); if isnan(Nchan), Nchan = 0; end %Number of channels ...
if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR'), [Nsub, Nrec] = deal(ds.nsub - 1);
else, Nsub = ds.nsub; Nrec = ds.nrec; end 

%Extract delay ...
if strcmpi(ds.FileFormat, 'EDF'), %EDF datasets ...
    ModDepth = ExtractModDepth4EDF(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'IDF/SPK'), %Pharmington (IDF/SPK) datasets ...
    ModDepth = ExtractModDepth4IDF_SPK(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'SGSR'), %SGSR datasets ...
    ModDepth = ExtractModDepth4SGSR(ds, Nchan);
elseif strcmpi(ds.FileFormat, 'MDF'), %MDF datasets ...
    if strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK'),
        ModDepth = ExtractModDepth4IDF_SPK(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'SGSR'),
        ModDepth = ExtractModDepth4SGSR(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF'),    
        ModDepth = ExtractModDepth4EDF(ds, Nchan);
    else, ModDepth = Try2ExtractVF(ds, 'moddepth'); end 
else, ModDepth = Try2ExtractVF(ds, 'moddepth'); end

%Reduce modulation depth to most economical size ...
ModDepth = SqueezeParam(AdjustParam(ModDepth, Nsub, Nrec));

%--------------------------------local functions------------------------
function ModDepth = ExtractModDepth4EDF(ds, Nchan)

if any(strcmpi(ds.SchName, {'CALIB', 'SCH005', 'SCH008'})), ModDepth = NaN;
elseif any(strcmpi(ds.SchName, {'SCH006', 'SCH012', 'SCH016'})), ModDepth = ds.StimParam.FreqParam.ModDepth*100;
else, ModDepth = Try2ExtractVF(ds, 'moddepth')*100; end    

%-----------------------------------------------------------------------
function ModDepth = ExtractModDepth4SGSR(ds, Nchan)

if strcmpi(ds.StimType, 'BERT'), ModDepth = ds.StimParam.modDepth;
elseif any(strcmpi(ds.StimType, {'THR', 'BN', 'PS', 'NRHO', 'WAV', 'ARMIN'})), ModDepth = NaN;
else, ModDepth = Try2ExtractVF(ds, 'moddepth'); end

%-----------------------------------------------------------------------
function ModDepth = ExtractModDepth4IDF_SPK(ds, Nchan)

if any(strcmpi(ds.StimType, {'SPL', 'FM', 'LMS', 'IMS', 'BB', 'BMS', 'FS', 'FSLOG'})),   
    ModDepth = ds.StimParam.indiv.stim{1}.modpercent;
    if (Nchan > 1), ModDepth = [ModDepth, ds.StimParam.indiv.stim{2}.modpercent]; end    
elseif any(strcmpi(ds.StimType, {'NSPL', 'NTD', 'FM', 'BFS', 'CFS', 'CSPL', 'CTD', 'ICI'})), ModDepth = NaN;
else, ModDepth = Try2ExtractVF(ds, 'modpercent'); end

%-----------------------------------------------------------------------
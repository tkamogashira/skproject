function SPL = ExtractSPL(ds)
%EXTRACTSPL extract sound pressure level for dataset
%   SPL = EXTRACTSPL(ds) returns the sound pressure level in dB for the
%   dataset ds. The SPL is always returned as a matrix with the most
%   economical size. If SPL varies with subsequence number, it will be
%   returned as a matrix for which different rows correspond to different
%   subsequences. If the SPL is different for both playback channels it
%   will be a matrix where the different columns correspond with the
%   different playback channels. If SPL is not applicable for a dataset,
%   then NaN is returned.

%B. Van de Sande 28-07-2004

%This routine extracts the SPL for known dataset formats. However for
%an unknown type of dataset this routine still tries to extract this
%parameter using the virtual field 'spl'. To make sure that for new
%dataset types this parameter can still be extracted, these new kind of 
%datasets must have this virtual field implemented.

%Check input arguments ...
if (nargin < 1)
    error('Wrong number of input parameters.')
end
if ~isa(ds, 'dataset')
    error('First argument should be dataset.'); 
end

Nchan = 2 - sign(ds.Special.ActiveChan); 

if isnan(Nchan)
    Nchan = 0; 
end %Number of channels ...
if strcmpi(ds.FileFormat, 'SGSR') & strcmpi(ds.StimType, 'THR')
    [Nsub, Nrec] = deal(ds.nsub - 1);
else
    Nsub = ds.nsub; Nrec = ds.nrec; 
end

%Extract SPL ...
if strcmpi(ds.FileFormat, 'EDF')
    SPL = ExtractSPL4EDF(ds, Nchan); %EDF datasets ...
elseif strcmpi(ds.FileFormat, 'SGSR')
    SPL = ExtractSPL4SGSR(ds, Nchan); %SGSR datasets ...
elseif strcmpi(ds.FileFormat, 'IDF/SPK')
    SPL = ExtractSPL4IDF_SPK(ds, Nchan); %IDF/SPK datasets ...
elseif strcmpi(ds.FileFormat, 'MDF') %MDF datasets ...
    if strcmpi(ds.ID.OrigID(1).FileFormat, 'IDF/SPK')
        SPL = ExtractSPL4IDF_SPK(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'SGSR')
        SPL = ExtractSPL4SGSR(ds, Nchan);
    elseif strcmpi(ds.ID.OrigID(1).FileFormat, 'EDF')    
        SPL = ExtractSPL4EDF(ds, Nchan);    
    else
        SPL = Try2ExtractVF(ds, 'spl'); 
    end
else
    SPL = Try2ExtractVF(ds, 'spl'); 
end %Unknown dataset format ...

%Reduce SPL to most economical size ...
SPL = SqueezeParam(AdjustParam(SPL, Nsub, Nrec));

%---------------------------------------local functions---------------------------------------
function SPL = ExtractSPL4SGSR(ds, Nchan)
%SGSR datasets: SPL is always a field of the StimParam structure and is given as a 
%scalar for datasets with only one active channel, and a two-element row-vector for
%datasets with two active channels ...

if strcmpi(ds.StimType, 'THR')
    SPL = NaN;
%Attention! For BN-datasets there is a difference between the SPL of the total noise
%token and the SPL of the different compnonents in the noise token ...
elseif any(strcmpi(ds.StimType, {'NRHO', 'ARMIN', 'BN', 'BERT'}))
    SPL = ds.StimParam.SPL;
%If dataset doesn't belong to any of the above then try to retrieve SPL using the virtual
%field spl of a dataset ...
else
    SPL = Try2ExtractVF(ds, 'spl'); 
end

%---------------------------------------------------------------------------------------------
function SPL = ExtractSPL4IDF_SPK(ds, Nchan)
%IDF/SPK datasets: For SPL and NSPL datasets the SPL-settings are found as a column-
%vector in 'IndepVar.Values'. For appropriate other datasets the SPL is found in the field
%'indiv.stim{}.spl'. Again given as a scalar for datasets with only one active channel, and
%a two-element row-vector for datasets with two active channels. NTD-datasets are an 
%exception to this rules and the SPL can be extracted in the same way as with SGSR datasets ...

if any(strcmpi(ds.StimType, {'ITD', 'FS', 'FSLOG', 'BFS', 'FM', 'LMS', 'BB', 'CFS', 'CTD'}))
    SPL = ds.StimParam.indiv.stim{1}.spl;
    if (Nchan > 1)
        SPL(2) = ds.StimParam.indiv.stim{2}.spl; 
    end
elseif strcmpi(ds.StimType, 'IMS'), %????
    if isequal(ds.StimParam.indiv.stim{1}.lospl, ds.StimParam.indiv.stim{1}.hispl) & ...
            isequal(ds.StimParam.indiv.stim{end}.lospl, ds.StimParam.indiv.stim{end}.hispl)
        SPL = ds.StimParam.indiv.stim{1}.lospl;
        if (Nchan > 1)
            SPL(2) = ds.StimParam.indiv.stim{2}.lospl; 
        end
    else
        SPL = NaN; 
    end
elseif any(strcmpi(ds.StimType, {'SPL', 'NSPL'}))
    SPL = ds.indepval;
elseif strcmpi(ds.StimType, 'NTD')
    SPL = ds.StimParam.SPL; 
%If dataset doesn't belong to any of the above then try to retrieve SPL using the virtual
%field spl of a dataset ...
else
    SPL = Try2ExtractVF(ds, 'spl'); 
end

%---------------------------------------------------------------------------------------------
function SPL = ExtractSPL4EDF(ds, Nchan)
%EDF datasets: SPL is always a field of the StimParam structure except for TH and CALIB
%datasets. It is a scalar for datasets with only one active channel, and a two-element
%row-vector for datasets with two active channels. If the SPL is varied for a dataset then
%SPL is a matrix with the same number of rows as total number of subsequences. If not 
%completely recorded then the SPL values aren't set to NaN. If not applicable for a dataset
%then the value is set to NaN. This also works for datasets with two independent variables.

if any(strcmpi(ds.SchName, {'CALIB', 'SCH005', 'SCH008'}))
    SPL = NaN;
elseif any(strcmpi(ds.SchName, {'SCH006', 'SCH012', 'SCH016'}))
    SPL = ds.StimParam.SPL;
else
    SPL = Try2ExtractVF(ds, 'spl'); 
end

%---------------------------------------------------------------------------------------------
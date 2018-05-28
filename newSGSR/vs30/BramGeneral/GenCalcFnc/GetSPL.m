function SPL = GetSPL(ds)
%GETSPL get sound pressure level for dataset
%   SPL = GETSPL(ds) returns the sound pressure level in dB for the dataset ds.
%   The SPL is returned as a matrix with the number of rows defined by the total 
%   number of subsequences and with the same number of columns as active channels 
%   used in the collection of data.

%B. Van de Sande 24-05-2004

if (nargin < 1), error('Wrong number of input parameters.'); end
if ~isa(ds, 'dataset'), error('First argument should be dataset.'); end

if strcmpi(ds.FileFormat, 'EDF'), SPL = ExtractSPL4EDF(ds); %EDF datasets ...
elseif strcmpi(ds.FileFormat, 'SGSR'), SPL = ExtractSPL4SGSR(ds); %SGSR datasets ...
elseif strcmpi(ds.FileFormat, 'IDF/SPK'), SPL = ExtractSPL4IDF_SPK(ds); %IDF/SPK datasets ...
elseif strcmpi(ds.FileFormat, 'MDF'), %MDF datasets ...
    if all(strcmpi({ds.ID.OrigID(1).FileFormat, ds.ID.OrigID(2).FileFormat}, 'IDF/SPK')),
        SPL = ExtractSPL4IDF_SPK(ds);
    elseif all(strcmpi({ds.ID.OrigID(1).FileFormat, ds.ID.OrigID(2).FileFormat}, 'SGSR')),
        SPL = ExtractSPL4SGSR(ds);
    elseif all(strcmpi({ds.ID.OrigID(1).FileFormat, ds.ID.OrigID(2).FileFormat}, 'EDF')),,    
        SPL = ExtractSPL4EDF(ds);    
    else, SPL = Try2ExtractSPL(ds); end    
else, SPL = Try2ExtractSPL(ds); end %Unknown dataset format ...

%---------------------------------------local functions---------------------------------------
function SPL = Try2ExtractSPL(ds)
%Try to retrieve SPL using the virtual field spl of a dataset

NChan   = 2 - sign(ds.dachan);
NSub    = ds.nsub;
NSubRec = ds.nrec;

SPL = repmat(NaN, NSub, NChan);

try 
    [NRow, NCol] = size(ds.spl);
    SPL(1:NSubRec, 1:NChan) = repmat(ds.spl, (NSubRec-NRow)+1, (NChan-NCol)+1); 
end 

%---------------------------------------------------------------------------------------------
function SPL = ExtractSPL4SGSR(ds)
%SGSR datasets: SPL is always a field of the StimParam structure and is given as a 
%scalar for datasets with only one active channel, and a two-element row-vector for
%datasets with two active channels ...

NChan   = 2 - sign(ds.dachan);
NSub    = ds.nsub;
NSubRec = ds.nrec;

SPL = repmat(NaN, NSub, NChan);

if any(strcmpi(ds.StimType, {'NRHO', 'ARMIN', 'BN', 'BERT'})),
    SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
    SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
%If dataset doesn't belong to any of the above then try to retrieve SPL using the virtual
%field spl of a dataset ...
else, SPL = Try2ExtractSPL(ds); end

%---------------------------------------------------------------------------------------------
function SPL = ExtractSPL4IDF_SPK(ds)
%IDF/SPK datasets: For SPL and NSPL datasets the SPL-settings are found as a column-
%vector in 'IndepVar.Values'. For appropriate other datasets the SPL is found in the field
%'indiv.stim{}.spl'. Again given as a scalar for datasets with only one active channel, and
%a two-element row-vector for datasets with two active channels. NTD-datasets are an 
%exception to this rules and the SPL can be extracted in the same way as with SGSR datasets ...

NChan   = 2 - sign(ds.dachan);
NSub    = ds.nsub;
NSubRec = ds.nrec;

SPL = repmat(NaN, NSub, NChan);

if any(strcmpi(ds.StimType, {'ITD', 'FS', 'FSLOG', 'BFS', 'FM', 'LMS', 'BB', 'CFS', 'CTD'})),
    SPL(1:NSubRec, 1) = ds.StimParam.indiv.stim{1}.spl;
    SPL(1:NSubRec, NChan) = ds.StimParam.indiv.stim{end}.spl;
elseif strcmpi(ds.StimType, 'IMS'),
    if isequal(ds.StimParam.indiv.stim{1}.lospl, ds.StimParam.indiv.stim{1}.hispl) & ...
            isequal(ds.StimParam.indiv.stim{end}.lospl, ds.StimParam.indiv.stim{end}.hispl)
        SPL(1:NSubRec, 1) = ds.StimParam.indiv.stim{1}.lospl;
        SPL(1:NSubRec, NChan) = ds.StimParam.indiv.stim{end}.lospl;
    end
elseif any(strcmpi(ds.StimType, {'SPL', 'NSPL'})), 
    SPL(:, 1:NChan) = repmat(ds.indepval, 1, NChan);    
elseif any(strcmpi(ds.StimType, 'NTD')),
    SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
    SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
%If dataset doesn't belong to any of the above then try to retrieve SPL using the virtual
%field spl of a dataset ...
else, SPL = Try2ExtractSPL(ds); end

%---------------------------------------------------------------------------------------------
function SPL = ExtractSPL4EDF(ds)
%EDF datasets: SPL is always a field of the StimParam structure except for TH and CALIB
%datasets. It is a scalar for datasets with only one active channel, and a two-element
%row-vector for datasets with two active channels. If the SPL is varied for a dataset then
%SPL is a matrix with the same number of rows as total number of subsequences. If not 
%completely recorded then the SPL values aren't set to NaN. If not applicable for a dataset
%then the value is set to NaN. This also works for datasets with two independent variables.

NChan   = 2 - sign(ds.dachan);
NSub    = ds.nsub;
NSubRec = ds.nrec;

SPL = repmat(NaN, NSub, NChan);

if ~any(strcmpi(ds.ExpType, {'TH', 'CALIB'}))
    if size(ds.StimParam.SPL, 1) > 1,
        SPL(1:NSubRec, :) = ds.StimParam.SPL(1:NSubRec, :);
    else,    
        SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
        SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
    end
end    

%---------------------------------------------------------------------------------------------
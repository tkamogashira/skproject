function CALIBds = GetCALIB4ds(ds, DSSName)
%GETCALIB4DS    get calibration dataset for an EDF dataset
%   CALIBDS = GETCALIB4DS(DS) returns the appropriate calibration 
%   dataset for the given EDF dataset. The calibration dataset 
%   corresponding with the master DSS is returned.
%
%   CALIBDS = GETCALIB4DS(DS, 'slave') returns the calibration
%   dataset corresponding with the slave DSS of a binaural EDF
%   dataset.

%B. Van de Sande 26-04-2004

%Checking input parameters ...
if ~any(nargin == [1, 2]), error('Wrong number of input parameters.'); end
if ~isa(ds, 'EDFdataset'), error('First argument should be EDF dataset.'); end
if (nargin == 1), DSSName = 'master';
elseif ~any(strncmpi(DSSName, {'m', 's'}, 1)), error('Optional second argument should be specification of DSS.'); end

%Retrieving number of DSS ...
if strncmpi(DSSName, 'm', 1), DSSNr = ds.mdssnr;
elseif (ds.dssnr == 2) & strncmpi(DSSName, 's', 1), DSSNr = ds.sdssnr;
else, error('Slave DSS is never used for a monaural dataset.'); end

%The valid calibration dataset should be in the same datafile and should be for
%the appropriate DSS number. If more than calibration datasets are present then
%the one most recently recorded with respect to the supplied dataset should be
%taken ...
FileName = ds.FileName;
LUT      = log2lut(FileName);
SeqNr    = ds.iSeq;

idx = find(strcmpi({LUT.SchName}, 'calib') & (cat(2, LUT.iSeq) < SeqNr));
CalibIDs = {LUT(idx).IDstr}; NDS = length(CalibIDs);
if (NDS ~= 0),
    for n = 1:NDS, CalibDSs(n) = dataset(FileName, CalibIDs{n}); end
    CalibDSSNrs = cat(2, CalibDSs.mdssnr);
    
    idx = max(find(CalibDSSNrs == DSSNr));
    CALIBds = CalibDSs(idx);
else, CALIBds = []; end
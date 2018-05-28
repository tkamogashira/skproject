function boolean = existEDF(FileName)
%EXISTEDF check if EDF datafile exists

%B. Van de Sande 29-07-2003

if nargin ~= 1, error('Wrong number of input arguments.'); end

FullFileName = parseEDFFileName(FileName);

if ~exist(FullFileName, 'file'), boolean = logical(0);
else, boolean = logical(1); end
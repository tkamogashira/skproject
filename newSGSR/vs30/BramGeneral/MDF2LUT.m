function LUT = MDF2LUT(FileName)
%MDF2LUT get lookup table for MDF datafile
%   T = MDF2LUT(FN) makes lookup table T with all entries from MDF datafile given by FN
%
%   See also LOG2LUT

%B. Van de Sande 05-04-2004

LUT = ManageMDF(FileName, 'list');
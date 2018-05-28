function iReps = ExpandiReps(ArgIn, iSubSeqs, iReps)
%EXPANDIREPS expand included repetitions property
%   iReps = EXPANDIREPS(Spt, iSubSeqs, iReps) expands the property for the repetition
%   included in the analysis when a dataset is given as input to the function.
%
%   iReps = EXPANDIREPS(Spt, iSubSeqs, iReps) expands the property for the repetition
%   included in the analysis when a cel-array of spiketrains is given as input to the
%   function.
%
%   The repetitions included in the analysis must be supplied as a numerical
%   vector or a cell-array with numerical vectors and the same length as the number
%   of subsequences. The shortcuts 'all' represents all repetitions.
%   If the included repetition list is invalid then the empty matrix is returned.

%B. Van de Sande 25-03-2004

if isa(ArgIn, 'dataset'), NRep = ArgIn.nrep; else NRep = size(ArgIn, 2); end

if ischar(iReps) & strcmpi(iReps, 'all'), iReps = repmat({1:NRep}, 1, length(iSubSeqs));
elseif isnumeric(iReps) & any(size(iReps) == 1) & all(ismember(iReps, 1:NRep)), 
    iReps = repmat({iReps(:)'}, 1, length(iSubSeqs));
elseif iscell(iReps) & isequal(length(iReps), length(iSubSeqs)),
    iReps = iReps(:)';
else, iReps = []; end
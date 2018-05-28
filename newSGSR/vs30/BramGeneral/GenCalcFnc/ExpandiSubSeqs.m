function iSubSeqs = ExpandiSubSeqs(ArgIn, iSubSeqs)
%EXPANDISUBSEQS expand included subsequences property
%   iSubSeqs = EXPANDISUBSEQS(ds, iSubSeqs) expands the property for
%   the subsequences included in the analysis when a dataset is given
%   as input to the function.
%
%   iSubSeqs = EXPANDISUBSEQS(Spt, iSubSeqs) expands the property for
%   the subsequences included in the analysis when a cel-array of spiketrains
%   is given as input to the function.
%
%   The subsequences included in the analysis must be supplied as a numerical
%   vector. The shortcuts 'all' represents all subsequences.
%   If the included subsequences list is invalid then the empty matrix is returned.

%B. Van de Sande 23-03-2004

% ---------------- CHANGELOG -----------------------
%  Mon Jan 24 2011  Abel   
%   reformatted IF functions

if isa(ArgIn, 'dataset')
	NRec = ArgIn.nrec; 
else
	NRec = size(ArgIn, 1); 
end

if ischar(iSubSeqs) && strcmpi(iSubSeqs, 'all')
	iSubSeqs = 1:NRec;
elseif ~isnumeric(iSubSeqs) || ~any(size(iSubSeqs) == 1) || ~all(ismember(iSubSeqs, 1:NRec))
	iSubSeqs = [];
else
	iSubSeqs = iSubSeqs(:)'; 
end
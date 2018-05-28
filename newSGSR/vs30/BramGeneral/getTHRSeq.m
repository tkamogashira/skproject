function [seqNr, dsTHR] = getTHRSeq(dataFile, cellNr)
% getTHRSeq - Get THR sequence for this particular data file and cell number
%
% [seqNr, dsTHR] = getTHRSeq(dataFile, cellNr)
%
% Get THR sequence for this particular data file and cell number, without
% using the user data. The THR dataset object is returned as second output parameter.

%B. Van de Sande 29-08-2003
%K. Spiritus

% ---------------- CHANGELOG -----------------------
%  Mon Jan 17 2011  Abel	* Check if the found sequence is really a THR
%								curve by looking at the stimtype.
%							* The THR dataset is now returned als output.
%							* Cleaned code / rewrite function
%  Fri Jan 21 2011  Abel   
%   - bugfix, when no THR found, set dsTHR to NaN

%% ---------------- Default parameters --------------
force = 1;			% Force caching to off

%% ---------------- Main program --------------------
% Get all cell numbers with "th*" in the sequence ID 
lookUpTable = log2lut(dataFile, force);
idList = char(lookUpTable.IDstr);
try
	allCellNrs = char2num(idList);
catch exception
	seqNr = NaN;
	warning('SGSR:Debug', 'Unable to get THR sequence for datafile:%s, error:%s', ...
		dataFile, exception.message);
	return
end

% Get all THR sequence ID's 
index = get_thr_sequence_nr_(idList, allCellNrs, cellNr);

% Return [] if nothing found 
if isempty(index)
	seqNr = NaN;
	dsTHR = NaN;
 	warning('SGSR:Debug', 'Unable to get THR sequence for cell:%d', cellNr);
	return;
end

% sort declining (consensus says last THR cure in list should be used)
index = sort(index, 'descend');

% Loop over THR ID's and  test if found sequence is really a THR curve (typo in identifier?)
for n=1:length(index)
	seqNr = lookUpTable(index(n)).iSeq;
	dsTHR = dataset(dataFile, seqNr);
	isThr = any(strcmpi(dsTHR.stimtype, {'th', 'thr'}));
	
	% return if Thr was found else reset 
	if isThr
		return;
	else
		warning('SGSR:Info', ... 
			'Last THR sequence for cell:%d was of the wrong stimtype, typo in sequence identifier? Taking previous sequence', ...
			cellNr);
		[seqNr, dsTHR, isThr]  = deal(NaN);
	end
end

%If we get this far, nothing was found
warning('SGSR:Info', 'Unable to get THR sequence for cell:%d', cellNr);

end
%% ---------------- Local functions -----------------
%{
	get_max_thr_sequence_nr_:
	Find last sequence number in list which contains 'th' in the
	indetifier
%}
function idx = get_thr_sequence_nr_(idList, allCellNrs, cellNr)
	idx = intersect(find(allCellNrs == cellNr), strfindcell(lower(idList), 'th'));
end

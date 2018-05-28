function [SeqNr, FullID] = getSeqNr4dsID(LUT, dsID)
%GETSEQNR4DSID get sequence number of dataset for a given identifier
%   [SeqNr, FullID] = GETSEQNR4DSID(LUT, ID), where LUT is the lookup table for a given experiment and
%   ID is the dataset identifier
%
%   See also LOG2LUT, GetSeqNrs4Cell

%B. Van de Sande 15-12-2003, replacement for ID2iseq ... compatible with EDF datasets ...

SeqNr  = NaN; 
FullID = '';

%Dataset identifiers are interpreted as case-insensitive ...
dsIDs = upper(char(LUT.IDstr));
idx = strmatch(upper(dsID), dsIDs); 
if ~isempty(idx) & (length(idx) == 1), %Exact match ...
    SeqNr  = LUT(idx).iSeq; 
    FullID = LUT(idx).IDstr;
else, 
    %Try checking with cell and testnumber only, if this resolves to a unique solution
    %then successful ...
    try, [CellNr, TestNr] = unraveldsID(dsID); catch, return; end
    idx = ismember(char2num(dsIDs, 2, '-'), [CellNr, TestNr], 'rows');
    if ~isempty(idx) & (length(idx) == 1), 
        SeqNr  = LUT(idx).iSeq;
        FullID = LUT(idx).IDstr;
    end
end
function [SeqNrs, idx] = getSeqNrs4Cell(LUT, CellNr)
%GETSEQNRS4CELL get sequence numbers of datasets that belong to a cell
%   [SeqNrs, idx] = GETSEQNRS4CELL(LUT, CellNr), where LUT is the lookup table for a given experiment and
%   CellNr is the number of the cell
%
%   See also LOG2LUT, getSeqNr4dsID

%B. Van de Sande 10-12-2003

SeqNrs = cat(2, LUT.iSeq);
idx = find(char2num(char(LUT.IDstr)) == CellNr);
SeqNrs = SeqNrs(idx);
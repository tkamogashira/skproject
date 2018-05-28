function SeqNr = getTHRSeq(DataFile, CellNr)

%B. Van de Sande 29-08-2003

LUT = log2lut(DataFile);
IDList = char(LUT.IDstr);
AllCellNrs = char2num(IDList);

idx = max(intersect(find(AllCellNrs == CellNr), strfindcell(IDList, 'THR')));
if ~isempty(idx), SeqNr = LUT(idx).iSeq; else, SeqNr = NaN; end
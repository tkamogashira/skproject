function ID = iseq2id(FN, iseq);
% ISEQ2ID - convert SGSR sequence number to PXJ-style string identifier
%   ISEQ2ID(FN, I) returns the identifier of the I-th seq of datafile FN.
%   I>0 -> IDF/SPK file; 
%   I<0 -> SGSR file; 
%

ID = '';
lut = log2lut(FN);
iseqs = cat(2, lut.iSeq);
ii = find(iseqs==iseq);
if ~isempty(ii), ID = lut(ii(end)).IDstr; end;






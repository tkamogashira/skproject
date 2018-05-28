function refRow = getRefRow(CLR)
% GETREFROW Gets the refrow from the corrListResult instance.
%
% refRow = getRefRow(CLR)
% Returns the dataset information from the corrListResult instance CLR.
% This method only works for CLR instances of calcType refRow.

if ~isequal('refrow', lower(CLR.calcType))
    error(['Can''t get refRow for corrListResult of type ' CLR.calcType '.']);
end
refRow = CLR.refRow;
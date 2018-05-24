function S = sortstruct(S, FieldName)
%SORTSTRUCT sort structure array
%   S = SORTSTRUCT(S, FieldName) sorts structure S by fieldname FieldName. If S is a multi-dimensional
%   structure, S is reshaped to a column vector.

%B. Van de Sande 24-03-2003 Oude versie, wordt enkel gebruikt SetTableData.m dat deel uitmaakt van interface
%voor Table-objecten.

if nargin ~= 2, error('Wrong number of input arguments.'); end 
if ~isstruct(S), error('First argument should be structure array.'); end
if ~ischar(FieldName) | ~isfield(S, FieldName), error('Second argument should be fieldname to sort by.'); end

if ~((ndims(S) == 2) & (min(size(S)) == 1)), S = reshape(S, prod(size(S), 1)); end

%Bubble algorithm ...
NItems = length(S); FullPassWithoutChange = 0; NPass = 1;
while (~FullPassWithoutChange) & (NPass <= NItems)
    FullPassWithoutChange = 1;
    for ItemNr = 1:(NItems-1)
        ValueBottom = getfield(S(ItemNr), FieldName);
        ValueTop    = getfield(S(ItemNr+1), FieldName);
        if Compare('>', ValueBottom, ValueTop)
            FullPassWithoutChange = 0;
            [S(ItemNr), S(ItemNr+1)] = swap(S(ItemNr), S(ItemNr+1));
        end    
    end
    NPass = NPass + 1;
end

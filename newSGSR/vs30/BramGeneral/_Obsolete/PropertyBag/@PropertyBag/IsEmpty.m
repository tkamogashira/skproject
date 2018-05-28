function boolean = IsEmpty(PB)
%PROPERTYBAG/ISEMPTY    true for empty property bag.
%   ISEMPTY(PB) returns 1 if PB is an empty property bag and 0
%   otherwise.

%B. Van de Sande 06-05-2004

boolean = isempty(PB.Properties);
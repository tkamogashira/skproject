function boolean = isempty(ML)
%ISEMPTY    check if metalng object only contains one element.
%   boolean = ISEMPTY(<metalng object>) checks if metalng object only contains one element.
%   This element is sink and source at the same time.

%B. Van de Sande 09-10-2003

if length(ML) == 1, boolean = logical(1);
else, boolean = logical(0); end
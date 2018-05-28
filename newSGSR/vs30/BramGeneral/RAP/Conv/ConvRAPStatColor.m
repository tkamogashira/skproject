function Str = ConvRAPStatColor(RGB)
%ConvRAPStatColor  convert RAP status variable color entry to string
%   Str = ConvRAPStatColor(RGB) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

Str = upper(RGB2ColSym(RGB));
if isempty(Str), Str = [ mat2str(RGB) ' RGB']; end

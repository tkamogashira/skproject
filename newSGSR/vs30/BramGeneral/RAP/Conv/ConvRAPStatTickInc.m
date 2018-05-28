function Str = ConvRAPStatTickInc(TickInc)
%ConvRAPStatTickInc  convert RAP status variable TickInc entry to string
%   Str = ConvRAPStatTickInc(TickInc)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

if ischar(TickInc), Str = TickInc;
else, Str = num2str(TickInc); end
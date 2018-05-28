function Str = ConvRAPStatLabel(Str)
%ConvRAPStatLabel  convert RAP status label entry to string
%   Str = ConvRAPStatLabel(Label)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

if isempty(Str), Str = 'standard';
else Str = ['''' Str '''']; end
function Str = ConvRAPStatLimits(Lim)
%ConvRAPStatLimits  convert RAP status variable limits entry to string
%   Str = ConvRAPStatLimits(Lim)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

if all(isinf(Lim)), Str = 'auto';
else,
    Str = '[';
    if isinf(Lim(1)), Str = [Str 'auto'];
    else, Str = [Str num2str(Lim(1))]; end   
    Str = [Str ' '];    
    if isinf(Lim(2)), Str = [Str 'auto'];
    else, Str = [Str num2str(Lim(2))]; end
    Str = [Str ']'];    
end


function Str = RAPRange2Str(Range)
%RAPRange2Str   converts RAP range of numbers to character string
%   Str = RAPRange2Str(Range) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 08-04-2004

if isempty(Range)
    Str = 'N/A'; 
elseif length(Range) == 1
    Str = num2str(Range);
else
    idx = (diff(Range) == 1);
    Str = ['[', num2str(Range(1))]; 
    n = 1;
    while n < length(idx),
        if (idx(n) == 1) & (idx(n+1) == 1)
        elseif (idx(n) == 1)
            Str = [Str, ':', num2str(Range(n+1))];
        elseif (idx(n) == 0)
            Str = [Str, ',', num2str(Range(n+1))]; 
        end
        n = n + 1;
    end
    if (idx(end) == 1)
        Str = [Str, ':', num2str(Range(end)), ']'];
    else
        Str = [Str, ',', num2str(Range(end)), ']']; 
    end
end
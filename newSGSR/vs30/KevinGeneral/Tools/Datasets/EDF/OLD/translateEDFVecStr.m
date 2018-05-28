function N = translateEDFVecStr(S)

%B. Van de Sande 04-08-2003

if isempty(S) | strcmp(S, 'N/A'), N = NaN;
else,  
    [N, dummy, Err] = sscanf(S, '%f');
    if ~isempty(Err), N = lower(deblank(S)); end
end
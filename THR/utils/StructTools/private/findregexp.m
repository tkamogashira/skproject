function I = findregexp(C, P)
%FINDREGEXP find regular expression in a cell-array of strings
%   I = FINDREGEXP(C, P) finds the pattern given by P in the cell-array of strings C. Pattern may contain
%   the wildcards * and ?.
%
%   When using MATLAB 6.5 (R13) use built-in functions REGEXP, REGEXPI and REGEXPREP

%B. Van de Sande 23-07-2003

if nargin ~= 2, error('Wrong number of input arguments.'); end
if ~iscellstr(C), 
    if ~ischar(C) | ndims(C) ~= 2 | ~any(size(C) == 1), error('First argument should be cell-array of strings or character string.');
    else, C = cellstr(C); end    
end
if ~ischar(P) | ndims(P) ~= 2 | ~any(size(P) == 1), error('Second argument should be pattern to search for.'); end

Pl      = length(P);
AstI    = findstr(P, '*');
AstTok  = parsestr(P, '*'); 
AstNTok = length(AstTok);

C = C(:)';
N = length(C); Iexc = []; prevI = 0;
for n = 1:N,
    S = C{n}; Sl = length(S);
    for nTok = 1:AstNTok,
        if isempty(AstTok{nTok}), continue; end
        
        idx = findpattern(S, AstTok{nTok});
        if length(idx) > 1, idx = min(idx(find(idx > prevI))); end
        
        %Bijzonder geval: eerste patroon voor asteriks ...
        if nTok == 1,
            if isempty(idx) | idx ~= 1, Iexc = [Iexc, n]; break; else, prevI = 1; end
        %Standaard geval: patronen tussen asteriksen, en laatste patroon na asteriks ...
        elseif isempty(idx) | ...
               (idx < (prevI + length(AstTok{nTok-1}) - 1)) | ...
               (idx > (Sl - (Pl - AstI(nTok-1) - (AstNTok - nTok)) + 1))
        %Oude voorwaarde, minder streng: (idx < AstI(nTok-1))
            Iexc = [Iexc, n]; break;
        else, prevI = idx; end
    end    
end
I = setdiff(1:N, Iexc);

%------------------------------------------lokale functies-------------------------------------------------------
function I = findpattern(S, P)

I = [];

Ns = length(S); Np = length(P);
if Ns < Np, return; end

QueI = findstr(P, '?'); P(QueI) = [];

for n = 1:Ns-Np+1,
    tmp = S(n:n+Np-1); tmp(QueI) = [];
    if strcmp(tmp, P), I = [I, n]; end;
end
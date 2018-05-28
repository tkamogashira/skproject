function Nrs = char2num(CharA, N, Sep)
%CHAR2NUM   extract numbers out of two dimensional character array
%   N = char2num(CA, Ncol, Sep) extracts Ncol columns of numbers out of two dimensional character array CA.
%   The columns of numbers must be separated by the characters in Sep. All the non-cipher characters after the
%   last column are discarded. By default Ncol is one and the separator is a dash.

%B. Van de Sande 10-12-2003
%13-08-2003: In replacement of EXTRACT1NRS.M
%10-12-2003: NaN's are returned at the right place in the output vector, i.e. where a number cannot be
%extracted from a row of the character array a NaN is placed in the output vector ...

if nargin == 1
    N = 1; 
    Sep = '-';
elseif nargin == 2
    Sep = '-';
elseif nargin < 0 | nargin > 3
    error('Wrong number of input arguments.'); 
end

[NRow, NCol] = size(CharA); NSeps = zeros(NRow, 1);
for c = 1:NCol
    if all(isnan(NSeps))
        break
    end
    
    idx = find(ismember(CharA(:, c), [Sep, 65:90, 97:122])); %ASCII numbers for A-Z and a-z ...
    if isempty(idx)
        continue
    elseif (c ~= 1)
        NSeps(idx) = NSeps(idx) + 1; 
    else         
        CharA(idx, 1:end) = char(32);
        NSeps(idx) = NaN;
    end
    
    idx = find(NSeps > N-1);
    if ~isempty(idx)
        CharA(idx, c:end) = char(32);
        NSeps(idx) = NaN;
    end    
end 

excidx = strmatch(blanks(NCol), CharA, 'exact'); 
Nexc = length(excidx);
incidx = setdiff(1:NRow, excidx); 
Ninc = length(incidx);
if (Ninc == 0)
    Nrs = repmat(NaN, Nexc, N); 
    return
end
CharA = CharA(incidx, :);

CharA = [CharA, repmat(char(13), Ninc, 1)];
CharA = CharA'; 
CharA = CharA(:)';    

Pattern = [repmat(['%f', Sep], 1, N-1), '%f', char(13)];
[Nrs, Count, Err] = sscanf(CharA, Pattern);
if ~isequal(Count, N*Ninc)
    Nrs = [Nrs; repmat(NaN, N*Ninc-Count, 1)]; 
end;

if length(Nrs) == 2
    Nrs = Nrs';
else 
    idx = repmat((1:N:(N*Ninc))', 1, N) + repmat(0:N-1, Ninc, 1);
    Nrs = Nrs(idx);
end

if (Nexc ~= 0)
    Nrs(incidx, :) = Nrs; 
    Nrs(excidx, :) = NaN; 
end
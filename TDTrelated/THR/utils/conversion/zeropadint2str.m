function Str = zeropadint2str(K, Nmax)
% zeropadint2str - convert integer to fixed length string by padding zeros
%    zeropadint2str(31, 7) returns '0000031', i.e. enough zeros are padded
%    to reach a length of at least 7.
%
%    zeropadint2str(A, N) for arrays A returns a cell array of strings.

if numel(K)>1, % recursion
    [K, Nmax] = sameSize(K, Nmax);
    K = num2cell(K);
    Nmax = num2cell(Nmax);
    Str = cellfun(fhandle(mfilename), K, Nmax, 'uniformOutput', false);
    return;
end

% single-element K from here
K = real(K);
Neg = K<0; 
K = abs(K);
Str = int2str(K);
Nz = Nmax-numel(Str);
if Neg, Nz=Nz-1; end
Str = [repmat('0', 1, Nz) Str];
if Neg, Str = ['-' Str]; end



function I = varname2int(s);
% varname2int - convert variable name to integer
%    varname2int(s) is an integer number constructed by treating the
%    character of string s as digits of 37-base numbers. The digits, in
%    order, are: 
%        0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_
%    Thus varname2int is not case sensitive.
% See also base2dec.

if ~isvarname(s),
    error('Input strings s is not a valid Matlab variable name.');
end

% convert digits of s to 1:37
D = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_'.';
ND = numel(D);
s = upper(s);
N = numel(s);
for ii=1:N,
    d(N+1-ii) = strmatch(s(ii), D);
end
I = sum(d.*ND.^(0:N-1));










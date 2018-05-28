function [x, Str] = kstr2num(Str);
% kstr2num = convert k-string to number, e.g. 3k4 -> 3400
%    kstr2num(Str) returns the number represented by k-string Str.
%    This notation uses 'k' like a decimal point to separate the thousands
%    (left from 'k') and the hundreds, tens, etc (right from 'k').
%
%    Multiple numbers in kstr result in an array of doubles.
%    Nans are returned for uninterpretable sStr elements.
%    Str is not evaluated except for '[]' and ';' indicating arrangement of 
%    matrix elements. 
%
%    Examples
%        kstr2num('3k4') returns 3400
%        kstr2num('k4') returns 400
%        kstr2num('1k2345') returns 1.2345
%        kstr2num('[k5 3k; 2 1k]') returns [500 3000; 2 1000]
%        kstr2num('[5k55 pi]') returns [5550 nan]
%
%    See also str2doublemat.

if ~ischar(Str); error('Str input arg must be char string.'); end
% try reading as is by delegating to str2doublemat
x = str2doublemat([ '[' Str ']' ]);
inan = find(isnan(x));
if isempty(inan), return; end % no k's to replace

% now replace 'k' by decimal point and read again
Str = strrep(Str, 'k', '.');
xk = str2doublemat([ '[' Str ']' ]);
x(inan) = 1000*xk(inan);
if all(~isnan(x)),
    Str = debrace(mat2str(x));
end


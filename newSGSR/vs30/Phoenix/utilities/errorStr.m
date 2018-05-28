function s = ErrorStr(s);
% errorStr - convert char matrix or cell string to string for error fnc
%   errorStr(S) converts S to a single row vector of char with
%   char(10) as newlines. This makes it a valid argument for ERROR.
%
%   See ERROR.

s = char(s);
height = size(s,1); 
s = [s repmat(char(10), height,1)].';
s = s(:).';



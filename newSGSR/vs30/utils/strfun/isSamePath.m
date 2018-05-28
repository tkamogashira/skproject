function s = isSamePath(d1,d2);
% ISSAMEPATH - check if to strings describe the same directory or file
%   usage: ISSAMEPATH(D1,D2), D1 and D2 FULL paths.
%   trailing backslashes are ignored, i.e., c:\aa is the same as c:\aa\
d1 = lower(trimspace(d1));
d2 = lower(trimspace(d2));
s = 0;
if isempty(d1) | isempty(d2), return; end;
if ~ischar(d1), return; end;

if d1(end)=='\', d1=d1(1:end-1);  end;
if d2(end)=='\', d2=d2(1:end-1);  end;
s = isequal(d1,d2);




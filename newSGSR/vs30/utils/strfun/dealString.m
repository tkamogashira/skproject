function dstr = dealString(str);
% dealString - convert linefeed-delimited string to char matrix
%   DealStr(S) is char matrix obtained from char string S by
%   starting a new line after each linefeed. Lines that are
%   shorter than other lines are padded with spaces.

% append last linefeed
if ~isequal(str(end),char(10)), str= [str char(10)]; end;
lfs = [0 find(str==char(10))];
dstr = '';
for ii = 1:(length(lfs)-1),
   strRange = (1+lfs(ii)):(lfs(ii+1)-1);
   dstr = strvcat(dstr, str(strRange));
end

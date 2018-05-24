function dstr = dealString(str);
% dealString - convert char string containing linefeeds to char matrix
%   dealString(str) converts string containing linefeeds (char(10)) 
%   to string matrix.
%   
%   Example
%      LF = char(10); 
%      dealstring(['first line' LF 'second and last line'])
%      ans =
%        first line          
%        second and last line

% append last linefeed
if ~isequal(str(end),char(10)), str= [str char(10)]; end;
lfs = [0 find(str==char(10))];
dstr = '';
for ii = 1:(length(lfs)-1),
   strRange = (1+lfs(ii)):(lfs(ii+1)-1);
   dstr = strvcat(dstr, str(strRange));
end

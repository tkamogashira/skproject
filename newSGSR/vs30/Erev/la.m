function LastBanana(N);
% Lastbanana - do banana analysis on most recent data set(s)

if nargin<1, N = 1; end;
if ischar(N), N = str2num(N); end;
qqq = currentSGSRindex-1;

[PPP NNN] = fileparts(datafile);

banana(NNN, {qqq-N+1:qqq});




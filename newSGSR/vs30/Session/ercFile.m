function sf=ercFile(ext);
% ERCFILE - returns full name w/o extension of erc file defined at session init
%    ERCFILE(EXT) adds extension. If EXT does not start with '.', a dot is prepended.
%    An empty string is returned if no SESSION was properly defined
if nargin<1, ext = '';
elseif ext(1)~='.',
   ext = ['.' ext];
end

global SESSION
try
   sf = [SESSION.ERCfile ext];
catch
   sf = '';
end

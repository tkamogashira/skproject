function sf=dataFile(ext);
% DATAFILE - returns full name w/o extension of data file defined at session init
%    DATAFILE(EXT) adds extension. If EXT does not start with '.', a dot is prepended.
%    An empty string is returned if no SESSION was properly defined
if nargin<1, ext = '';
elseif ext(1)~='.',
   ext = ['.' ext];
end

global SESSION
try
   sf = [SESSION.dataFile ext];
catch
   sf = '';
end

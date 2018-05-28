function typelog(lognam);
% TYPELOG - type log file

EXT = '.log';
if nargin<1,
   logFile = dataFile(EXT);
else,
   logFile = FullFileName(lognam, datadir, EXT);
end

if isempty(logFile), error('No log file defined.'),
end

if ~exist(logFile,'file'),
   error(['Log file ''' logFile ''' not found.']);
end

type(logFile);

function editLog(lognam);
% EDITLOG - edit log file

EXT = '.log';
if nargin<1,
   logFile = dataFile(EXT);
else,
   logFile = [datadir filesep lognam EXT];
end
if isempty(logFile), 
   error('No log file defined - no session initialized.'); 
end; 
try
   edit(logFile);
catch
   error(['Unable to open log file '''  logFile '''' ]);
end

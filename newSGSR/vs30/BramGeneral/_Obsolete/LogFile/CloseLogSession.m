function CloseLogSession
%CLOSELOGSESSION closes a logfile 
%   CLOSELOGSESSION
%
%   See also OPENLOGSESSION, WRITELOGITEM

global LOGFILE_FID LOGFILE_SESSION

%Parameters nagaan ...
if nargin > 0, error('Wrong number of input arguments'); end

%LogFile sessie afsluiten ...
if isempty(LOGFILE_FID), error('No session active'); end

fprintf(LOGFILE_FID,'----------------------------------------------------------------------------------------------------\n');
fclose(LOGFILE_FID);
[LOGFILE_FID, LOGFILE_SESSION] = deal([]);

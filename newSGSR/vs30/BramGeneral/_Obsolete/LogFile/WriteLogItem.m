function WriteLogItem(ItemName, ItemContents)
%WRITELOGITEM   writes an item in a logfile
%   WRITELOGITEM(ItemName, ItemContents)
%   Input parameters
%   ItemName     : name of item to be saved in logfile
%   ItemContents : character string to be saved
%
%   See also OPENLOGSESSION, CLOSELOGSESSION

global LOGFILE_FID LOGFILE_SESSION

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input arguments'); end
if ~ischar(ItemName) | ~ischar(ItemContents), error('Arguments should be character strings'); end

%Item wegschrijven ...
if isempty(LOGFILE_FID), error('No session active'); end

fprintf(LOGFILE_FID, [ '[' ItemName ']\n' ]);
fprintf(LOGFILE_FID, [ ItemContents '\n' ]);


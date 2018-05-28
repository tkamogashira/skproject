function sServerName = KMailServer(sServerName)
% KMailServer - return name of Kmail folder
%   ServerOut = KMailServer(ServerIn)
%     Return or set string containing location of the server
%
%        ServerIn: if specified, the server location is changed. This location should exist. 
%        ServerOut: returns current setting
%
%   See also Kmail.

CFN = [setupDir '\' mfilename '.setup']; % cache file name
CacheParam.prop = 'serverdir'; 
Nmax = 1e3; 

% The mailbox for this computer
thisMailbox = strrep(CompuName, '-', '_');

if nargin < 1, % get
    % from cache ..
    sServerName = FromCacheFile(CFN, CacheParam);
    % factory
    if isempty(sServerName), % do it yourself
        sServerName = 'm:\';
    end
end

% nargin>=1: set
if ~exist(sServerName,'dir'),
    error(['Folder ''' sServerName ''' not found (check connections if netdrive was specified).'])
end    


% provide trailing '\' if needed
if ~isequal('\', sServerName(end)),
   sServerName = [sServerName '\'];
end

if isempty(thisMailbox)
    error('Set CompuName before using KMail!');
end

if ~exist([sServerName '\' thisMailbox], 'dir')
   warning(['A subdir ''' thisMailbox ''' does not exist in ''' sServerName '''.']); %#ok<WNTAG>
end

% store in cache
if nargin > 0
    ToCacheFile(CFN, Nmax, CacheParam, sServerName);    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
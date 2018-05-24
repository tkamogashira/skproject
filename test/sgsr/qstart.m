function qstart(UN, varargin);
% QSTART - user-specific startup function
%     STARTUP DRIES runs C:\USR\DRIES\MATLABSTARTUP\QSTART.M 
%     STARTUP DRIES X Y .. passes optional arguments to QSTART.

%% ------------- CHANGELOG -------------
%   19/01/2010  Abel    Addapted to matlab2010b
global UserName
UserName = UN;

userDir = ['c:\USR\' UserName];
Qdir = [userDir '\MATLABSTARTUP'];
Qfile = [Qdir '\QSTART'];

%Check installed
if ~exist(Qdir,'dir'),
   error(['Directory ''' Qdir ''' not found.']);
end
if ~exist([Qfile '.m'],'file'),
   error(['File ''' Qfile ''' not found.']);
end

%Check startup folder for version 2010b
% check matlab version
V = version;
versionnum = str2num(V(1));

if versionnum > 6
    userpath(userDir);
end

cd(Qdir);

qstart(varargin{:});

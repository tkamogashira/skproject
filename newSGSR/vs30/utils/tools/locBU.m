function locBU(Ndays);
% LOCBU - backup of local settings, etc (no exp data)
%   LOCBU(N) zips all relevant setup files not older than N days into zip file

if nargin<2, allFlag=0; end
more off;
dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

if atBigScreen,
   zipDir = ['C:\usr\Marcel\ToUtrecht'];
   sourceDir = 'C:\SGSRwork\';
   location = 'Leuven';
elseif inUtrecht,
   error NYI
   zipDir = ['E:\ToLeuven'];
   sourceDir = 'D:\SGSRdevelop';
   location = 'Utrecht';
elseif atSnail,
   error NYI
   % syncsnail % dataview dir is local
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'B:\SGSRdevelop';
   location = 'Leuven';
else, 
   error NYI
   warning('no developer machine');
   return;
end;


global SGSRDIR
Xfile = [fileparts(SGSRDIR) '\developOnly\local\nozipLocBU.txt'];
Xclude = ['-x@' Xfile];
zipName = [zipDir '\LOC_SGSR' location datestr(now,1)];

% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rp ' Xclude ' ' dateArg zipName ' ' sourceDir '\*.*' ]
eval(cmd)






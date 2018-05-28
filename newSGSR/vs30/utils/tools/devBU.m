function devBU(Ndays, allFlag);
% DEVBU - developer backup
%   DEVBU(N) zips all relevant source files not older than N days into zip file

if nargin<2, allFlag=0; end
more off;
dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

if atBigScreen,
   zipDir = ['C:\usr\Marcel\ToUtrecht'];
   sourceDir = 'C:\SGSRdevelop';
   location = 'Leuven';
elseif atcel,
   zipDir = ['D:\backups\SGSR\toLeuven'];
   sourceDir = 'D:\SGSRdevelop';
   location = 'Utrecht';
elseif inUtrecht,
   zipDir = ['E:\ToLeuven'];
   sourceDir = 'D:\SGSRdevelop';
   location = 'Utrecht';
elseif atSnail,
   % syncsnail % dataview dir is local
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'B:\SGSRdevelop';
   location = 'Leuven';
else, 
   warning('no developer machine');
   return;
end;


global SGSRDIR
Xfile = [fileparts(SGSRDIR) '\developOnly\local\nozipDevBU.txt'];
if allFlag, 
   Xclude = '';
   zipName = [zipDir '\SGSR_FULL_' location datestr(now,1)];
else, 
   Xclude = ['-x@' Xfile];
   zipName = [zipDir '\SGSR' location datestr(now,1)];
end

% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rp ' Xclude ' ' dateArg zipName ' ' sourceDir '\*.*' ]
eval(cmd)






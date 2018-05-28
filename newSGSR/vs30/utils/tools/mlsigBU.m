function mlsigBU(Ndays);
% MLSIGBU - MLSIG develop backup
%   MLSIGBU(N) zips all relevant MLSIG files not older than N days into zip file
if nargin<1, Ndays=5e3; end; % ever

dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

if atBigScreen,
   zipDir = ['C:\usr\Marcel\ToUtrecht'];
   sourceDir = 'C:\MLsigDevelop';
   location = 'Leuven';
   XCL = ' -x@C:\MLsigDevelop\DevelopOnly\resources\doNotZip.txt '
elseif inUtrecht,
   zipDir = ['E:\ToLeuven'];
   sourceDir = 'D:\MLsigDevelop';
   location = 'Utrecht';
   XCL = ' -x@D:\MLsigDevelop\DevelopOnly\resources\doNotZip.txt '
elseif atSnail,
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'B:\MLSIGdevelop';
   location = 'Leuven';
   XCL = ' -x@B:\MLsigDevelop\DevelopOnly\resources\doNotZip.txt '
else,
   error('not in Leuven or Utrecht');
end;

zipName = [zipDir '\MLSIG' location datestr(now,1)];


% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rp ' XCL dateArg zipName ' ' sourceDir '\*.* ' ]
eval(cmd)






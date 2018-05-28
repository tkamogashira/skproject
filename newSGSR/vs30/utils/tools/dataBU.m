function dataBU(Ndays);
% DATABU - backup of processed data
%   DATABU(N) zips all relevant documents not older than N days into zip file
if nargin<1, Ndays=7; end; % last week

dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

if atbigscreen,
   zipDir = ['C:\usr\Marcel\ToUtrecht'];
   sourceDir = 'C:\usr\Marcel\data';
   location = 'Leuven';
elseif atcel,
   zipDir = ['D:\Sync\ToLeuven'];
   sourceDir = 'D:\data';
   location = 'Utrecht';
elseif inUtrecht,
   zipDir = ['E:\ToLeuven'];
   sourceDir = 'D:\data';
   location = 'Utrecht';
elseif atSnail,
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'C:\data';
   location = 'Leuven';
else,
   error('unknown location');
end;

zipName = [zipDir '\procData' location datestr(now,1)];


% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rp ' dateArg zipName ' ' sourceDir '\*.* ' ]
eval(cmd)





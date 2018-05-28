function docBU(Ndays);
% DOCBU - document dir backup
%   DOCBU(N) zips all relevant documents not older than N days into zip file
if nargin<1, Ndays=7; end; % last week

dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))]
dateArg = [' -tf' fromDate ' '];

if atbigscreen,
   error('docs must be saved from Snail');
   %zipDir = ['C:\usr\Marcel\ToUtrecht'];
   %sourceDir = 'C:\USR\Marcel\doc';
   %location = 'Leuven';
elseif atSnail,
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'C:\doc';
   location = 'Leuven';
elseif atcel,
   zipDir = ['D:\Sync\ToLeuven'];
   sourceDir = 'D:\doc';
   location = 'Utrecht';
elseif inUtrecht,
   zipDir = ['E:\ToLeuven'];
   sourceDir = 'D:\doc';
   location = 'Utrecht';
else,
   error('Invalid location');
end;

zipName1 = [zipDir '\DOCs1' location datestr(now,1)];
zipName2 = [zipDir '\DOCs2' location datestr(now,1)];


% construct wzzip command line and execute it via DOS call
cmd1 = ['!"c:\program files\winzip\wzzip" -rp ' dateArg zipName1 ' ' sourceDir '\*.* ' ]
eval(cmd1)





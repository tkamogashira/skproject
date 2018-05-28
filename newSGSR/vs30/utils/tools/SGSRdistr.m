function SGSRdistr(Ndays);
% SGSRdistr - generate zip file for distribution to other computers
if nargin<1, Ndays = 3e3; end

if ~atBigscreen,
   error('not at bigscreen');
end
more off;

global SGSRDIR

dd = datevec(datenum(now)-Ndays);
fromDate = [num2str(dd(1)) '-' num2str(dd(2)) '-' num2str(dd(3))];
dateArg = [' -tf' fromDate ' '];

zipDir = ['C:\Distr'];
sourceDir = SGSRDIR;

zipName = [zipDir '\SGSRdistr' datestr(now,1)];


% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rpo ' dateArg zipName ' ' sourceDir '\*.doc ' sourceDir '\*.m '  sourceDir '\*.dll '  sourceDir '\*.fig' ]

eval(cmd)










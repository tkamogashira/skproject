function y=SGSRversion(unpack);
% SGSRversion - use WinZip to pack new SGSR version
%   syntax: SGSRversion(unpack)
if ~isDeveloper, return; end;

if nargin<1, unpack=0; end;

more off;

if atBigScreen,
   % error NYimpl
   zipDir = ['C:\usr\Marcel\Backup\SGSRversions\test']; % do not overwrite official versions
   global SGSRDIR
   sourceDir = SGSRDIR;
   % files to be excluded from distribution
   XCL = ' -x@C:\SGSRdevelop\developOnly\Resources\SGSRexcludeList.txt ';
elseif inUtrecht,
   zipDir = ['E:\backups\SGSR\versions\test']; % do not overwrite official versions
   global SGSRDIR
   sourceDir = SGSRDIR;
   % files to be excluded from distribution
   XCL = ' -x@D:\SGSRdevelop\developOnly\Resources\SGSRexcludeList.txt ';
elseif atSnail,
   error NYimpl
   zipDir = ['C:\BACKUP\ToUtrecht'];
   sourceDir = 'S:\SGSRdevelop';
   location = 'Leuven';
else, warning('no developer machine');
end;

global Versions
index = Versions.mostRecent;
CV = Versions.numbers(index);
Vstr = ['vs' num2sstr(CV*10)];
zipName = [zipDir '\SGSR' Vstr];
if exist([zipName '.zip'], 'file'),
   delete([zipName '.zip']);
end


% construct wzzip command line and execute it via DOS call
cmd = ['!"c:\program files\winzip\wzzip" -rp ' XCL zipName ' ' sourceDir '\*.m ' sourceDir '\*.fig' ' ' sourceDir '\*.dll ' sourceDir '\*.doc'];
cmd
eval(cmd)


% unpack to test dir
if unpack,
   if ~inUtrecht, error NYimpl; end;
   UnpackDir = 'D:\TestSGSR\'
   cmd = ['!"c:\program files\winzip\wzunzip" -od ' zipName ' ' UnpackDir];
end
eval(cmd)



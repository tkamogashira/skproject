function unzipData(sourceDir, destDir);
% unzipData - unzip datafiles
%   unzipData(sourceDir, destDir) unzips all zip file from folder sourceDir and
%   extracts the files to folder destDir.



% wzunzip test.zip c:\docs\

zipList = dir([sourceDir '\*.zip']);
for ii=1:length(zipList),
   source = [sourceDir '\' zipList(ii).name];
   % construct wzunzip command line and execute it via DOS call
   cmd = ['!"c:\program files\winzip\wzunzip" ' source '  ' destDir '\']
   eval(cmd);
end








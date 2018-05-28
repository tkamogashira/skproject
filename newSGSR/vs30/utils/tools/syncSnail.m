function syncSnail;


global VERSIONDIR
zipDir = ['C:\TEMP'];
destDir = lower([VERSIONDIR '\dataview']);
sourceDir = strSubst(destDir, 's:\sgsrdevelop\sgsr\', 'C:\SGSR\');
location = 'Leuven';

zipName = [zipDir '\DATAVIEW-' location datestr(now,1)];



Xstr = ' -x*.SGSRsetup -x*.flag -x*.def -x*.databrowse -x*.dparam '; % winzip's exclude params
% pack command
cmd1 = ['!"c:\program files\winzip\wzzip" -rp ' Xstr zipName ' ' sourceDir '\*.*' ]
% unpack command
cmd2 = ['!"c:\program files\winzip\wzunzip" -do ' zipName ' ' destDir '\' ]

eval(cmd1)
eval(cmd2)
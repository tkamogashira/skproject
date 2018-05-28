function CheckMLversion(minVersion)
qqq = ver('matlab');
CurVersion = str2double(qqq.Version);
if CurVersion<minVersion
   wh = warndlg({['SGSR is written for MatLab version ' num2str(minVersion) ' and newer.'],...
         'Using older MatLab versions may cause errors.'}, 'Obsolete MatLab version', 'modal');
   waitfor(wh);
end

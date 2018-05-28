function getDistr;
% getDistr - get newest SGSR distr over local network
%  OBSOLETE = replaced by makedistr & updateSGSR

if exist('s:\SGSRdistrGuard.txt'), DDir = 's:\';
else, DDir = '\\bigscreen\distr';
end
if atBigScreen,
   DestDir = 'C:\TEMP\testDistr';
else,
   DestDir = 'C:\SGSR';
end

% find out which zip file in distr dir is most recent
qq = dir(DDir);
recentdate = -inf;
theDistr = '';
for ii=1:length(qq),
   qqq= qq(ii);
   fn = qqq.name;
   if ~qqq.isdir,
      if StrEndsWith(lower(fn),'.zip');
         dn = datenum(qqq.date);
         if dn>recentdate,
            theDistr = qqq.name;
            recentdate = dn;
         end
      end
   end
end

% make local copy of most recent distr 
dfn = [DDir '\' theDistr];
copyfile(dfn, [tempdir theDistr]);
dfn = [tempdir theDistr];
ls(dfn)

% unpack
CurDir = pwd;
try,
   cd(DestDir);
   cmd = ['!"c:\program files\winzip\wzunzip" -do ' dfn]
   eval(cmd)
end
cd(CurDir);







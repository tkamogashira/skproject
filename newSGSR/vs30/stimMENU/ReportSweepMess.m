function [OK, newLow] = ReportSweepMess(mess, oldLow, sugLow, ...
   hlow, hstep, hhigh, name1, name2, ndigit);

textcolors;
newLow = oldLow;
OK = 0;
switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      ['end 'name1 ' values']);
   UIerror(mess, hstep);
   return;
case 'DIFF#STEPS',
   mess = strvcat('unequal # sweep steps','for the two channels');
   UIerror(mess, [hlow hstep hhigh]);
   return;
case 'BIGADJUST',
   mess = strvcat('non-integer # sweep steps',...
      'between low & high ' name2 ':',...
      'low beat freq will be adjusted');
   if StimMenuWarn(mess, hlow), return; end;
   newLow = sugLow;
   setstring(hlow,num2str(newLow,ndigit));
   UItextColor(hlow, BLACK);
case 'SMALLADJUST',
   newLow = sugLow;
   setstring(hlow,num2str(newLow,ndigit));
end
OK = 1;

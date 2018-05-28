function [OK, SPL] = SPLsweepChecker(pp, hh);

OK = 0;
textcolors;

[SPL, mess] = sweepChecker(pp.startSPL, pp.stepSPL, pp.endSPL, pp.active);
switch mess
case 'ZEROSTEP',
   mess = strvcat('zero step size','but unequal start- and',...
      'end SPL values');
   UIerror(mess, hh.StepSPLEdit);
   return;
case 'DIFF#STEPS',
   mess = strvcat('unequal # sweep steps','for the two channels');
   UIerror(mess, [hh.StartSPLEdit hh.StepSPLEdit hh.EndSPLEdit]);
   return;
case 'BADSTEP',
   mess = strvcat('non-integer # sweep steps','between start and end SPLs');
   UIerror(mess, [hh.StartSPLEdit hh.StepSPLEdit hh.EndSPLEdit]);
   return;
end

OK = 1;
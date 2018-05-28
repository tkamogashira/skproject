function StimDurReport(DS, PRP);
% StimDurReport - report estimated stimulus duration
%    StimDurReport(DS, PRP) reports estimated stimulus duration
%    to the standard reporter window. DS is the dataset, PRP is 
%    the current paramset value of the stimulus dashboard.
%    (the latter affects the duration through the stutter status)
%    
%    See also OUIreport

Ncond = DS.ncond;
doStutter = PRP.stutter.as_logical;
if doStutter, Ncond = Ncond+1; end

Dur = ceil(1e-3*DS.repdur*DS.nrep*Ncond);
Nminute = floor(Dur/60);
Nseconds = rem(Dur,60);
mess = strvcat('Estimated duration:', ['---' num2str(Nminute) ' min ' num2str(Nseconds) ' sec ---']);
if doStutter,
   mess = strvcat(mess, '( STUTTER is ON)');
end

OUIreport(mess,'-append');



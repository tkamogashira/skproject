function cds = curDS(DS);
% CURDS - current dataset,i.e., dataset most recenly visited by databrowse
persistent CDS
if nargin>0, % update
   CDS = DS;
end
cds = CDS;
   
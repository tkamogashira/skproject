function SCHName = DCPName2SCHName(DCPName)

%B. Van de Sande 02-09-2003



IndepVarName = {'NONE', 'STMDUR', 'DUR',  'REPINT', 'DELAY', 'FCARR', 'FREQ', 'PHASE', 'FMOD', 'DMOD', 'PHASEM', 'PHASM', 'DSNUM', 'SPL', 'ITRATE',  'ITD1', 'SGITD1', 'ITD2', 'SGITD2', 'AZIMTH', 'ELEVTN'};
SchDataName  = {'NONE', 'DUR1',   'DUR1', 'REPINT', 'DELM',  'FREQ',  'FREQ', 'PHASE', 'FMOD', 'DMOD', 'PHASM',  'PHASM', 'GWDS',  'SPL', 'ITDRATE', 'ITD1', 'ITD1',   'ITD2', 'ITD2',   'AZIMTH', 'ELEVTN'};

idx = find(ismember(IndepVarName, VName));
if ~isempty(idx), VName = SchDataName{idx}; 
else, warning(sprintf('%s is not a known name of an independent variable. Assuming same name for schema entry.', VName)); end

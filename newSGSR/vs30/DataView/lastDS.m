function lds = lastDS(DS);
% LastDS - most recently saved dataset from running experiment
%    Note: the dataset is read back from file to avoid any inconsistencies

global SESSION
if isempty(SESSION), error('No session has been initialized.'); end
[dum DF] = fileparts(SESSION.dataFile);
iseq = SESSION.iJustRecorded;
if isnan(iseq),
   error('No sequence has been recorded during this session');
end
%DF, iseq
lds = dataset(DF,iseq);





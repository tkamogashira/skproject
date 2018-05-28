function EDFds = createEmptyEDFdataset

%B. Van de Sande 28-05-2004

ID          = struct('SchName', '');
Sizes       = struct('Ntimers', []);
EDFData     = struct([]);
TimerNrs    = [];
DSS         = struct('Nr', [], 'Mode', '');
EDFIndepVar = struct('Name', '', 'ShortName', '', 'Values', [], 'Unit', '', 'PlotScale', '', 'DSS', '');
SchData     = struct([]);

EDFds = CollectInStruct(ID, Sizes, EDFData, TimerNrs, DSS, EDFIndepVar, SchData);
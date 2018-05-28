function TimerNrs = extractSCHTimerNrs(SchData)

%B. Van de Sande 27-05-2004
%This parameter can only be extracted from datasets with schemata sch006, sch012 and sch016 ...

TimerNrs = SchData.UETCH';
function [DSSParam, Err] = extractSCHDSSParam(SchData)

%B. Van de Sande 04-05-2004.
%These parameters can only be extracted from datasets with schemata sch008, sch012 and sch016 ...

Err = 0;

if ~any(strcmp(SchData.SchName, {'sch006', 'sch008', 'sch012', 'sch016'})), DSSParam = struct([]); return; end

Nr = SchData.NUMDSS; DSSNrs = [SchData.DSSDAT.DSSN]; 

MasterNr   = SchData.MDSS; 
MasterIdx  = find(DSSNrs == MasterNr);
MasterMode = translateDSSMode(SchData.DSSDAT(MasterIdx).MODE);

%MSLAVE-field gives Master or slave mode of DSS (1=master,2=slave) ...
if SchData.DSSDAT(MasterIdx).MSLAVE ~= 1, Err = 1; return; end

if Nr > 1, 
    if MasterNr  == 1, SlaveNr  = 2; else, SlaveNr  = 1; end
    if MasterIdx == 1, SlaveIdx = 2; else, SlaveIdx = 1; end
    SlaveMode = translateDSSMode(SchData.DSSDAT(SlaveIdx).MODE);
    
    if SchData.DSSDAT(SlaveIdx).MSLAVE ~= 2, Err = 1; return; end
else, [SlaveNr, SlaveIdx, SlaveMode] = deal([]); end    

DSSParam = CollectInStruct(Nr, MasterNr, MasterIdx, MasterMode, SlaveNr, SlaveIdx, SlaveMode);
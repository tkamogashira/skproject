function StatTbParam = extractSCHStatTbParam(SchData, DsLoc)

%B. Van de Sande 04-05-2004

if ~any(strcmp(SchData.SchName, {'sch006', 'sch012', 'sch016'})), StatTbParam = struct([]); return; end

%If STFORM is missing from the dataset header then a Type-2 table should be assumed...
if isfield(SchData, 'STFORM'), StatTbParam.Type = SchData.STFORM;
else, StatTbParam.Type = 2; end    

StatTbParam.Loc  = (4*(SchData.LSTAT-1)) + 512*(DsLoc - 1); %Location of table in bytes from beginning of EDF ...
StatTbParam.NPtr = SchData.NUMPT;
StatTbParam.Nseq = SchData.NSEQ;

StatTbParam.SponAct = SchData.SDATA;
StatTbParam.SpkData = SchData.UDATA;
StatTbParam.AnaData = SchData.ADATA;
StatTbParam.CycData = SchData.CDATA;
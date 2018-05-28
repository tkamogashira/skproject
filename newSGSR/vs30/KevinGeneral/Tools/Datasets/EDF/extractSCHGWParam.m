function [GWParam, ShiftGWParam, SchData, Err] = extractSCHGWParam(SchData, DSSParam)

%B. Van de Sande 23-06-2004
%These parameters can only be extracted from datasets with schemata sch006, sch012 and sch016.
%The mode of the DSSs should be GWR, GWS or GAM ...

Err = 0;

if ~any(strcmp(SchData.SchName, {'sch006', 'sch012', 'sch016'})), [GWParam, ShiftGWParam] = deal(struct([])); return; end

%General General Waveform parameters ...
FileName = deblank(SchData.DSSDAT(DSSParam.MasterIdx).GWFIL); %GW-filename (including VMS directory information)...
ID       = deblank(SchData.DSSDAT(DSSParam.MasterIdx).GWID);  %ID of dataset in the specified datafile ...
if isfield(SchData.DSSDAT, 'GWDS'),                           %Dataset number in the datafile ...
    [DSNr, SchData, Err] = evalDCPExpr('GWDS', 'master', SchData, DSSParam); 
    if Err, return; end
else, DSNr = NaN; end
if isfield(SchData.DSSDAT, 'GWNUMP'),                         %Number of points in the time-domain of the waveform ...
    NPoints = SchData.DSSDAT(DSSParam.MasterIdx).GWNUMP; 
else, NPoints = NaN; end
PbPer    = SchData.DSSDAT(DSSParam.MasterIdx).GWRES;          %Sample period of the time-domain waveform in microsec ...
if isfield(SchData.DSSDAT, 'GWSINC'),                         %Start increment in number of points ...
    NStart = SchData.DSSDAT(DSSParam.MasterIdx).GWSINC;
else, NStart = NaN; end
%Information on effective SPL computation ...
if isfield(SchData.DSSDAT, 'GWESPL'), ComputedEffSPL = SchData.DSSDAT(DSSParam.MasterIdx).GWESPL; %Effective SPL computed or not ...
else, ComputedEffSPL = 0; end
if ComputedEffSPL,
    EffSPL  = SchData.DSSDAT(DSSParam.MasterIdx).EFFSPL;           %Effective SPL in dB ...
    CalibID = deblank(SchData.DSSDAT(DSSParam.MasterIdx).CALID); %ID of calibration dataset used in computation ...
else, 
    EffSPL  = NaN; 
    CalibID = ''; 
end    

if DSSParam.Nr > 1,
    FileName = { FileName, deblank(SchData.DSSDAT(DSSParam.SlaveIdx).GWFIL)};
    ID       = { ID, deblank(SchData.DSSDAT(DSSParam.SlaveIdx).GWID)};
    if isfield(SchData.DSSDAT, 'GWDS'), 
        [DSNr2, SchData, Err] = evalDCPExpr('GWDS', 'slave', SchData, DSSParam); 
        if Err, return; end
        [DSNr, Err] = getEDFBinParam(DSNr, DSNr2);
        if Err, Err = 2; return; end
    else, DSNr = [DSNr, NaN]; end
    if isfield(SchData.DSSDAT, 'GWNUMP'), NPoints = [NPoints, SchData.DSSDAT(DSSParam.SlaveIdx).GWNUMP]; else, NPoints = [NPoints, NaN]; end
    PbPer    = [PbPer, SchData.DSSDAT(DSSParam.SlaveIdx).GWRES];
    if isfield(SchData.DSSDAT, 'GWSINC'), NStart = [NStart, SchData.DSSDAT(DSSParam.SlaveIdx).GWSINC]; else, NStart = [NStart, NaN]; end

    if isfield(SchData.DSSDAT, 'GWESPL'), ComputedEffSPL = SchData.DSSDAT(DSSParam.SlaveIdx).GWESPL; else, ComputedEffSPL = 0; end
    if ComputedEffSPL,
        EffSPL  = [EffSPL, SchData.DSSDAT(DSSParam.SlaveIdx).EFFSPL];
        CalibID = { CalibID, deblank(SchData.DSSDAT(DSSParam.SlaveIdx).CALID)};
    else, EffSPL = [EffSPL, NaN]; CalibID = {CalibID, ''}; end    
end    

GWParam = CollectInStruct(FileName, ID, DSNr, NPoints, PbPer, NStart, EffSPL, CalibID); %Playback resolution in microseconds ...

%Shifted GEWAB settings are only used on the slave DSS ...
if DSSParam.Nr > 1 & all(ismember({'ITD1', 'ITD2', 'ITDRATE'}, fieldnames(SchData.DSSDAT))),
    [ITD1, SchData, Err] = evalDCPExpr('ITD1', 'slave', SchData, DSSParam); if Err, return; end
    [ITD2, SchData, Err] = evalDCPExpr('ITD2', 'slave', SchData, DSSParam); if Err, return; end
    [ITDRate, SchData, Err] = evalDCPExpr('ITDRATE', 'slave', SchData, DSSParam); if Err, return; end
    
    ShiftGWParam = CollectInStruct(ITD1, ITD2, ITDRate); %Units are microseconds ...
else, ShiftGWParam = struct([]); end
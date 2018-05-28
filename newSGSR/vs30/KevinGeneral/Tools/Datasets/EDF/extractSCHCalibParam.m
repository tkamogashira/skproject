function CalibParam = extractSCHCalibParam(SchData)

%B. Van de Sande 06-08-2003

if ~strcmp(SchData.SchName, 'calib'), CalibParam = struct([]); end

DSSNr     = SchData.DSSN;
Nharm     = SchData.NHARM;
CorrCurve = lower(deblank(SchData.CORCRV));
[RiseDur, FallDur] = deal(SchData.RFTIME * 1e3);

CalibParam = CollectInStruct(DSSNr, Nharm, CorrCurve, RiseDur, FallDur);
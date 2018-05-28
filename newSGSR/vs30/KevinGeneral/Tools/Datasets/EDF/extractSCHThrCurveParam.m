function ThrCurveParam = extractSCHThrCurveParam(SchData)

%B. Van de Sande 06-08-2003

if ~strcmp(SchData.SchName, 'sch008'), ThrCurveParam = struct([]); end

ThrCurveParam.CritNr = SchData.NCRIT;
ThrCurveParam.MaxSPL = SchData.MAXSPL;
ThrCurveParam.NSponRec = SchData.NSPON;
ThrCurveParam.MeanSA = SchData.MSPON;
ThrCurveParam.StdSA  = SchData.SDSPON;
ThrCurveParam.TrgSA  = SchData.TARSPK;
ThrCurveParam.TrgSI  = SchData.TARSYN; 
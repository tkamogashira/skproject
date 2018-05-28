function GenWaveFormParam = extractSCHGenWaveFormParam(SchData)

%B. Van de Sande 23-04-2004

if ~strcmp(SchData.SchName, 'sch005'), CalibParam = struct([]); end

NPoints   = SchData.NUMPTS;
PbPer     = SchData.TRES;
Code      = SchData.GWCODE;
RandSeed  = SchData.SEED;

%Effective SPL computation ...
if isfield(SchData, 'ESDAT'),
    idx = find(any([SchData.ESDAT.ESKOD])); N = length(idx);
    if (N >= 1),
        for n = 1:N,
            EffSPLComp(n).DSSNr     = SchData.ESDAT(idx(n)).DSSN;
            EffSPLComp(n).EffSPL    = SchData.ESDAT(idx(n)).ESPL;
            EffSPLComp(n).CalibID   = deblank(SchData.ESDAT(idx(n)).CALIDE);
        end    
    else, EffSPLComp = struct([]); end
else, EffSPLComp = struct([]); end    

GenWaveFormParam = CollectInStruct(EffSPLComp, NPoints, PbPer, Code, RandSeed);
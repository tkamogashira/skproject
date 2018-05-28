function [NRep, NRepM, NRepS] = extractSCHNRep(SchData, DSSParam)

%B. Van de Sande 04-05-2004.
%This parameter can only be extracted from datasets with schemata sch008, sch012 and sch016 ...

if ~any(strcmp(SchData.SchName, {'sch006', 'sch008', 'sch012', 'sch016'})), [NRep, NRepM, NRepS] = deal(NaN); return; end

NRep = SchData.NREPMD;

if nargin > 1,
    Tmp = SchData.DSSDAT(DSSParam.MasterIdx).NREPS;
    if ~isempty(Tmp) & ~ischar(Tmp), NRepM = Tmp; else NRepM = translateEDFVecStr(Tmp); end
    
    if DSSParam.Nr > 1,
        Tmp = SchData.DSSDAT(DSSParam.SlaveIdx).NREPS;
        if ~isempty(Tmp) & ~ischar(Tmp), NRepS = Tmp; 
        else
            %For the slave DSS the number of repetitions can be given by referring to the settings of the master DSS ... 
            NRepS = translateEDFVecStr(Tmp); 
            if ischar(NRepS), NRepS = NRepM; end
        end
    else, NRepS = NaN; end
else, [NRepM, NRepS] = deal(NaN); end    
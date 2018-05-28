function ArgOut = AssembleRAPCalcParam(RAPStat, Fields, Mode)
%AssembleRAPCalcParam    assembles RAP calculation parameters in character string
%   Str = AssembleRAPCalcParam(RAPStat, Fields, 'single') returns a character string
%   with the calculation parameters for all the subsequences included.
%
%   CellStr = AssembleRAPCalcParam(RAPStat, Fields, 'multi') returns a cellarray of
%   strings, each cell contains the calculation parameters for one subsequence.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

if ischar(Fields)
    Fields = cellstr(Fields); 
end

if strncmpi(Mode, 's', 1), %Single mode ...
    NFields = length(Fields); 
    CellStr = cell(0);
    for n = 1:NFields,
        switch Fields{n}
        case 'SubSeqs',     CellStr{end+1} = sprintf('\\itSubSeqs:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'SubSeqs'));   
        case 'Reps',        CellStr{end+1} = sprintf('\\itReps:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'Reps'));
        case 'AnWin',       CellStr{end+1} = sprintf('\\itAnWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'AnWin'));
        case 'ReWin',       CellStr{end+1} = sprintf('\\itReWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ReWin'));
        case 'NBin',        CellStr{end+1} = sprintf('\\itNBin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'NBin'));
        case 'BinWidth',    CellStr{end+1} = sprintf('\\itBinWidth:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'BinWidth'));
        case 'BinFreq',     CellStr{end+1} = sprintf('\\itBinFreq:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'BinFreq'));
        case 'MinISI',      CellStr{end+1} = sprintf('\\itMinISI:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MinISI'));
        case 'ConSubTr',    CellStr{end+1} = sprintf('\\itConSub:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ConSubTr'));
        case 'CorBinWidth', CellStr{end+1} = sprintf('\\itBinWidth:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CorBinWidth'));
        case 'CorMaxLag',   CellStr{end+1} = sprintf('\\itMaxLag:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CorMaxLag'));
        case 'RayCrit',     CellStr{end+1} = sprintf('\\itRayCrit:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'RayCrit'));
        case 'PhaseConv',   CellStr{end+1} = sprintf('\\itPhaseConv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PhaseConv'));
        case 'CompDelay',   CellStr{end+1} = sprintf('\\itCompDelay:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CompDelay'));
        case 'UnWrapping',  CellStr{end+1} = sprintf('\\itUnWrapping:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'UnWrapping'));    
        case 'IntNCycles',  CellStr{end+1} = sprintf('\\itIntNCycles:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'IntNCycles'));
        case 'AvgWin',      CellStr{end+1} = sprintf('\\itAvgWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'AvgWin'));
        case 'MinNInt',     CellStr{end+1} = sprintf('\\itMinNInt:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MinNInt'));
        case 'HistRunAv',   CellStr{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'HistRunAv'));    
        case 'CurveRunAv',  CellStr{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CurveRunAv'));    
        case 'PklRunAv',    CellStr{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklRunAv'));    
        case 'EnvRunAv',    CellStr{end+1} = sprintf('\\itEnvRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'EnvRunAv'));    
        case 'PklRateInc',  CellStr{end+1} = sprintf('\\itRateInc:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklRateInc'));    
        case 'PklPkWin',    CellStr{end+1} = sprintf('\\itPeakWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklPkWin'));    
        case 'PklSrWin',    CellStr{end+1} = sprintf('\\itSrWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklSrWin'));    
        case 'ThrQ',        CellStr{end+1} = sprintf('\\itQThr:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ThrQ'));                
        case 'SyncThr',     CellStr{end+1} = sprintf('\\itCutOffThr:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'SyncThr'));                    
        case 'MaxPST',      CellStr{end+1} = sprintf('\\itMaxPST:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxPST'));
        case 'MaxISI',      CellStr{end+1} = sprintf('\\itMaxISI:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxISI'));
        case 'MaxFSL',      CellStr{end+1} = sprintf('\\itMaxFSL:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxFSL'));
        case 'SignLevel',   CellStr{end+1} = sprintf('\\itSignLevel:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'SignLevel'));
        case 'BootStrap',   CellStr{end+1} = sprintf('\\itBootStrap:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'BootStrap'));
        end
    end
    ArgOut = CellStr;
else, %Multi mode ...
    iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); 
    BinFreq  = GetRAPCalcParam(RAPStat, 'nr', 'BinFreq');
    ds = RAPStat.GenParam.DS; XIndepVal = ds.xval; mIndep = 0;
    if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr > 1), YIndepVal = ds.yval; mIndep = 1; end
    
    NSubSeqs = length(iSubSeqs); NFields = length(Fields); Str = cell(NSubSeqs, 1);
    %First entry always contains all requested fields ...
    nSubSeq = 1;
    for n = 1:NFields,
        switch Fields{n}
        case 'SubSeqs',     Str{1}{end+1} = sprintf('\\itSubSeq:\\rm %d', iSubSeqs(nSubSeq));
        case 'IndepVal', 
            if ~mIndep, Str{1}{end+1} = sprintf('\\itIndepVal:\\rm %s', IndepVal2Str(XIndepVal(iSubSeqs(nSubSeq)), ds.xunit));
            else, Str{1}{end+1} = sprintf('\\itIndepVal:\\rm %s/ %s', IndepVal2Str(XIndepVal(iSubSeqs(nSubSeq)), ds.xunit), IndepVal2Str(YIndepVal(iSubSeqs(nSubSeq)), ds.yunit)); end;    
        case 'Reps',        Str{1}{end+1} = sprintf('\\itReps:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'Reps'));
        case 'AnWin',       Str{1}{end+1} = sprintf('\\itAnWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'AnWin'));
        case 'ReWin',       Str{1}{end+1} = sprintf('\\itReWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ReWin'));
        case 'NBin',        Str{1}{end+1} = sprintf('\\itNBin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'NBin'));
        case 'BinWidth',    Str{1}{end+1} = sprintf('\\itBinWidth:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'BinWidth'));
        case 'BinFreq',     Str{1}{end+1} = sprintf('\\itBinFreq:\\rm %.0f Hz', BinFreq(nSubSeq));
        case 'MinISI',      Str{1}{end+1} = sprintf('\\itMinISI:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MinISI'));
        case 'ConSubTr',    Str{1}{end+1} = sprintf('\\itConSub:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ConSubTr'));
        case 'CorBinWidth', Str{1}{end+1} = sprintf('\\itBinWidth:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CorBinWidth'));
        case 'CorMaxLag',   Str{1}{end+1} = sprintf('\\itMaxLag:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CorMaxLag'));
        case 'RayCrit',     Str{1}{end+1} = sprintf('\\itRayCrit:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'RayCrit'));
        case 'PhaseConv',   Str{1}{end+1} = sprintf('\\itPhaseConv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PhaseConv'));
        case 'CompDelay',   Str{1}{end+1} = sprintf('\\itCompDelay:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CompDelay'));
        case 'UnWrapping',  Str{1}{end+1} = sprintf('\\itUnWrapping:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'UnWrapping'));    
        case 'IntNCycles',  Str{1}{end+1} = sprintf('\\itIntNCycles:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'IntNCycles'));
        case 'AvgWin',      Str{1}{end+1} = sprintf('\\itAvgWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'AvgWin'));
        case 'MinNInt',     Str{1}{end+1} = sprintf('\\itMinNInt:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MinNInt'));
        case 'HistRunAv',   Str{1}{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'HistRunAv'));    
        case 'CurveRunAv',  Str{1}{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'CurveRunAv'));    
        case 'PklRunAv',    Str{1}{end+1} = sprintf('\\itRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklRunAv'));    
        case 'EnvRunAv',    Str{1}{end+1} = sprintf('\\itEnvRunAv:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'EnvRunAv'));    
        case 'PklRateInc',  Str{1}{end+1} = sprintf('\\itRateInc:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklRateInc'));    
        case 'PklPkWin',    Str{1}{end+1} = sprintf('\\itPeakWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklPkWin'));    
        case 'PklSrWin',    Str{1}{end+1} = sprintf('\\itSrWin:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'PklSrWin'));    
        case 'ThrQ',        Str{1}{end+1} = sprintf('\\itQThr:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'ThrQ'));                
        case 'SyncThr',     Str{1}{end+1} = sprintf('\\itCutOffThr:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'SyncThr'));                
        case 'MaxPST',      Str{1}{end+1} = sprintf('\\itMaxPST:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxPST'));
        case 'MaxISI',      Str{1}{end+1} = sprintf('\\itMaxISI:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxISI'));
        case 'MaxFSL',      Str{1}{end+1} = sprintf('\\itMaxFSL:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'MaxFSL'));
        case 'SignLevel',   Str{1}{end+1} = sprintf('\\itSignLevel:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'SignLevel'));
        case 'BootStrap',   Str{1}{end+1} = sprintf('\\itBootStrap:\\rm %s', GetRAPCalcParam(RAPStat, 's', 'BootStrap'));
        end
    end
    %All other entries only contain requested fields that are varied ...
    if (length(unique(BinFreq)) > 1)
        IncFields = {'SubSeqs', 'IndepVal', 'BinFreq'};
    else
        IncFields = {'SubSeqs', 'IndepVal'}; 
    end
    idx = find(ismember(Fields, IncFields)); 
    Fields = Fields(idx);
    NFields = length(Fields);
    if (NFields ~= 0),
        for nSubSeq = 2:NSubSeqs,
            for n = 1:NFields,
                switch Fields{n}
                    case 'SubSeqs'
                        Str{nSubSeq}{end+1} = sprintf('\\itSubSeq:\\rm %d', iSubSeqs(nSubSeq));
                    case 'IndepVal',
                        if ~mIndep
                            Str{nSubSeq}{end+1} = sprintf('\\itIndepVal:\\rm %s', IndepVal2Str(XIndepVal(iSubSeqs(nSubSeq)), ds.xunit));
                        else
                            Str{nSubSeq}{end+1} = sprintf('\\itIndepVal:\\rm %s/ %s', IndepVal2Str(XIndepVal(iSubSeqs(nSubSeq)), ds.xunit), IndepVal2Str(YIndepVal(iSubSeqs(nSubSeq)), ds.yunit));
                        end;
                    case 'BinFreq'
                        Str{nSubSeq}{end+1} = sprintf('\\itBinFreq:\\rm %.0f Hz', BinFreq(nSubSeq));
                end
            end
        end
    elseif (NSubSeqs > 1)
        [Str{2:NSubSeqs}] = deal({''});
    end
    ArgOut = Str;
end

%----------------------------local functions----------------------------------
function Str = IndepVal2Str(Val, Unit)

if mod(Val, 1)
    Str = sprintf('%.2f (%s)', Val, Unit);
else
    Str = sprintf('%.0f (%s)', Val, Unit); 
end
function [GenStimParam, SchData, Err] = extractSCHGenStimParam(SchData, DSSParam)

%B. Van de Sande 09-07-2004

%Attention! Each stimulus can consist of two components (e.g. a tone and a noise), DUR1 and DELAY1 refer to the
%duration and delay of the main stimulus, while DUR2 and DELAY2 are the duration and delay of the masking stimulus.
%The data collected by Philip Joris never uses this facility, so it isn't implemented.
%DELM denotes the master delay and should be interpreted as the initial delay before the stimulus is presented.
%Do not confuse this terminology with master and slave DSS, it has nothing to do with this. Even the slave DSS
%can have a master delay.

GenStimParam = struct([]); Err = 0;

switch SchData.SchName
case {'sch006', 'sch012', 'sch008'}
    [BurstDur, SchData, Err] = evalDCPExpr('DUR1', 'master', SchData, DSSParam);
    if Err, return; end
    [RepDur, SchData, Err] = evalDCPExpr('REPINT', 'master', SchData, DSSParam);
    if Err, return; end
    
    [RiseDur, SchData, Err] = evalDCPExpr('RTIME', 'master', SchData, DSSParam);
    if Err, return; end
    [FallDur, SchData, Err] = evalDCPExpr('FTIME', 'master', SchData, DSSParam);
    if Err, return; end

    [Delay, SchData, Err] = evalDCPExpr('DELM', 'master', SchData, DSSParam);
    if Err, return; end
    
    if any(strcmp(SchData.SchName, {'sch006', 'sch012'})),
        [SPL, SchData, Err] = evalDCPExpr('SPL', 'master', SchData, DSSParam);
        if Err, return; end
    else, SPL = NaN; end    

    if DSSParam.Nr > 1,
        [BurstDur2, SchData, Err] = evalDCPExpr('DUR1', 'slave', SchData, DSSParam);
        if Err, return; end
        [BurstDur, Err] = getEDFBinParam(BurstDur, BurstDur2);
        if Err, Err = 2; return; end
        [RepDur2, SchData, Err] = evalDCPExpr('REPINT', 'slave', SchData, DSSParam);
        if Err, return; end
        [RepDur, Err] = getEDFBinParam(RepDur, RepDur2);
        if Err, Err = 2; return; end
        
        [RiseDur2, SchData, Err] = evalDCPExpr('RTIME', 'slave', SchData, DSSParam);
        if Err, return; end
        [RiseDur, Err] = getEDFBinParam(RiseDur, RiseDur2);
        if Err, Err = 2; return; end
        [FallDur2, SchData, Err] = evalDCPExpr('FTIME', 'slave', SchData, DSSParam);
        if Err, return; end
        [FallDur, Err] = getEDFBinParam(FallDur, FallDur2);
        if Err, Err = 2; return; end
        
        [Delay2, SchData, Err] = evalDCPExpr('DELM', 'slave', SchData, DSSParam);
        if Err, return; end
        [Delay, Err] = getEDFBinParam(Delay, Delay2);
        if Err, Err = 2; return; end

        if any(strcmp(SchData.SchName, {'sch006', 'sch012'})),
            [SPL2, SchData, Err] = evalDCPExpr('SPL', 'slave', SchData, DSSParam);
            if Err, return; end
            [SPL, Err] = getEDFBinParam(SPL, SPL2);
            if Err, Err = 2; return; end
        else, SPL = [SPL, NaN]; end    
    end
case 'sch016'
    %All time settings are given in seconds ...
    BurstDur = SchData.DSSDAT(DSSParam.MasterIdx).DUR1 * 1e3;
    RepDur   = SchData.DSSDAT(DSSParam.MasterIdx).REPINT * 1e3;
    
    RiseDur  = SchData.DSSDAT(DSSParam.MasterIdx).RTIME * 1e3;
    FallDur  = SchData.DSSDAT(DSSParam.MasterIdx).FTIME * 1e3;

    Delay    = SchData.DSSDAT(DSSParam.MasterIdx).DELM * 1e6;
    
    SPL      = SchData.DSSDAT(DSSParam.MasterIdx).SPL;

    if DSSParam.Nr > 1,
        BurstDur = [BurstDur, SchData.DSSDAT(DSSParam.SlaveIdx).DUR1*1e3 ];
        RepDur   = [RepDur, SchData.DSSDAT(DSSParam.SlaveIdx).REPINT*1e3 ];
        
        RiseDur  = [RiseDur, SchData.DSSDAT(DSSParam.SlaveIdx).RTIME*1e3];
        FallDur  = [FallDur, SchData.DSSDAT(DSSParam.SlaveIdx).FTIME*1e3 ];
        
        Delay    = [Delay, SchData.DSSDAT(DSSParam.SlaveIdx).DELM*1e6 ];
        
        SPL      = [SPL, SchData.DSSDAT(DSSParam.SlaveIdx).SPL];
    end
otherwise, [BurstDur, RepDur, RiseDur, FallDur, Delay, SPL] = deal([]); end    

%BurstDur, RepDur, RiseDur and FallDur are in milliseconds, MastDelay and Delay are given 
%in microseconds, SPL is supplied in dB ...
GenStimParam = CollectInStruct(BurstDur, RepDur, RiseDur, FallDur, Delay, SPL);
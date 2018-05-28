function [FreqParam, SchData, Err] = extractSCHFreqParam(SchData, IndepVarParam, DSSParam)

%B. Van de Sande 09-08-2004
%These parameters can only be extracted from datasets with schemata sch006, sch012 and sch016. 
%The DSS mode should be TON or AM ...

FreqParam = struct([]); Err = 0;

switch SchData.SchName
case {'sch006', 'sch012'}
    [CarFreq, SchData, Err] = evalDCPExpr('FREQ', 'master', SchData, DSSParam);
    if Err, return; end
    [CarPhase, SchData, Err] = evalDCPExpr('PHASE', 'master', SchData, DSSParam);
    if Err, return; end

    [ModFreq, SchData, Err] = evalDCPExpr('FMOD', 'master', SchData, DSSParam);
    if Err, return; end
    [ModPhase, SchData, Err] = evalDCPExpr('PHASM', 'master', SchData, DSSParam);
    if Err, 
        %Changed on 07-07-2004 for Alberto Recio, newly collected datasets from 
        %Madison where the modulation frequecny is changed store 'CAM' in the 
        %DSSDAT.PHASM field ...
        ModPhase = NaN; warning('Phase of modulation tone could not be extracted.')
    end
    [ModDepth, SchData, Err] = evalDCPExpr('DMOD', 'master', SchData, DSSParam);
    if Err, return; end
    
    if DSSParam.Nr > 1,
        [CarFreq2, SchData, Err] = evalDCPExpr('FREQ', 'slave', SchData, DSSParam);
        if Err, return; end
        [CarFreq, Err] = getEDFBinParam(CarFreq, CarFreq2);
        if Err, Err = 2; return; end
        [CarPhase2, SchData, Err] = evalDCPExpr('PHASE', 'slave', SchData, DSSParam);
        if Err, return; end
        [CarPhase, Err] = getEDFBinParam(CarPhase, CarPhase2);
        if Err, Err = 2; return; end
      
        [ModFreq2, SchData, Err] = evalDCPExpr('FMOD', 'slave', SchData, DSSParam);
        if Err, return; end
        [ModFreq, Err] = getEDFBinParam(ModFreq, ModFreq2);
        if Err, Err = 2; return; end
        [ModPhase2, SchData, Err] = evalDCPExpr('PHASM', 'slave', SchData, DSSParam);
        if Err, 
            %Changed on 07-07-2004 for Alberto Recio, newly collected datasets from 
            %Madison where the modulation frequency is changed store 'CAM' in the 
            %DSSDAT.PHASM field ...
            ModPhase2 = NaN; warning('Phase of modulation tone could not be extracted.')
        end
        [ModPhase, Err] = getEDFBinParam(ModPhase, ModPhase2);
        if Err, Err = 2; return; end
        [ModDepth2, SchData, Err] = evalDCPExpr('DMOD', 'slave', SchData, DSSParam);
        if Err, return; end
        [ModDepth, Err] = getEDFBinParam(ModDepth, ModDepth2);
        if Err, Err = 2; return; end
    end    
    
    %If Modulation Depth is set to null, then no Amplitude Modulation in stimulus ...
    if DSSParam.Nr > 1 & any(ModDepth == 0), [ModFreq, ModPhase, ModDepth] = deal([NaN NaN]); 
    elseif any(ModDepth == 0), [ModFreq, ModPhase, ModDepth] = deal(NaN); end
case 'sch016'
    %For datasets collected with the SER program, only the mode for generating Tone Pips
    %is implemented ...
    %In this mode the independent variable is always the carrier frequency. The stimulus
    %is given binaurally with a small difference in frequency between both ears, introducing
    %a beat. This difference is stored as a schema variable 'DELTFRQ', which gives the 
    %difference in frequency between phone 1 and phone 2, where DSS1 is always associated
    %with phone 1 and DSS2 always with phone 2.
    %
    %For more documentation, see http://www.neurophys.wisc.edu/~jane/ser/tnpip.html ...
    
    %Checking if Tone Pips responses where collected with the SER program ... There doesn't seem to be
    %a mode variable in SCH016 so verifying mode by checking indirect variables in the schema ...
    if (DSSParam.Nr > 1) & isequal({DSSParam.MasterMode, DSSParam.SlaveMode}, {'ton', 'ton'}) & ...
       any(strcmp(IndepVarParam.DCPName, {'freq', 'fcarr'})),
        if 0, %OLD IMPLEMENTATION ...
            %reduceIndepVar.m has put the frequency values here ...
            CarFreq = SchData.DSSDAT(IndepVarParam.DSSidx).FREQ;
            VarDSSNr = SchData.DSSDAT(IndepVarParam.DSSidx).DSSN;
            %The freq diff parameter allows for a difference in frequency between phone 1 and phone 2, thus FreqDiff
            %is phone 2 freq - phone 1 freq. DSS 1 is always associated with phone 1 and DSS 2 with phone 2. (NOT
            %MENTIONED IN DOCUMENTATION)
            idxDSS1 = find(cat(2, SchData.DSSDAT.DSSN) == 1);
            idxDSS2 = find(cat(2, SchData.DSSDAT.DSSN) == 2); 
            FreqDiff = SchData.DSSDAT(idxDSS2).DELTFRQ - SchData.DSSDAT(idxDSS1).DELTFRQ;
            %The calculation of the actual frequencies administered at both ears depends on the number of the DSS that
            %was varied ... The CarFreq matrix is organized in the following way: the first column contains the frequencies
            %for DSS or Phone 1, and the second column the freq's for DSS 2 or Phone 2 ...
            if (VarDSSNr == 1), CarFreq = [CarFreq, CarFreq+FreqDiff]; 
            else, CarFreq = [CarFreq-FreqDiff, CarFreq]; end
            %The frequency vector in the special structure is still organised according the Master-Slave convention 
            %for columns ... This is the general convention and moreover the other stimulus paramneters, like delay
            %are also organized in this way ...
            if (DSSParam.MasterNr == 2), CarFreq = fliplr(CarFreq); end %Only problems if Master DSS has number two ... 
        else, %NEW IMPLEMENTATION ...
            %reduceIndepVar.m has put the frequency values here ...
            CarFreq = SchData.DSSDAT(IndepVarParam.DSSidx).FREQ;
            %The documentation on dataset schema SCH016 mentions that the actual frequency for a certain DSS
            %number is the frequency stored in FREQ plus the delta frequency for that DSS number (stored in
            %DELTFRQ). The only thing that is assumed is that the FREQ variable needs to be the values of the
            %independent variable for both DSS numbers, not only for the varied DSS! The CarFreq matrix is
            %organized in the following way: the first column contains the frequencies for DSS or Phone 1, and
            %the second column the freq's for DSS 2 or Phone 2 ...
            idxDSS1 = find(cat(2, SchData.DSSDAT.DSSN) == 1); Fdelta1 = SchData.DSSDAT(idxDSS1).DELTFRQ;
            idxDSS2 = find(cat(2, SchData.DSSDAT.DSSN) == 2); Fdelta2 = SchData.DSSDAT(idxDSS2).DELTFRQ;
            CarFreq = [CarFreq+Fdelta1, CarFreq+Fdelta2];
            %The frequency vector in the special structure is still organised according the Master-Slave convention 
            %for columns ... This is the general convention and moreover the other stimulus paramneters, like delay
            %are also organized in this way ...
            if (DSSParam.MasterNr == 2), CarFreq = fliplr(CarFreq); end %Only problems if Master DSS has number two ... 
        end
        
        [CarPhase, ModFreq, ModPhase, ModDepth] = deal([NaN NaN]);
    else, 
        warning('Only Tone Pips mode implemented for SER data collection program.');
        [CarFreq, CarPhase, ModFreq, ModPhase, ModDepth] = deal([NaN NaN]); 
    end
otherwise, [CarFreq, CarPhase, ModFreq, ModPhase, ModDepth] = deal(NaN); end

%All frequencies are given in Hz, Phase is given in cycles ...
FreqParam = CollectInStruct(CarFreq, CarPhase, ModFreq, ModPhase, ModDepth);
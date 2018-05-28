function [ArgOut, ErrTxt] = GetRAPCalcParam(RAPStat, Mode, FieldName)
%GetRAPCalcParam    returns an RAP calculation parameter
%   ArgOut = GetRAPCalcParam(RAPStat, Mode, FieldName) returns the requested
%   calculation parameter as a string or as a numeric scalar (or vector for 
%   the binning frequency) depending on the mode, 'str' respectively 'nr'.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2006

%-------------------------------implementation details-------------------------
%   This file gives the default values for all the calculation parameters.
%   For some parameters the standard value doesn't depend on the current dataset
%   being loaded, for others this is not the case. So, if no dataset is currently
%   specified in the RAP environment and a calculation parameter with a default
%   value depending on a dataset is requested, then an appropriate character 
%   string (e.g. 'default' or 'all') or the number NaN is returned.
%------------------------------------------------------------------------------

ErrTxt = ''; ArgOut = [];

if isRAPStatDef(RAPStat, 'GenParam.DS'), ds = [];
else ds = RAPStat.GenParam.DS;
end

if ~any(strncmpi(Mode, {'s', 'n'}, 1)), ErrTxt = 'Invalid mode'; return; end

switch lower(FieldName)
case 'subseqs',
    %By default all recorded subsequences are included ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.SubSeqs')
            iSubSeqs = RAPStat.CalcParam.SubSeqs;
        elseif isTHRdata(ds)
            iSubSeqs = 1:length(ds.xval); 
        else
            iSubSeqs = 1:ds.nrec; 
        end
        if strncmpi(Mode, 's', 1)
            ArgOut = RAPRange2Str(iSubSeqs); 
        else
            ArgOut = iSubSeqs;
        end
    elseif strncmpi(Mode, 's', 1)
        ArgOut = 'all'; 
    else
        ArgOut = NaN;
    end
case 'reps'
    %All repetition or trials are included in the analysis ...
    if ~isempty(ds)
        if ~isRAPStatDef(RAPStat, 'CalcParam.Reps')
            IncReps = RAPStat.CalcParam.Reps; 
        else
            IncReps = 1:ds.nrep; 
        end
        if strncmpi(Mode, 's', 1)
            ArgOut = RAPRange2Str(IncReps); 
        else
            ArgOut = IncReps;
        end
    elseif strncmpi(Mode, 's', 1)
        ArgOut = 'all'; 
    else ArgOut = NaN; 
    end
case 'anwin'
    %The standard analysis window is from 0ms up until the stimulus duration. If two
    %channels are used for a stimulus, and the stimulus duration is different for both
    %channels, then the minimum of the two is used (see also ANWIN).
    if ~isempty(ds)
        if ~isRAPStatDef(RAPStat, 'CalcParam.AnWin')
            AnWin = RAPStat.CalcParam.AnWin; 
        else
            AnWin = [0, min(ds.burstdur)]; 
        end
        if strncmpi(Mode, 's', 1)
            ArgOut = RAPWin2Str(AnWin); 
        else
            ArgOut = AnWin;
        end
    elseif strncmpi(Mode, 's', 1)
        ArgOut = 'stimdur'; 
    else
        ArgOut = NaN;
    end
case 'rewin'
    %By default no reject window is applied ...
    if ~isempty(ds)
        if ~isRAPStatDef(RAPStat, 'CalcParam.ReWin')
            ReWin = RAPStat.CalcParam.ReWin; 
        else
            ReWin = []; 
        end
        if strncmpi(Mode, 's', 1)
            ArgOut = RAPWin2Str(ReWin); 
        else
            ArgOut = ReWin; 
        end
    elseif strncmpi(Mode, 's', 1)
        ArgOut = 'N/A'; 
    else
        ArgOut = NaN; 
    end
case 'nbin'
    %The standard number of bins for a histogram is 64 ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.NBin')
        if ~isnan(RAPStat.CalcParam.NBin)
            NBin = RAPStat.CalcParam.NBin; 
            NBinStr = int2str(NBin);
        else
            NBin = NaN; 
            NBinStr = 'binwidth'; 
        end
    else
        NBin = 64; 
        NBinStr = '64'; 
    end
    if strncmpi(Mode, 's', 1), ArgOut = NBinStr; else ArgOut = NBin; end
case 'binwidth'
    %The binwidth is by default not used and is calculated out of the number of bins ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.BinWidth'), 
        if ~isnan(RAPStat.CalcParam.BinWidth), BinWidth = RAPStat.CalcParam.BinWidth; BinWidthStr = sprintf('%.2f ms', BinWidth);
        else BinWidth = NaN; BinWidthStr = 'nbin'; end     
    else BinWidth = NaN; BinWidthStr = 'nbin';
    end
    if strncmpi(Mode, 's', 1), ArgOut = BinWidthStr; else ArgOut = BinWidth; end
case 'binfreq'
    %The binning frequency is always returned as a column vector with the same number
    %of elements as the number of subsequences requested. This vector gives the right
    %binning frequency for each subsequence. Binning frequencies can be negative ...
    if ~isempty(ds) && (isTHRdata(ds) || isCALIBdata(ds)) %Not applicable for these datasets ...
        BinFreq = NaN; 
        BinFreqStr = 'N/A';
    elseif ~isRAPStatDef(RAPStat, 'CalcParam.BinFreq') %User-specified binning frequency ...
        %The user-supplied binning frequencies is always a vector with a number of elements
        %equal to the number of subsequences recorded ... The function ExpandBinFreq.m
        %takes care of the reduction of elements ...
        BinFreq = RAPStat.CalcParam.BinFreq; 
        iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); 
        BinFreq = ExpandBinFreq(ds, BinFreq, iSubSeqs);
        if isempty(BinFreq)
            ErrTxt = 'Invalid binning frequency supplied'; 
            return; 
        end
        %Always display binning frequency as a positive vector ...
        BinFreqStr = Freq2Str(abs(BinFreq));
    elseif ~isempty(ds) %Default binning frequency depends on stimulus type (according to SGSR convention) ...
        iSubSeqs = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'); 
        BinFreq = ExpandBinFreq(ds, 'auto', iSubSeqs);
        if isempty(BinFreq)
            ErrTxt = 'No default binning frequency for dataset'; 
            return; 
        end
        %Always display binning frequency as a positive vector ...
        BinFreqStr = Freq2Str(abs(BinFreq));
    else
        BinFreq = NaN; 
        BinFreqStr = 'default'; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = BinFreqStr; 
    else
        ArgOut = BinFreq;
    end
case 'minisi',
    %No minimum interspike interval by default. The standard value is thus zero ms ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.MinISI')
        MinISI = RAPStat.CalcParam.MinISI; 
    else
        MinISI = 0;
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = sprintf('%.2f ms', MinISI); 
    else
        ArgOut = MinISI; 
    end
case 'consubtr',
    %The default is no (zero) time subtracted ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.ConSubTr')
        ConSubTr = RAPStat.CalcParam.ConSubTr; 
    else
        ConSubTr = 0; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = sprintf('%.2f ms', ConSubTr); 
    else
        ArgOut = ConSubTr;
    end
case 'corbinwidth',
    %BinWidth for autocorrelograms is 0.05 ms by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.CorBinWidth'), CorBinWidth = RAPStat.CalcParam.CorBinWidth; 
    else CorBinWidth = 0.05; end
    if strncmpi(Mode, 's', 1), ArgOut = [num2str(CorBinWidth) ' ms']; else ArgOut = CorBinWidth; end
case 'cormaxlag',
    %Maximum lag for autocorrelograms is 15 ms by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.CorMaxLag'), CorMaxLag = RAPStat.CalcParam.CorMaxLag; 
    else CorMaxLag = 15; end
    if strncmpi(Mode, 's', 1), ArgOut = [num2str(CorMaxLag) ' ms']; else ArgOut = CorMaxLag; end
case 'phaseconv',
    %Phase convention is lead by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.PhaseConv')
        PhaseConv = RAPStat.CalcParam.PhaseConv; 
    else
        PhaseConv = 'lead'; 
    end
    ArgOut = PhaseConv;
case 'compdelay',
    %Compensating delay is zero by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.CompDelay')
        CompDelay = RAPStat.CalcParam.CompDelay; 
    else
        CompDelay = 0; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = [num2str(CompDelay) ' ms']; 
    else
        ArgOut = CompDelay; 
    end
case 'unwrapping',
    %Phase unwrapping is yes by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.UnWrapping'), UnWrapping = RAPStat.CalcParam.UnWrapping;
    else UnWrapping = 'yes'; end
    if strncmpi(Mode, 's', 1), ArgOut = UnWrapping; else ArgOut = strcmpi(UnWrapping, 'yes'); end
case 'raycrit',
    %Boundary significance for Rayleigh Criterion is set to 0.001 by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.RayCrit')
        RayCrit = RAPStat.CalcParam.RayCrit; 
    else
        RayCrit = 0.001; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = sprintf('%.3f', RayCrit); 
    else
        ArgOut = RayCrit; 
    end
case 'intncycles',
    %Restrict analysis window to an integer number of cyles is by default set to off... 
    if ~isRAPStatDef(RAPStat, 'CalcParam.IntNCycles')
        IntNCycles = RAPStat.CalcParam.IntNCycles; 
    else
        IntNCycles = 'no'; 
    end
    ArgOut = IntNCycles;
case 'avgwin',
    %Averaging window in regularity analysis is set by default to the stimulus
    %duration ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.AvgWin'), AvgWin = RAPStat.CalcParam.AvgWin; 
        else AvgWin = [0, min(ds.burstdur)]; end
        if strncmpi(Mode, 's', 1), ArgOut = RAPWin2Str(AvgWin); else ArgOut = AvgWin; end
    elseif strncmpi(Mode, 's', 1), ArgOut = 'burstdur'; else ArgOut = NaN;
    end
case 'minnint',   
    %Minimum number of intervals necessary in a bin for the regularity analysis is
    %set to 3 by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.MinNInt'), MinNInt = RAPStat.CalcParam.MinNInt; 
    else MinNInt = 3; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%d', MinNInt); else ArgOut = MinNInt; end
case 'histrunav',    
    %No running average on histograms by default. Running average specified in bins!
    if ~isRAPStatDef(RAPStat, 'CalcParam.HistRunAv')
        HistRunAv = RAPStat.CalcParam.HistRunAv; 
    else
        HistRunAv = 0; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = sprintf('%d #', HistRunAv); 
    else
        ArgOut = HistRunAv; 
    end
case 'curverunav',    
    %No running average on curves by default. Running average specified in points!
    if ~isRAPStatDef(RAPStat, 'CalcParam.CurveRunAv'), CurveRunAv = RAPStat.CalcParam.CurveRunAv; 
    else CurveRunAv = 0; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%d #', CurveRunAv); else ArgOut = CurveRunAv; end
case 'pklrunav',    
    %Running average used on PSTs in the calculation of the peak latency is 3 bins by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.PklRunAv'), PklRunAv = RAPStat.CalcParam.PklRunAv; 
    else PklRunAv = 3; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%d #', PklRunAv); else ArgOut = PklRunAv; end
case 'envrunav',    
    %Running average on envelope of difcor is normally 2 ms ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.EnvRunAv'), EnvRunAv = RAPStat.CalcParam.EnvRunAv; 
    else EnvRunAv = 2; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%.0f ms', EnvRunAv); else ArgOut = EnvRunAv; end
case 'pklrateinc'
    %Rate increase for measurement of beginning of peak is 20% by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.PklRateInc'), RateInc = RAPStat.CalcParam.PklRateInc; 
    else RateInc = 20; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%.0f %%', RateInc); else ArgOut = RateInc; end
case 'pklsrwin'
    %Spontaneous rate window for estimation of spontaneous rate is by default the interval
    %between the end of the stimulus and the new stimulus presentation ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.PklSrWin'), SrWin = RAPStat.CalcParam.PklSrWin; 
        else SrWin = [max(ds.burstdur), max(ds.repdur)]; end
        if strncmpi(Mode, 's', 1), ArgOut = RAPWin2Str(SrWin); else ArgOut = SrWin; end
    elseif strncmpi(Mode, 's', 1), ArgOut = 'nostim'; else ArgOut = NaN;
    end
case 'pklpkwin'
    %The peak window is by default the interval from 0 ms to the end of the stimulus ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.PklPkWin'), PkWin = RAPStat.CalcParam.PklPkWin; 
        else PkWin = [0, min(ds.burstdur)]; end
        if strncmpi(Mode, 's', 1), ArgOut = RAPWin2Str(PkWin); else ArgOut = PkWin; end
    elseif strncmpi(Mode, 's', 1), ArgOut = 'stimdur'; else ArgOut = NaN;
    end
case 'thrq'
    %The threshold for the Q-factor is 10dB by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.ThrQ'), ThrQ = RAPStat.CalcParam.ThrQ; 
    else ThrQ = 10; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%.0f dB', ThrQ); else ArgOut = ThrQ; end
case 'syncthr'
    %The cutoff threshold on the synchronisation curve is 3dB by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.SyncThr')
        SyncThr = RAPStat.CalcParam.SyncThr; 
    else
        SyncThr = 3; 
    end
    if strncmpi(Mode, 's', 1)
        ArgOut = sprintf('%.0f dB', SyncThr); 
    else
        ArgOut = SyncThr;
    end
case 'maxpst',    
    %Maximum poststimulus time is the repetition duration by default ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.MaxPST'), MaxPST = RAPStat.CalcParam.MaxPST; 
        else MaxPST = max(ds.repdur); end
        if strncmpi(Mode, 's', 1), ArgOut = [int2str(MaxPST) ' ms']; else ArgOut = MaxPST; end
    elseif strncmpi(Mode, 's', 1), ArgOut = 'repdur'; else ArgOut = NaN; 
    end
case 'maxisi',
    %Maximum interspike interval is 10 ms by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.MaxISI'), MaxISI = RAPStat.CalcParam.MaxISI; 
    else MaxISI = 10; end
    if strncmpi(Mode, 's', 1), ArgOut = [int2str(MaxISI) ' ms']; else ArgOut = MaxISI; end
case 'maxfsl',
    %Maximum firstspike latency is the stimulus duration by default ...
    if ~isempty(ds),
        if ~isRAPStatDef(RAPStat, 'CalcParam.MaxFSL'), MaxFSL = RAPStat.CalcParam.MaxFSL; 
        else MaxFSL = max(ds.burstdur); end
        if strncmpi(Mode, 's', 1), ArgOut = [int2str(MaxFSL) ' ms']; else ArgOut = MaxFSL; end
    elseif strncmpi(Mode, 's', 1), ArgOut = 'stimdur'; else ArgOut = NaN;
    end
 case 'signlevel',
    %Significance level is 0.001 by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.SignLevel'), SignLevel = RAPStat.CalcParam.SignLevel; 
    else SignLevel = 0.999; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%.3f', SignLevel); else ArgOut = SignLevel; end
 case 'bootstrap',
    %Boot strap is 50 by default ...
    if ~isRAPStatDef(RAPStat, 'CalcParam.BootStrap'), BootStrap = RAPStat.CalcParam.BootStrap; 
    else BootStrap = 0; end
    if strncmpi(Mode, 's', 1), ArgOut = sprintf('%d #', BootStrap); else ArgOut = BootStrap; end
otherwise, ErrTxt = sprintf('%s is an unknown calculation parameter',lower(FieldName)); return;
end

%---------------------------------local functions------------------------------
function Str = Freq2Str(Freq)

MaxNElem = 4; 
HMaxNElem = round(MaxNElem/2);

Freq = cleanStr(cellstr(num2str(Freq(:))));
NElem = length(Freq);

if (NElem > MaxNElem)
    Str = ['[', formatcell(Freq(1:HMaxNElem), {'', ''}, ','), ',...,', ...
            formatcell(Freq(NElem-HMaxNElem+1:end), {'', ''}, ','), '] Hz' ];
else
    Str = ['[' formatcell(Freq, {'', ''}, ',') '] Hz' ]; 
end

%--------------------------------------------------------------------------------
function [Type, Value] = EvalRAPSubstVar(varargin)
%EvalRAPSubstVar  evaluates substition variable in RAP
%   Type = EvalRAPSubstVar(VarName) evaluates the substitution variable given 
%   by VarName, this includes checking if VarName is a valid substitution 
%   variable and what its return type is. The type of a variable can be 'double'
%   or 'char'. If the variable name is invalid the empty string is returned.
%
%   [Type, Value] = EvalRAPSubstVar(RAPStat, VarName) also returns the actual
%   value the variable is standing for.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.
%
%   See also isRAPSubstVar, GetRAPSubstVar

%B. Van de Sande 11-04-2005

%--------------------------implementation details--------------------------
%
%   List of RAP substitution variables that are implemented :
%
%	FNAME	: Name of current data file (char string)
%	NUMDS	: Total number of data sets in file
%	DSID	: Data set ID of current dataset (char string)
%   CELLNR  : Cell number of current dataset (~)
%	EXTYP	: Experiment type (char string) (~)
%   YEAR    : Year in which current data set collected (4 digits)
%	NDSET	: Number of the current data set
%   NSTIM	: No. of stimulus points in current data set
%   NSTIMR  : No. of recorded stimulus points in current dataset (~)
%   NSTIMA  : No. of stimulus points actually included in recent analysis
%	NREPS	: Number of repetitions
%	NREP	: Same as NREPS
%   NUMV    : Number of RA variables
%	XNAME	: Name of X-variable (char string)
%	XLOW	: Starting value for X-variable
%	XHIGH	: Final value for X-variable
%	XINC	: Increment for X-variable (or steps/octave if log steps)
%   XSCALE  : Scale for X-variable (char string)(~)
%	XRANGE	: Range of X-variable
%	NUMX	: No. of times X-variable was varied
%	YNAME	: Name of Y-variable (char string)
%	YLOW	: Starting value for Y-variable
%	YHIGH	: Final value for Y-variable
%	YINC	: Increment for Y-variable (or steps/octave if log steps)
%   YSCALE  : Scale for Y-variable (char string)(~)
%	YRANGE	: Range of Y-variable
%	NUMY	: Number of times Y-variables was varied
%	STMDUR	: Stimulus duration (millisecs) (*)
%	DUR	    : Stimulus duration (millisecs) (*)
%	REPINT	: Repetition interval (millisecs) (*)
%	RTIME	: Stimulus envelope Rise time (millisecs) (*)
%	FTIME	: Stimulus envelope Fall time (millisecs) (*)
%	DELAY	: Initial delay of Master DSS (*)
%	SPL	    : Fixed SPL (dB) (*)
%	FCARR	: Carrier frequency (Hz) (*)
%	FREQ	: Fixed frequency (Hz) (*)
%	PHASE	: Carrier initial phase (0 to 1) (*)
%	DMOD	: Depth of modulation (*)
%	FMOD	: Fixed modulation frequency (*)
%	PHASM	: Modulation initial phase (0 to 1) (*)
%	PHASEM	: Same as PHASM (*)
%   NUETS   : Number of unit event timers (~)
%   UETNRS  : Unit event timer numbers (~)
%	GWFILE	: General waveform File-name (char string) (*)
%	GWID	: General waveform ID (char string) (*)
%   GWLEN   : General Waveform length
%   GWINT   : General Waveform interval (microsecs)
%   GPGWI1  : First Waveform ID from Gewab-pair expt. (char) (~)
%   GPGWI2  : Second Waveform ID from Gewab-pair expt. (char) (~)
%   ITRATE  : ITD rate for shifted-GW stimulus (microsecs/sec)
%   SGITD1  : Shifted-GW ITD1 for shifted-GW stimulus (microsecs)
%   SGITD2  : Shifted-GW ITD2 for shifted-GW stimulus (microsecs)
%   MDSS    : Master DSS number (~)
%   DSS1    : DSS-1 use flag (0 or 1) (~)
%   DSS2    : DSS-2 use flag (0 or 1) (~)
%   XVAR    : Table of X-var values from most recent plot (array)
%   YVAR    : Table of Y-var values from most recent plot (array)
%   THCF    : Characteristic frequency from Tuning curve data (~)
%   THTHR   : Minimum threshold from Tuning curve data (~)
%   THQ     : Estimated Q-factor from Tuning curve data (~)
%   THBW    : Estimated bandwidth from Tuning curve data (~)
%   THSPON  : Spon. Activity Count from TH data (~)
%	VALMAX	: Largest value from most recent RA plot
%	VALMIN	: Minimum value from most recent RA plot
%	XVMAX	: Value of X-var at VALMAX from RA plot
%	XVMIN	: Value of X-var at VALMIN from RA plot
%	YVMAX	: Value of Y-var at VALMAX from RA plot
%	YVMIN	: Value of Y-var at VALMIN from RA plot
%   NUMXVAR : Number of X-var values in most recent RA computation
%   NUMYVAR : Number of Y-var values in most recent RA computation
%   BINW    : Bin-width of most recently computed histogram
%   NSPKMAX : Max. number of spikes from most recent PST (~)
%	SYNCCO	: Sync. Coeff. from most recent CH plot (~)
%	RAYSIG	: Rayleigh Coeff. from most recent CH plot (~)
%   PHASEMAX: Max. phase for most recent cycle histogram (~)
%   PHASEMIN: Min. phase for most recent cycle histogram (~)
%   REFRAC  : Refractory period from most recent ISI histogram (~)
%   SACDF   : Dominant frequency from most recent Autocorrelogram (~)
%   SACBW   : Bandwidth from most recent Autocorrrelogram (~)
%   SACPH   : Peakheight from most recent Autocorrelogram (~)
%   SACHHW  : Halfheight width from most recent Autocorrelogram (~)
%   XCDF    : Dominant frequency from most recent Crosscorrelogram (~)
%   XCBW    : Bandwidth from most recent Crosscorrrelogram (~)
%   XCPH    : Peakheight from most recent Crosscorrelogram (~)
%   XCHHW   : Halfheight width from most recent Crosscorrelogram (~)
%   DIFDF   : Dominant frequency from most recent Difcor (~)
%   DIFBW   : Bandwidth from most recent Difcor (~)
%   DIFPH   : Peakheight from most recent Difcor (~)
%   DIFHHW  : Halfheight width from most recent Difcor (~)
%   VSMMAX  : Maximum synchronicity from most recent Vector strength magnitude curve (~)
%   VSMBVAL : Best value of independent variable from most recent Vector strength magnitude curve (~)
%   VSMCO   : Cutoff synchronicity from most recent Vector strength magnitude curve (~)
%   VSMCOVAL: Cutoff value of independent variable from most recent Vector strength magnitude curve (~)
%   VSMRAYSIG: Table of rayleigh significance values of most recent Vector strength magnitude curve (~)
%   VSPCD   : Characterictic delay from most recent Vector strength phase curve (~)
%   VSPCP   : Characteristic phase from most recent Vector strength phase curve (~)
%   VSPRAYSIG: Table of rayleigh significance values of most recent Vector strength phase curve (~)
%   ISCV    : Mean Coeff. of Variation of Interspike intervals (~)
%   TRDAVG  : Average rate from most recent trial rate distribution (~)
%   TRDSTD  : Standard deviation on rate from most recent trial rate distribution (~)
%	XMIN	: X-minimum for most recent plot
%	XMAX	: X-maximum for most recent plot
%	YMIN	: Y-minimum for most recent plot
%	YMAX	: Y-maximum for most recent plot
%   XVLL    : Log or Linear increment for abcissa (~)
%   YVLL    : Log or Linear increment for ordinate (~)
%   AWLO    : Low analysis window from most recent comp. (millisecs)
%   AWHI    : High analysis window from most recent comp. (millisecs)
%        
%   Most variables are returned as numeric (floating point) values except for 
%   those which are marked as "char string" above.
%   In cases where two tones were presented (i.e. a two DSS experiment) you can 
%   specify which DSS to get the values for by appending either #M (for Master 
%   DSS) or #S (for Slave DSS) to some of the above variable names. 
%   Only certain variables can be extended in this way. They are identified with 
%   a (*) after their description above.
%   This list of substitution variables can be extended by editing the file 
%   'RAPSUBSTVARLIST.M'. Further information can be found in this file.
%   (~) after a variable designates a changed name of the variable or a different
%   interpretation in this MATLAB implementation.
%
%   Attention! Not all substitution variables are implemented, moreover the 
%   syntax that allows the specification of the DSS by number is not implemented.
%
%-----------------------------------------------------------------------------
%
%   Column vectors can be returned if the substitution variable is changed over
%   different subsequences. The length of the vector is always determined by
%   the actual number of subsequences recorded ...
%
%   The following substitution variables that represent stimulus information are
%   retrieved from the StimParam.Special field in the dataset:
%       STMDUR, DUR -> StimParam.Special.BurstDur
%       REPINT      -> StimParam.Special.RepDur
%       FCARR,FREQ  -> StimParam.Special.CarFreq
%       FMOD        -> StimParam.Special.ModFreq
%   Because all datasets have the Special field, the retrieval of this kind of 
%   information doesn't rise any problems.
%
%   Other substitution variables that represent stimulus information, must
%   be extracted from the StimParam field and depend on the sort of stimulus:
%       THR (SGSR)     -> StimParam.riseDur (1)
%                         StimParam.fallDur (1)
%                         StimParam.delay (1x2)
%       NRHO (SGSR)    -> StimParam.riseDur (1)
%                         StimParam.fallDur (1)
%                         StimParam.delay (1x2)
%                         StimParam.SPL (1)
%       ARMIN (SGSR)   -> StimParam.riseDur (1)
%                         StimParam.fallDur (1)
%                         StimParam.delay (1x2)
%                         StimParam.SPL (1)
%       BN (SGSR)      -> StimParam.SPL (1)
%       BERT (SGSR)    -> StimParam.riseDur (1)
%                         StimParam.fallDur (1)
%                         StimParam.modDepth (1)
%                         StimParam.SPL (1)
%       WAV (SGSR)     -> no additional information
%       SPL (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay, modpercent (1)
%       NSPL (IDF/SPK) -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay (1)
%       ITD (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, spl, modpercent (1)
%       NTD (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall (1)
%                         StimParam.SPL (1x2)
%       IID (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay, modpercent (1)
%       FS (IDF/SPK)   -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay, modpercent, spl (1)
%       BFS (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, spl (1)
%       FM (IDF/SPK)   -> StimParam.stim.indiv {1x2} with
%                         rise, fall, spl, delay (1) 
%       IMS (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, spl, delay, modpercent (1) 
%       LMS (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay, modpercent (1) 
%       BMS (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         rise, fall, delay, modpercent (1) 
%       BB (IDF/SPK)   -> StimParam.stim.indiv {1x2} with
%                         rise, fall, spl, modpercent (1) 
%       CFS (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         click_dur, burst_dur, spl, delay (1) 
%       CSPL (IDF/SPK) -> StimParam.stim.indiv {1x2} with
%                         click_dur, burst_dur, delay (1) 
%       CTD (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         spl, click_dur (1) 
%       ICI (IDF/SPK)  -> StimParam.stim.indiv {1x2} with
%                         click_dur, spl1, spl2 (1) 
%                         StimParam.stim.stimcmn with
%                         itd1, itd2 (1)
%       EDF datasets   -> StimParam.RiseDur (1x2)
%                         StimParam.FallDur (1x2)
%                         StimParam.Delay (1x2)
%                         StimParam.SPL (1x2)
%                         StimParam.FreqParam.CarPhase (nx2)
%                         StimParam.FreqParam.ModPhase (nx2)
%                         StimParam.FreqParam.ModDepth (nx2)
%
%   Some substitution variables are specific for EDF datasets: PHASE, PHASM, 
%   PHASEM, GWFILE, GWID, GWLEN, GWINT, GPGWI1, GPGWI2, ITRATE, SGITD1, SGITD, 
%   MDSS, DSS1, DSS2 and all variables for the second independent variable ...
%
%-----------------------------------------------------------------------------

persistent ExtSubstVarList;
if isempty(ExtSubstVarList),
    %Disk interface ...
    FullMFileName = which(mfilename);
    Path = fileparts(FullMFileName);
    ListFileName = fullfile(Path, 'RAPSubstVarList.m');
    
    %Reading ...
    try, [VarName, Type, FieldName] = textread(ListFileName, '%s %s %s', 'commentstyle', 'matlab');
    catch, error('Invalid format for ''RAPSUBSTVARLIST.M'''); end
    
    %Rudimentary syntax checking ...
    if ~all(ismember(lower(Type), {'double', 'char'})), error('Invalid format for ''RAPSUBSTVARLIST.M'''); end
    
    %Reorganizing ...
    ExtSubstVarList = struct('VarName', lower(VarName), 'Type', lower(Type), 'FieldName', FieldName);
end

Type = ''; Value = [];

%Checking input arguments ...
if (nargin == 1),
    RAPStat = struct([]);
    VarName = varargin{1};
elseif (nargin == 2),
    [RAPStat, VarName] = deal(varargin{:});
end

%Parsing of substitution variable name ...
[SubstVarName, DSSName, ErrTxt] = ParseRAPSubstVar(VarName);
if ~isempty(ErrTxt), return; end

%Frequently used help variables ...
if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'GenParam.DS'),
    ds = RAPStat.GenParam.DS;
    
    FileFormat   = ds.FileFormat;
    StimType     = ds.StimType;
    iSubRec      = 1:ds.nrec;
    BothChanUsed = ~RAPStat.GenParam.DS.ActiveChan;
else, 
    [ds, FileFormat, StimType, iSubRec, BothChanUsed] = deal([]); 
end

%The vector returned by YVAR sometimes contains NaN's, which isn't a problem. E.g.
%threshold-curves from EDF-datasets ...
NaNCheck = logical(1);

%Switchyard ...
switch SubstVarName,
%FNAME: Name of current data file
case 'fname'
    Type = 'char';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'GenParam.DataFile'), Value = RAPStat.GenParam.DataFile; end
%NUMDS: Total number of data sets in file
case 'numds',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'GenParam.LUT'), Value = length(RAPStat.GenParam.LUT); end    
%DSID: Data set ID of current data set
case 'dsid',
    Type = 'char';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'GenParam.SeqNr'),
        SeqNrs = cat(2, RAPStat.GenParam.LUT.iSeq);
        idx = find(SeqNrs == RAPStat.GenParam.SeqNr);
        Value = RAPStat.GenParam.LUT(idx).IDstr;
    end
%CELLNR: Cell number of current dataset (~)
case 'cellnr',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.iCell; end
%EXTYP: Experiment type (interpreted as stimulus type)
case 'extyp',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(StimType), Value = StimType; end
%YEAR: Year in which current data set collected (4 digits)
case 'year',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.Time(3); end
%NDSET: Number of the current data set
case 'ndset',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'GenParam.SeqNr'), Value = RAPStat.GenParam.SeqNr; end    
%NSTIM: No. of stimulus points in current dataset
case 'nstim',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.nsub; end
%NSTIMR: No. of recorded stimulus points in current dataset
case 'nstimr',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.nrec; end
%NSTIMA: No. of stimulus points actually included in recent analysis
case 'nstima',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        [iSubSeqs, ErrTxt] = GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs');
        if ~isempty(ErrTxt), return;
        else, Value = length(iSubSeqs); end
    end
%NREPS, NREP: Number of repetitions
case {'nreps', 'nrep'},
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.nrep; end
%NUMV: Number of RA variables
case 'numv',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        if strcmpi(ds.FileFormat, 'EDF'), Value = ds.indepnr;
        else, Value = 1; end
    end
%XNAME: Name of X-variable (char string)
case 'xname',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds), Value = ds.xname; end        
%XLOW: Starting value for X-variable
case 'xlow',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = min(ds.xval(iSubRec)); end    
%XHIGH: Final value for X-variable
case 'xhigh',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = max(ds.xval(iSubRec)); end    
%XINC: Increment for X-variable (or octaves if log steps)
case 'xinc',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        Xval = unique(denan(ds.xval)); Dval = unique(diff(Xval));
        if (length(Xval) == 1), Value = 0;
        elseif length(Dval) == 1, Value = Dval; %Linear ...
        else, Value = log2(Xval(2)/Xval(1)); end %Logaritmic ...
    end
%XSCALE: Scale for X-variable (char string)(*)
case 'xscale',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds),
        Xval = unique(denan(ds.xval)); Dval = unique(diff(Xval));
        if (length(Xval) == 1), Value = 'NO'; %No increment ...
        elseif (length(Dval) == 1), Value = 'LIN'; %Linear ...
        else, Value = 'LOG'; end %Logaritmic ...
    end
%XRANGE: Range of X-variable
case 'xrange',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), 
        Value = max(ds.xval(iSubRec)) - min(ds.xval(iSubRec)); 
    end    
%NUMX: No. of times X-variable was varied
case 'numx',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), Value = length(unique(ds.xval(iSubRec))); end
%YNAME: Name of Y-variable (char string)
case 'yname',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Value = ds.yname;
    end
%YLOW: Starting value for Y-variable
case 'ylow',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Value = min(ds.yval(iSubRec));
    end    
%YHIGH: Final value for Y-variable
case 'yhigh',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Value = max(ds.yval(iSubRec));
    end    
%YINC: Increment for Y-variable (or octaves if log steps)
case 'yinc',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Yval = unique(denan(ds.yval)); Dval = unique(diff(Yval));
        if (length(Yval) == 1), Value = 0; %No increment ...
        elseif length(Dval) == 1, Value = Dval; %Linear ...
        else, Value = log2(Yval(2)/Yval(1)); end %Logaritmic ...
    end
%YSCALE: Scale for X-variable (char string)(*)
case 'yscale',    
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Yval = unique(denan(ds.yval)); Dval = unique(diff(Yval));
        if (length(Yval) == 1), Value = 'NO'; %No increment ...
        elseif (length(Dval) == 1), Value = 'LIN'; %Linear ...
        else, Value = 'LOG'; end %Logaritmic ...
    end
%YRANGE: Range of Y-variable
case 'yrange',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Value = max(ds.yval(iSubRec)) - min(ds.yval(iSubRec));
    end    
%NUMY: Number of times Y-variable was varied
case 'numy',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & (ds.indepnr > 1),
        Value = length(unique(ds.yval(iSubRec)));
    end    
%STMDUR, DUR: Stimulus duration (millisecs) (*)
case {'stmdur', 'dur'},
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        if strcmpi(DSSName, 'master'), Value = ds.Special.BurstDur(1); 
        elseif BothChanUsed, Value = ds.Special.BurstDur(end); end    
    end;
%REPINT: Repetition interval (millisecs) (*)
case 'repint',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), 
        if strcmpi(DSSName, 'master'), Value = ds.Special.RepDur(1); 
        elseif BothChanUsed, Value = ds.Special.RepDur(end); end    
    end;
%RTIME: Stimulus envelope Rise time (millisecs) (*)
case 'rtime',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), 
        if strcmpi(FileFormat, 'EDF'), %EDF datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.RiseDur(1); 
            elseif BothChanUsed, Value = StimParam.RiseDur(end); end    
        elseif any(strcmpi(StimType, {'THR', 'NRHO', 'ARMIN', 'BERT'})), %SGSR datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.riseDur(1); 
            elseif BothChanUsed, Value = StimParam.riseDur(end); end    
        elseif any(strcmpi(StimType, {'SPL', 'NSPL', 'ITD', 'NTD', 'FS', 'BFS', ...
                    'FM', 'IID', 'LMS', 'IMS', 'BMS', 'BB'})), %IDF/SPK datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.indiv.stim{1}.rise; 
            elseif BothChanUsed, Value = ds.StimParam.indiv.stim{end}.rise; end    
        end    
    end;
%FTIME: Stimulus envelope Fall time (millisecs) (*)
case 'ftime',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds), 
        if strcmpi(FileFormat, 'EDF'), %EDF datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.FallDur(1); 
            elseif BothChanUsed, Value = StimParam.FallDur(end); end    
        elseif any(strcmpi(StimType, {'THR', 'NRHO', 'ARMIN', 'BERT'})), %SGSR datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.fallDur(1); 
            elseif BothChanUsed, Value = StimParam.fallDur(end); end    
        elseif any(strcmpi(StimType, {'SPL', 'NSPL', 'ITD', 'NTD', 'FS', 'BFS', ...
                    'FM', 'IID', 'LMS', 'IMS', 'BMS', 'BB'})), %IDF/SPK datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.indiv.stim{1}.fall; 
            elseif BothChanUsed, Value = ds.StimParam.indiv.stim{end}.fall; end    
        end    
    end;
%DELAY: Initial delay of Master DSS (*)
case 'delay',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        if strcmpi(FileFormat, 'EDF'), %EDF datasets ...
            if (size(ds.StimParam.Delay, 1) > 1), %Delay is varied ...
                if strcmpi(DSSName, 'master'), Value = ds.StimParam.Delay(iSubRec, 1); 
                elseif BothChanUsed, Value = ds.StimParam.Delay(iSubRec, end); end    
            else,
                if strcmpi(DSSName, 'master'), Value = ds.StimParam.Delay(1); 
                elseif BothChanUsed, Value = ds.StimParam.Delay(end); end    
            end    
        elseif any(strcmpi(StimType, {'THR', 'NRHO', 'ARMIN'})), %SGSR datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.delay(1); 
            elseif BothChanUsed, Value = StimParam.delay(end); end    
        elseif any(strcmpi(StimType, {'SPL', 'NSPL', 'FS', 'FM', 'IID', 'LMS', 'IMS', ...
                    'BMS', 'BB', 'CFS', 'CSPL'})), %IDF/SPK datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.indiv.stim{1}.delay; 
            elseif BothChanUsed, Value = ds.StimParam.indiv.stim{end}.delay; end
        elseif strcmpi(StimType, 'NTD'), %Delay is varied ...
            if strcmpi(DSSName, 'master'), Value = ds.indepval(iSubRec, 1); 
            elseif BothChanUsed, Value = ds.indepVal(iSubRec, end); end
        end    
    end    
%SPL: Fixed SPL (dB) (*)
case 'spl',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        SPL = GetSPL(ds);
        if strcmpi(DSSName, 'master'), Value = SPL(iSubRec, 1); 
        elseif BothChanUsed, Value = SPL(iSubRec, 2); end 
        uValue = unique(Value); if (length(uValue) == 1), Value = uValue; end %Try to reduce frequency to a scalar ...
    end    
%FCARR, FREQ: Carrier or fixed frequency (Hz) (*)
case {'freq', 'fcarr'},
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        S = GetFreq(ds); %To be sure frequency conventions are equal between EDF and SGSR/Pharmington datasets ...
        if strcmpi(DSSName, 'master'), Value = S.CarFreq(iSubRec, 1);
        elseif BothChanUsed, Value = S.CarFreq(iSubRec, 2); end
        uValue = unique(Value); if (length(uValue) == 1), Value = uValue; end %Try to reduce frequency to a scalar ...
    end    
%PHASE: Carrier initial phase (0 to 1) (*)
case 'phase',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(ds.FileFormat, 'EDF'),
        if max(iSubRec) > size(ds.Special.CarPhase, 1), return; end
        if strcmpi(DSSName, 'master'), Value = ds.Special.CarPhase(iSubRec, 1);
        elseif BothChanUsed, Value = ds.Special.CarPhase(iSubRec, 2); end    
    end    
%DMOD: Depth of modulation (*)
case 'dmod',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(ds.FileFormat, 'EDF'),
        if strcmpi(FileFormat, 'EDF'), %EDF datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.FreqParam.ModDepth(1); 
            elseif BothChanUsed, Value = ds.StimParam.FreqParam.ModDepth(end); end
        elseif any(strcmpt(StimType, {'BERT'})), %SGSR datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.modDepth/100; 
            elseif BothChanUsed, Value = ds.StimParam.modDepth/100; end    
        elseif any(strcmpi(StimType, {'SPL', 'ITD', 'FS'})), %IDF/SPK datasets ...
            if strcmpi(DSSName, 'master'), Value = ds.StimParam.indiv.stim{1}.modpercent/100; 
            elseif BothChanUsed, Value = ds.StimParam.indiv.stim{end}.modpercent/100; end    
        end    
    end    
%FMOD: Fixed modulation frequency (*)
case 'fmod',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        S = GetFreq(ds); %To be sure frequency conventions are equal between EDF and SGSR/Pharmington datasets ...
        if strcmpi(DSSName, 'master'), Value = S.ModFreq(iSubRec, 1);
        elseif BothChanUsed, Value = S.ModFreq(iSubRec, 2); end
        uValue = unique(Value); if (length(uValue) == 1), Value = uValue; end %Try to reduce frequency to a scalar ...
    end    
%PHASM, PHASEM: Modulation initial phase (0 to 1) (*)
case {'phasm', 'phasem'},
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(ds.FileFormat, 'EDF'),
        if max(iSubRec) > size(ds.Special.ModPhase, 1), return; end
        if strcmpi(DSSName, 'master'), Value = ds.Special.ModPhase(iSubRec, 1);
        elseif BothChanUsed, Value = ds.Special.ModPhase(iSubRec, 2); end    
    end    
%NUETS: Number of unit event timers (~)
case 'nuets',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), Value = ds.ntimers; end;
%UETNRS: Unit event timer numbers (~)
case 'uetnrs',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), Value = ds.timernrs; end;
%GWFILE: General waveform File-name (char string) (*) (not for SGSR datasets)
case 'gwfile',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'),
        if strcmpi(DSSName, 'master'), Value = ds.GWParam.FileName{1}; 
        elseif BothChanUsed, Value = ds.GWParam.FileName{2}; end    
    end;
%GWID: General waveform ID (char string) (*) (not for SGSR datasets)
case 'gwid',
    Type = 'char';
    if ~isempty(RAPStat) &~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        if strcmpi(DSSName, 'master'), Value = ds.GWParam.ID{1}; 
        elseif BothChanUsed, Value = ds.GWParam.ID{2}; end    
    end;
%GWLEN: General Waveform length (not for SGSR datasets)
case 'gwlen',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        if strcmpi(DSSName, 'master'), Value = ds.GWParam.NPoints(1); 
        elseif BothChanUsed, Value = ds.GWParam.NPoints(2); end    
    end;
%GWINT: General Waveform interval (microsecs) (not for SGSR datasets)
case 'gwint',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        if strcmpi(DSSName, 'master'), Value = ds.GWParam.PbPer(1); 
        elseif BothChanUsed, Value = ds.GWParam.PbPer(2); end    
    end;
%GPGWI1: First Waveform ID from Gewab-pair expt. (char) (~) (not for SGSR datasets)
case 'gpgwi1',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & ...
       ~isempty(ds.ShiftGWParam),     
        Value = ds.GWParam.ID{1}; 
    end;
%GPGWI2: Second Waveform ID from Gewab-pair expt. (char) (~) (not for SGSR datasets)
case 'gpgwi2',
    Type = 'char';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & ...
       ~isempty(ds.ShiftGWParam),     
        Value = ds.GWParam.ID{2}; 
    end;
%ITRATE: ITD rate for shifted-GW stimulus (microsecs/sec) (not for SGSR datasets)
case 'itrate',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & ...
       ~isempty(ds.ShiftGWParam), 
        Value = ds.ShiftGWParam.ITDRate; 
    end;
%SGITD1: Shifted-GW ITD1 for shifted-GW stimulus (microsecs) (not for SGSR datasets)
case 'sgitd1',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & ...
       ~isempty(ds.ShiftGWParam), 
        Value = ds.ShiftGWParam.ITD1; 
    end;
%SGITD2: Shifted-GW ITD2 for shifted-GW stimulus (microsecs) (not for SGSR datasets)
case 'sgitd2',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF') & ...
       ~isempty(ds.ShiftGWParam), 
        Value = ds.ShiftGWParam.ITD2; 
    end;
%MDSS: Master DSS number (not for SGSR datasets)
case 'mdss',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        Value = ds.DSS(1).Nr; 
    end;
%DSS1: DSS-1 use flag (0 or 1) (not for SGSR datasets)
case 'dss1',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        DSS = ds.DSS;
        Value = any([DSS.Nr] == 1); 
    end;
%DSS2: DSS-2 use flag (0 or 1) (not for SGSR datasets)
case 'dss2',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds) & strcmpi(FileFormat, 'EDF'), 
        DSS = ds.DSS;        
        Value = any([DSS.Nr] == 2); 
    end;
%XVAR: Table of X-var values from most recent plot (array)
case 'xvar',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.XData'), Value = RAPStat.CalcData.XData; end
%YVAR: Table of Y-var values from most recent plot (array)
case 'yvar',
    Type = 'double'; NaNCheck = logical(0);
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.YData'), Value = RAPStat.CalcData.YData; end
%THCF: Characteristic frequency from Tuning curve data (~)
case 'thcf',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.Thr.CF'), Value = RAPStat.CalcData.Thr.CF; end
%THTHR: Minimum threshold from Tuning curve data (~)
case 'ththr',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.Thr.minThr'), Value = RAPStat.CalcData.Thr.minThr; end
%THQ: Estimated Q-factor from Tuning curve data
case 'thq',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.Thr.Q'), Value = RAPStat.CalcData.Thr.Q; end
%THBW: Estimated bandwidth from Tuning curve data
case 'thbw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Thr.BW'), Value = RAPStat.CalcData.Thr.BW; end
%THSPON: Spon. Activity Count from TH data (~)
case 'thspon',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Thr.SponAct'), Value = RAPStat.CalcData.Thr.SponAct; end
%VALMAX: Largest value from most recent RA plot
case 'valmax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.MaxVal'), Value = RAPStat.CalcData.Rate.MaxVal; end
%VALMIN: Minimum value from most recent RA plot
case 'valmin',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.MinVal'), Value = RAPStat.CalcData.Rate.MinVal; end
%XVMAX: Value of X-var at VALMAX from RA plot
case 'xvmax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.XatMax'), Value = RAPStat.CalcData.Rate.XatMax; end
%XVMIN: Value of X-var at VALMIN from RA plot
case 'xvmin',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.XatMin'), Value = RAPStat.CalcData.Rate.XatMin; end
%YVMAX: Value of Y-var at VALMAX from RA plot
case 'yvmax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.YatMax'), Value = RAPStat.CalcData.Rate.YatMax; end
%YVMIN: Value of Y-var at VALMIN from RA plot
case 'yvmin',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.YatMin'), Value = RAPStat.CalcData.Rate.YatMin; end
%NUMXVAR: Number of X-var values in most recent RA computation
case 'numxvar',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.NumX'), Value = RAPStat.CalcData.Rate.NumX; end
%NUMYVAR: Number of Y-var values in most recent RA computation
case 'numyvar',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Rate.NumY'), Value = RAPStat.CalcData.Rate.NumY; end
%BINW: Bin-width of most recently computed histogram
case 'binw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Hist.BinWidth'), Value = RAPStat.CalcData.Hist.BinWidth; end
%NSPKMAX: Max. number of spikes from most recent PST (~)
case 'nspkmax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat,'CalcData.PST.NSpk'), Value = RAPStat.CalcData.PST.NSpk; end
%SYNCCO: Max. Sync. Coeff. from most recent CH plot (~)
case 'syncco',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Cyc.MaxR'), Value = RAPStat.CalcData.Cyc.MaxR; end
%RAYSIG: Max. Rayleigh Coeff. from most recent CH plot (~)
case 'raysig',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Cyc.RaySig'), Value = RAPStat.CalcData.Cyc.RaySig; end
%PHASEMAX: Max. phase for most recent cycle histogram (~)
case 'phasemax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Cyc.MaxPh'), Value = RAPStat.CalcData.Cyc.MaxPh; end
%PHASEMIN: Min. phase for most recent cycle histogram (~)
case 'phasemin',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.Cyc.MinPh'), Value = RAPStat.CalcData.Cyc.MinPh; end
%REFRAC: Refractory period from most recent ISI histogram (~)
case 'refrac',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.ISI.ReFrac'), Value = RAPStat.CalcData.ISI.ReFrac; end
%SACDF: Dominant frequency from most recent Autocorrelogram (~)
case 'sacdf',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.SAC.DF'), Value = RAPStat.CalcData.SAC.DF; end
%SACBW: Bandwidth from most recent Autocorrrelogram (~)
case 'sacbw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.SAC.BW'), Value = RAPStat.CalcData.SAC.BW; end
%SACPH: Peakheight from most recent Autocorrelogram (~)
case 'sacph',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.SAC.PH'), Value = RAPStat.CalcData.SAC.PH; end
%SACHHW: Halfheight width from most recent Autocorrelogram (~)
case 'sachhw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.SAC.HHW'), Value = RAPStat.CalcData.SAC.HHW; end
%XCDF: Dominant frequency from most recent Crosscorrelogram (~)
case 'xcdf',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.XC.DF'), Value = RAPStat.CalcData.XC.DF; end
%XCBW: Bandwidth from most recent Crosscorrrelogram (~)
case 'xcbw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.XC.BW'), Value = RAPStat.CalcData.XC.BW; end
%XCPH: Peakheight from most recent Crosscorrelogram (~)
case 'xcph',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.XC.PH'), Value = RAPStat.CalcData.XC.PH; end
%XCHHW: Halfheight width from most recent Crosscorrelogram (~)
case 'xchhw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.XC.HHW'), Value = RAPStat.CalcData.XC.HHW; end
%DIFDF: Dominant frequency from most recent DifCor (~)
case 'difdf',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.DIF.DF'), Value = RAPStat.CalcData.DIF.DF; end
%DIFBW: Bandwidth from most recent Difcor (~)
case 'difbw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.DIF.BW'), Value = RAPStat.CalcData.DIF.BW; end
%DIFPH: Peakheight from most recent Difcor (~)
case 'difph',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.DIF.PH'), Value = RAPStat.CalcData.DIF.PH; end
%DIFHHW: Halfheight width from most recent Difcor (~)
case 'difhhw',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.DIF.HHW'), Value = RAPStat.CalcData.DIF.HHW; end
%VSMMAX: Maximum synchronicity from most recent Vector strength magnitude curve (~)
case 'vsmmax',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSM.MaxR'), Value = RAPStat.CalcData.VSM.MaxR; end
%VSMBVAL: Best value of independent variable from most recent Vector strength magnitude curve (~)
case 'vsmbval',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSM.BestVal'), Value = RAPStat.CalcData.VSM.BestVal; end
%VSMCO: Cutoff synchronicity from most recent Vector strength magnitude curve (~)
case 'vsmco',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSM.CutOffR'), Value = RAPStat.CalcData.VSM.CutOffR; end
%VSMCOVAL: Cutoff value of independent variable from most recent Vector strength magnitude curve (~)
case 'vsmcoval',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSM.CutOffVal'), Value = RAPStat.CalcData.VSM.CutOffVal; end
%VSMRAYSIG: Table of rayleigh significance values of most recent Vector strength magnitude curve (~)
case 'vsmraysig',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSM.RaySign'), Value = RAPStat.CalcData.VSM.RaySign; end
%VSPCD: Characterictic delay from most recent Vector strength phase curve (~)
case 'vspcd',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSP.CD'), Value = RAPStat.CalcData.VSP.CD; end
%VSPCP: Characteristic phase from most recent Vector strength phase curve (~)
case 'vspcp',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSP.CP'), Value = RAPStat.CalcData.VSP.CP; end
%VSPRAYSIG: Table of rayleigh significance values of most recent Vector strength magnitude curve (~)
case 'vspraysig',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.VSP.RaySign'), Value = RAPStat.CalcData.VSP.RaySign; end
%ISCV: Mean Coeff. of Variation of Interspike intervals (~)
case 'iscv',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.RGL.CV'), Value = RAPStat.CalcData.RGL.CV; end
%TRDAVG: Average rate from most recent trial rate distribution (~)
case 'trdavg',
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.TRD.Avg'), Value = RAPStat.CalcData.TRD.Avg; end
%TRDSTD: Standard deviation on rate from most recent trial rate distribution (~)
case 'trdstd',    
    Type = 'double';
    if ~isempty(RAPStat) & ~isRAPStatDef(RAPStat, 'CalcData.TRD.Std'), Value = RAPStat.CalcData.TRD.Std; end
%XMIN: X-minimum for most recent plot
case 'xmin',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = min(xlim(RAPStat.PlotParam.Axis.Hdl)); end
%XMAX: X-maximum for most recent plot
case 'xmax',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = max(xlim(RAPStat.PlotParam.Axis.Hdl)); end
%YMIN: Y-minimum for most recent plot
case 'ymin',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = min(ylim(RAPStat.PlotParam.Axis.Hdl)); end
%YMAX: Y-maximum for most recent plot
case 'ymax',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = max(ylim(RAPStat.PlotParam.Axis.Hdl)); end
%XVLL: Log or Linear increment for X-var (1=linear, 2=log)
case 'xvll',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = upper(get(RAPStat.PlotParam.Axis.Hdl, 'XScale')); Value = Value(1:3); end
%YVLL: Log or Linear increment for Y-var (1=linear, 2=log)
case 'yvll',
    Type = 'double';
    if ~isempty(RAPStat) & ishandle(RAPStat.PlotParam.Axis.Hdl), Value = upper(get(RAPStat.PlotParam.Axis.Hdl, 'YScale')); Value = Value(1:3); end
%AWLO: Low analysis window from most recent comp. (millisecs)
case 'awlo',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        [AnWin, ErrTxt] = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
        if ~isempty(ErrTxt), return; end
        Value = min(AnWin);
    end
%AWHI: High analysis window from most recent comp. (millisecs)
case 'awhi',
    Type = 'double';
    if ~isempty(RAPStat) & ~isempty(ds),
        [AnWin, ErrTxt] = GetRAPCalcParam(RAPStat, 'nr', 'AnWin');
        if ~isempty(ErrTxt), return; end
        Value = max(AnWin);
    end
otherwise, %Check if substitution variable isn't in the extension list ...
    idx = find(strcmp(SubstVarName, {ExtSubstVarList.VarName}));
    if ~isempty(idx),
        Type = ExtSubstVarList(idx).Type;
        if ~isempty(RAPStat) & ~isempty(ds),
            TokenList = Words2Cell(ExtSubstVarList(idx).FieldName, '.');
            try, Value = getfield(ds, TokenList{:}); 
            catch, error(sprintf('Dataset fieldname %s in ''RAPSUBSTVAR.M'' doesn''t exist for this dataset.', ExtSubstVarList(idx).FieldName)); end
            if ~isa(Value, Type), error(sprintf('Dataset fieldname %s in ''RAPSUBSTVAR.M'' is not of type ''%s''.', ExtSubstVarList(idx).FieldName, Type)); end
        end
    else, return; end
end

%NaN values in output would rise problems in calculations and in using these calculated
%values further on as calculation or plot parameters ...
if NaNCheck & any(isnan(Value(:))), Value = []; end
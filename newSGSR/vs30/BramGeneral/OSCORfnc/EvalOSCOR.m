function ArgOut = EvalOSCOR(varargin)
%EVALOSCOR calculate and plot relevant information on OSCOR-related dataset
%   EVALOSCOR(ds, ...) calculates and plots relevant information on dataset
%   ds, containing responses of a cell or fiber to oscillating correlation
%   noise (OSCOR) or the binaural beat stimulus (BB).
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   All calculations are cached. To clear the current cache use 'clrcache' 
%   as only input argument.
%
%   See also MADDATASET

%Attention! When analyzing datasets created by CRBIN.M, the cache should not
%be used, because many different datasets with the same filename and ID are
%created by CRBIN.M (differences in reference noise token used and difference
%in coincidence window). The cache of EVALOSCOR.M only differentiates based
%on filename and ID so these different datasets occupy the same cache entry.

%B. Van de Sande 18-04-2005

%------------------------------------template------------------------------------
Template.DS.FileName      = '';  %Identification of datasets
Template.DS.iCell         = NaN;
Template.DS.SeqID         = '';
Template.DS.StimType      = '';
Template.Tag              = 0;   %General purpose tag field
Template.Loc              = '';  %Histological structure
Template.THR.CF           = NaN; %Data extracted from threshold curve
Template.THR.Thr          = NaN;
Template.THR.SA           = NaN;
Template.THR.BW           = NaN;
Template.THR.Q10          = NaN;
Template.RCN.Thr          = NaN; %Data extracted from rate curve
Template.Param.dbselect   = '';  %Calculation parameters 
Template.Param.isubseq    = [];
Template.Param.anwin      = [NaN NaN];
Template.Param.nbin       = NaN;         
Template.Param.binfreq    = NaN;
Template.Param.rcutoffthr = NaN;
Template.Param.zcutoffthr = NaN;
Template.Param.unwrpalg   = '';
Template.Param.delayacc   = NaN;
Template.Param.mxwrapstp  = NaN;
Template.Param.effsplcf   = NaN;
Template.Param.effsplbw   = NaN;
Template.StimParam.SPL    = NaN; %Stimulus parameters
Template.StimParam.ITD    = NaN;
Template.StimParam.EffSPL = NaN;
Template.CALC.IndepVal    = [];  %Vector with values of independent variable
Template.CALC.R           = [];  %Vector with vector strength
Template.CALC.MaxR        = NaN; %Maximum vector strength
Template.CALC.BVar        = NaN; %Value of independent variable at this maximum
Template.CALC.RSatMax     = NaN; %Rayleigh Significance at maximum vector strength
Template.CALC.COVar       = NaN; %Cutoff value of independent variable
Template.CALC.Z           = [];  %Vector with rayleigh significance
Template.CALC.HSVar       = NaN; %Highest Significant Value of independent variable
Template.CALC.WPh         = [];  %Vector with wrapped phase
Template.CALC.Ph          = [];  %Vector with unwrapped phase
Template.CALC.Delay       = NaN; %Delay in milliseconds
Template.CALC.N           = [];  %Vector with number of spikes
Template.CALC.Rate        = [];  %Vector with rate

%------------------------------------parameters-----------------------------------
DefParam.dbselect    = 'userdata'; %'userdata' or 'convtable' ...
DefParam.subseqinput = 'indepval'; %'indepval' or 'subseq' ...
DefParam.isubseq     = NaN;        %NaN denotes all subsequences ...
DefParam.anwin       = 'burstdur'; %'burstdur' designates stimulus duration ...
DefParam.nbin        = 64;         
DefParam.binfreq     = -1;         %Negative binning frequency denotes multiplication
                                   %of values of independent variable with absolute
                                   %value of supplied property value ...
DefParam.rcutoffthr  = 3;
DefParam.zcutoffthr  = 6.91;
DefParam.unwrpalg    = 'i';        %With iteration or normal ...
DefParam.delayacc    = 0.005;
DefParam.mxwrapstp   = 0.4;
DefParam.effsplcf    = 'cf';       %in Hz or 'cf' ...
DefParam.effsplbw    = 1/3;        %in octaves ...
%When value of property 'cache' is set to 'yes' the actual calculation is only started
%if the calculated data is not stored in the cache. A value of 'no' designates the 
%cache is not altered in any way, e.g. the calculations are always done and are not stored
%in the cache afterwards. A value of 'update' means that the calculation is always started
%from scratch and afterwards stored in the cache even if an entry is already present in
%the cache ...
DefParam.cache       = 'yes';      %'yes', 'no' or 'update' ...
DefParam.plot        = 'yes';      %'yes' or 'no' ...

%----------------------------------main program------------------------------------
%Evaluate input arguments ...
if (nargin < 1)
    error('Wrong number of input arguments');
elseif (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return
elseif (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'clrcache')
    EmptyCacheFile(mfilename);
    return
else
    DS = varargin{1};
end
%Check supplied dataset ...
if ~any(strcmp(DS.FileFormat, {'MADDATA', 'MDF'}))
    error('Dataset doesn''t contain Madison-data.');
end
if ~any(strcmp(DS.StimType, {'OSCR', 'OSCRCTL', 'NSPL', 'OSCRTD', 'BB'}))
    error('Dataset doesn''t contain OSCOR-related data.'); 
end
%Check properties and their values ...
Param = checkproplist(DefParam, varargin{2:end});
Param = CheckParam(Param, DS);

%Extract stimulus parameters ...
StimParam = GetStimParam(DS, Param);

%Retrieving threshold curve information from userdata or from conversion table ...
if strncmpi(Param.dbselect, 'u', 1) %Retrieving data from SGSR server ...
    try
        UD = getuserdata(DS.filename, DS.icell);
        if isempty(UD)
            error('To catch block ...');
        end
        %Threshold curve information ...
        if ~isempty(UD.CellInfo) && ~isnan(UD.CellInfo.THRSeq)
            dsTHR = dataset(DS.filename, UD.CellInfo.THRSeq);
            [CF, SA, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
            THR = CollectInStruct(CF, Thr, SA, BW, Q10);
        else
            THR = ...
                struct('CF', NaN, 'Thr', NaN, 'SA', NaN, 'BW', NaN, 'Q10', NaN);
        end
        %Location ...
        if ~isempty(UD.Experiment)
            Loc = UD.Experiment.ExposedStr;
        else
            Loc = '';
        end
        %Rate curve information ...
        if isfield(UD.CellInfo, 'RCNTHR')
            RCN.Thr = UD.CellInfo.RCNTHR;
        else
            RCN = struct([]); 
        end
    catch 
        warning('%s\nAdditional information from SGSR server is not included.', ...
            lasterr); 
        [THR, Loc, RCN] = deal(struct('CF', NaN, 'Thr', NaN, 'SA', NaN, ...
            'BW', NaN, 'Q10', NaN), '', struct([]));
    end
else %Retrieving data from conversion table ...
    try
        DF = CheckMadisonDataFile(DS.ID.FileName);
        [THR, Loc] = GetMadisonCellParam(DF, DS.icell); 
        RCN = struct([]);
    catch 
        warning('%s\nAdditional information from conversion table is not included.', lasterr); 
        [THR, Loc, RCN] = deal(struct('CF', NaN, 'Thr', NaN, 'SA', NaN, 'BW', NaN, 'Q10', NaN), '', struct([]));
    end
end

%Determine CF and BW of filter for effective SPL calculation ...
if ischar(Param.effsplcf) && strcmpi(Param.effsplcf, 'cf')
    if ~isempty(THR) && ~isnan(THR.CF)
        Param.effsplcf = THR.CF;
    else
        warning('Calculating overall effective SPL, because center frequency for filter cannot be extracted.');
        [Param.effsplcf, Param.effsplbw] = deal([]);
    end
end

%Caching system caches extracted calculation parameters and effective SPL ...
if any(strncmpi(Param.cache, {'y', 'u'}, 1))
    SearchParam = structcat(struct('filename', DS.FileName, 'seqid', DS.SeqID), ...
        getfields(Param, {'isubseq', 'anwin', 'nbin', 'calcbinfreq', ...
        'rcutoffthr', 'zcutoffthr', 'unwrpalg', 'delayacc', 'mxwrapstp', ...
        'effsplcf', 'effsplbw'}));
    CacheData = FromCacheFile(mfilename, SearchParam);
    if ~isempty(CacheData) && ~strncmpi(Param.cache, 'u', 1)
        %Retrieve data from cache ...
        [CALC, StimParam.EffSPL] = deal(CacheData.calcdata, CacheData.effspl);
        fprintf('Data retrieved from cache ...\n');
    else
        %Perform actual calculation ...
        CALC = CalcMTFs(DS, Param);
        StimParam.EffSPL = ExtractEffSPL(DS, Param, StimParam);
        %Saving calulated data in cache ...
        ToCacheFile(mfilename, +1000, SearchParam, ...
            struct('calcdata', CALC, 'effspl', StimParam.EffSPL));
        fprintf('Data written to cache ...\n');
    end
else
    %Perform actual calculation ...
    CALC = CalcMTFs(DS, Param);
    StimParam.EffSPL = ExtractEffSPL(DS, Param, StimParam);
end
   
%Assemble data ...
Data = CollectInStruct(DS, THR, Loc, RCN, Param, StimParam, CALC);

%If requested display information ...
if strncmpi(Param.plot, 'y', 1)
    PlotOSCOR(Data, Param);
end

%If requested return information ...
if (nargout ~= 0)
    ArgOut = structtemplate(Data, Template, 'reduction', 'off');
end

%----------------------------------local functions------------------------------------
function Param = CheckParam(Param, ds)

if ~any(strncmpi(Param.dbselect, {'u', 'c'}, 1))
    error('Property dbselect must be ''userdata'' or ''convtable''.'); 
end
if ~ischar(Param.subseqinput) || ...
        ~any(strncmpi(Param.subseqinput, {'indepval', 'subseq'}, 1))
    error('Value for property subseqinput must be ''indepval'' or ''subseq''.');
end
if isnan(Param.isubseq)
    Param.isubseq = 1:ds.nsubrecorded;
elseif ~isnumeric(Param.isubseq) || (ndims(Param.isubseq) > 2) || ...
        ~any(size(Param.isubseq) == 1)
    error('Value for property isubseq must be numeric vector.');
elseif strncmpi(Param.subseqinput, 'indepval', 1)
    if ~all(ismember(Param.isubseq, unique(ds.indepval)))
        error('Wrong value for property isubseq.');
    else
        Param.isubseq = find(ismember(ds.indepval, Param.isubseq));
    end
elseif ~all(ismember(Param.isubseq, 1:ds.nsubrecorded))
    error('Wrong value for property isubseq.'); 
end
[Param.indepval, idx] = sort(ds.indepval(Param.isubseq)');
Param.isubseq = Param.isubseq(idx);
Param.anwin = ExpandAnWin(ds, Param.anwin);
if isempty(Param.anwin)
    error('Invalid value for property anwin.');
end
if ~isnumeric(Param.nbin) || (length(Param.nbin) ~= 1) || (Param.nbin <= 0)
    error('Invalid value for property nbin.'); 
end
if ~isnumeric(Param.binfreq) || (length(Param.binfreq) ~= 1) || (Param.binfreq == 0)
    error('Invalid value for property binfreq.'); 
end
if (Param.binfreq < 0)
    switch lower(ds.StimType)
        case {'oscr', 'oscrctl', 'bb'},
        %For OSCR- and OSCRCTL-datasets the modulation frequency is the independent variable, and
        %these values are taken as the binning frequency. For BB-datasets the binaural beat frequency
        %is the independent variable, and these values are also taken as the binnibg frequency ...
            Param.calcbinfreq = abs(Param.binfreq)*Param.indepval;
        case {'oscrtd', 'nspl'}
        %For OSCRTD- and NSPL-datasets the modulation frequency is taken as the binning frequency,
        %but is is not the independent variable. The modulation frequency is a constant ...
            Param.calcbinfreq = repmat(abs(Param.binfreq)*ds.modfreq, length(Param.isubseq), 1);
    end
else
    Param.calcbinfreq = repmat(Param.binfreq, length(Param.isubseq), 1);
end
if ~isnumeric(Param.rcutoffthr) || (length(Param.rcutoffthr) ~= 1) || ...
        (Param.rcutoffthr <= 0)
    error('Invalid value for property rcutoffthr.'); 
end
if ~isnumeric(Param.zcutoffthr) || (length(Param.zcutoffthr) ~= 1) || ...
        (Param.zcutoffthr <= 0)
    error('Invalid value for property zcutoffthr.'); 
end
if ~any(strncmpi(Param.unwrpalg, {'i', 'n'}, 1))
    error('Property unwrpalg must be ''iter'' or ''normal''.');
end

if ~isnumeric(Param.delayacc) || (length(Param.delayacc) ~= 1) || ...
        (Param.delayacc <= 0)
    error('Invalid value for property delayacc.'); 
end
if ~isnumeric(Param.mxwrapstp) || (length(Param.mxwrapstp) ~= 1) || ...
        (Param.mxwrapstp <= 0)
    error('Invalid value for property mxwrapstp.'); 
end
if ~(isnumeric(Param.effsplcf) && (Param.effsplcf > 0)) && ...
        ~(ischar(Param.effsplcf) && strcmpi(Param.effsplcf, 'cf'))
    error('Property effsplcf must be positive integer or ''cf''.'); 
end
if ~isnumeric(Param.effsplbw) || (length(Param.effsplbw) ~= 1) || ...
        (Param.effsplbw <= 0)
    error('Invalid value for property effsplbw.'); 
end
if ~any(strncmpi(Param.cache, {'y', 'n', 'u'}, 1))
    error('Property cache must be ''yes'', ''no'' or ''update''.');
end
if ~any(strncmpi(Param.plot, {'y', 'n'}, 1))
    error('Property plot must be ''yes'' or ''no''.');
end

%-------------------------------------------------------------------------------------
function StimParam = GetStimParam(ds, Param)

%Sound Pressure Level ...
if strcmpi(ds.StimType, 'nspl')
    StimParam.SPL = sort(ds.indepval(Param.isubseq)');
else
    StimParam.SPL = ds.SPL;
end

%Interaural time difference ...
if strcmpi(ds.StimType, 'oscrtd')
    StimParam.ITD = sort(ds.indepval(Param.isubseq)');
else
    StimParam.ITD = ds.ITD;
end

%-------------------------------------------------------------------------------------
function  EffSPL = ExtractEffSPL(DS, Param, StimParam)
    
try
    %Old OSCOR-dataset where collected by ussing multiple datasets ...
    if iscellstr(DS.ID.OrgSeqID)
        N = length(DS.ID.OrgSeqID);
        EffSPL = zeros(N, 2);
        
        %Loading first dataset and collect relevant information ...
        dsOrig = dataset(DS.Filename, DS.ID.OrgSeqID{1});
        constChan = find(strcmpi(dsOrig.GWParam.ID, 'a'));
        varChan = 3 - constChan;
        
        IndEffSPL = CalcEffSPL(dsOrig, 'filtercf', Param.effsplcf, ...
            'filterbw', Param.effsplbw, 'channel', 'both');
        EffSPL(1, varChan) = IndEffSPL(dsOrig.indepval == StimParam.SPL, varChan);
        EffSPL(:, constChan) = IndEffSPL(dsOrig.indepval == StimParam.SPL, constChan);
        
        for n = 2:N
            %Loading dataset in new dataset format...
            dsOrig = dataset(DS.Filename, DS.ID.OrgSeqID{n});
            
            %Calculate effective SPL ...
            IndEffSPL = CalcEffSPL(dsOrig, 'filtercf', ...
                Param.effsplcf, 'filterbw', Param.effsplbw, 'channel', varChan);
            EffSPL(n, varChan) = IndEffSPL(dsOrig.indepval == StimParam.SPL);
        end
        
        %Reorganize effective SPL data ...
        EffSPL = CombineSPLs(EffSPL);
        if isequal(length(unique(EffSPL)), 1)
            EffSPL = EffSPL(1);
        elseif isequal(length(EffSPL), DS.nrec)
            EffSPL = EffSPL(Param.isubseq, :);
        else
            error('Invalid size of EffSPL-vector.');
        end
    %New OSCOR-datasets where collected by one datasets in which the number of the waveform dataset
    %varied ...
    else
        %Loading dataset in new dataset format...
        dsOrig = dataset(DS.Filename, DS.ID.OrgSeqID);
        
        %Calculate effective SPL ...
        EffSPL = CalcEffSPL(dsOrig, 'filtercf', Param.effsplcf, ...
            'filterbw', Param.effsplbw, 'channel', dsOrig.chan);
        
        %Reorganize effective SPL data ...
        if (length(EffSPL) == 19) && strcmpi(DS.StimType, 'oscr') %AN-dataset that was correlated ...
            MonEffSPL = EffSPL;
            EffSPL = zeros(15, 2);
            varChan = dsOrig.chan;
            constChan = 3 - varChan;
            EffSPL(:, varChan) = MonEffSPL(5:19);
            EffSPL(:, constChan) = MonEffSPL(1);
            
            if isequal(length(unique(EffSPL)), 1)
                EffSPL = EffSPL(1);
            else
                IndepVal = unique(Param.indepval);
                N = length(IndepVal); iSubSeq = zeros(N, 1);
                for n = 1:N
                    iSubSeq(n) = find([1,2,5,10,20,50,75,100,150,200,300, ...
                        400,500,750,1000] == IndepVal(n));
                end
                EffSPL = EffSPL(iSubSeq, :);
            end
        else
            if isequal(length(unique(EffSPL)), 1)
                EffSPL = EffSPL(1);
            elseif isequal(length(EffSPL), DS.nsub)
                EffSPL = EffSPL(Param.isubseq, :);
            else
                error('Invalid size of EffSPL-vector.');
            end
        end
    end
catch
    warning(lasterr); EffSPL = NaN;
end

%-------------------------------------------------------------------------------------
function Data = CalcMTFs(ds, Param)

%Extract and sort values of independent variable ...
[IndepVal, iSubSeq] = deal(Param.indepval, Param.isubseq);
Spt = ds.spt(iSubSeq, :);

%Calculate cyclehistograms ...
H = CalcPRDH(Spt, 'anwin', Param.anwin, 'nbin', Param.nbin, 'binfreq', Param.calcbinfreq);

%Combine cyclehistograms if necessary ...
if all(ismember({'+A', '+B', '-A', '-B'}, unique(ds.StimParam.MasterDSS.GWID))),
    MasterGWID = ds.StimParam.MasterDSS.GWID(iSubSeq);
    SlaveGWID = ds.StimParam.SlaveDSS.GWID(iSubSeq);
    Nsub = length(iSubSeq)/4; ModFreq = unique(IndepVal);
    ShiftCorr = Param.calcbinfreq(1:4:end)./Param.indepval(1:4:end);
    for n = 1:Nsub,
        PrdH(n).bincenters = H.hist(n).bincenters;
        idxAp = find(strcmp(MasterGWID, '+A') & strcmp(SlaveGWID, sprintf('AB%d',ModFreq(n))));
        if isempty(idxAp), error(sprintf('No responses to noise token +A/AB%d selected.', ModFreq(n))); end
        idxAn = find(strcmp(MasterGWID, '-A') & strcmp(SlaveGWID, sprintf('AB%d',ModFreq(n))));
        if isempty(idxAn), error(sprintf('No responses to noise token -A/AB%d selected.', ModFreq(n))); end
        idxBp = find(strcmp(MasterGWID, '+B') & strcmp(SlaveGWID, sprintf('AB%d',ModFreq(n))));
        if isempty(idxBp), error(sprintf('No responses to noise token +B/AB%d selected.', ModFreq(n))); end
        idxBn = find(strcmp(MasterGWID, '-B') & strcmp(SlaveGWID, sprintf('AB%d',ModFreq(n))));
        if isempty(idxBn), error(sprintf('No responses to noise token -B/AB%d selected.', ModFreq(n))); end
        PrdH(n).n = H.hist(idxAp).n + ShiftPRDH(H.hist(idxAn).n, mod(0.5*abs(Param.binfreq), 1)) + ...
            ShiftPRDH(H.hist(idxBp).n, mod(0.75*abs(Param.binfreq), 1)) + ShiftPRDH(H.hist(idxBn).n, mod(0.25*abs(Param.binfreq), 1));
        PrdH(n).nspk = sum(cat(2, H.hist([idxAp, idxAn, idxBp, idxBn]).nspk));
        Nrep = ds.nrep; NCyc = H.hist(n).ncyc; BinDur = H.hist(n).bindur;
        PrdH(n).rate = PrdH(n).n/4/Nrep/NCyc/BinDur;
        xCo = sum(PrdH(n).n.*cos(2*pi*PrdH(n).bincenters));
        yCo = sum(PrdH(n).n.*sin(2*pi*PrdH(n).bincenters));
        PrdH(n).r = sqrt(xCo^2 + yCo^2)/PrdH(n).nspk;
        PrdH(n).ph = atan2(yCo, xCo)/2/pi;
        if (PrdH(n).ph < 0), PrdH(n).ph = PrdH(n).ph + 1; end
        PrdH(n).raysign = rayleighSign(PrdH(n).r, PrdH(n).nspk);
    end
    IndepVal = ModFreq;
    if (Param.binfreq < 0), BinFreq = abs(Param.binfreq)*ModFreq;
    else BinFreq = repmat(Param.binfreq, Nsub, 1); end
else 
    PrdH = H.hist; 
    BinFreq = Param.calcbinfreq;
end

%Reorganizing calculated data ...
X    = cat(1, PrdH.bincenters);
Y    = cat(1, PrdH.rate);
R    = cat(1, PrdH.r);
RS   = cat(1, PrdH.raysign);
WPh  = cat(1, PrdH.ph);
N    = cat(1, PrdH.nspk);
Z    = N .* (R.^2);
Rate = 1000 * N /diff(Param.anwin) /ds.nrep;

%Calculate specific data ...
switch lower(ds.StimType),
case {'oscr', 'oscrctl', 'bb'}     
    MaxR = max(R(Z >= Param.zcutoffthr));
    if isempty(MaxR), [MaxR, RSatMax, BVar, COVar] = deal(NaN);
    else
        RSatMax = RS(R == MaxR);    %Cannot use index returned by MAX because intermediate
        BVar = IndepVal(R == MaxR); %insignificant points can introduce a shift ...
        
        RCutOff = MaxR/(10^(Param.rcutoffthr/10));
        COVar = local_getintersect(IndepVal, R, RCutOff);
    end
    
    HSVar = local_getintersect(IndepVal, Z, Param.zcutoffthr);
    [Ph, Delay] = local_unwrap(WPh, Z, BinFreq(:), Param);
    
    Data = CollectInStruct(BinFreq, IndepVal, X, Y, R, MaxR, RSatMax, BVar, COVar, Z, HSVar, WPh, Ph, Delay, N, Rate);
case 'nspl'
    MaxR = max(R(Z >= Param.zcutoffthr));
    if isempty(MaxR), [MaxR, BVar] = deal(NaN);
    else BVar = IndepVal(R == MaxR); end
    
    Ph = WPh; %Phase doesn't need to be unwrapped, so wrapped phase equals unwrapped phase ...
    Data = CollectInStruct(BinFreq, IndepVal, X, Y, R, MaxR, BVar, Z, WPh, Ph, N, Rate);
case 'oscrtd', 
    Ph = WPh; %Phase doesn't need to be unwrapped, so wrapped phase equals unwrapped phase ...
    Data = CollectInStruct(BinFreq, IndepVal, X, Y, R, Z, WPh, Ph, N, Rate); 
end

%-----------------------------------------------------------------------------
function N = ShiftPRDH(N, Frac)

Nbin = length(N); idx = round(Nbin*Frac);
N = N([idx+1:end,1:idx]);

%-------------------------------------------------------------------------------------
function Xi = local_getintersect(X, Y, Yc)

hidx = find(Y > Yc);  
lidx = find(Y < Yc);

if ~isempty(lidx)
    idx = min(lidx(lidx' - (1:length(lidx)) > 0));
    if isempty(idx), Xi = NaN;
        return
    end
    
    x1 = X(idx-1); 
    y1 = Y(X == x1); 
    x2 = X(idx);
    y2 = Y(X == x2);
    
    a = (y2-y1)/(x2-x1);
    b = y1 - a*x1;
    
    Xi = (Yc - b)/a;
else
    Xi = NaN;
end

%-------------------------------------------------------------------------------------
function [Ph, Delay] = local_unwrap(Ph, Z, Freq, Param)

Period = 1./Freq;
Center = Ph(1);
if strncmpi(Param.unwrpalg, 'i', 1) %BRAM's algoritme ...iteratie...
    Delay = 0;
    p = 1;
    
    Nsig = find(Z < Param.zcutoffthr, 1 ) - 1; %hoogste significante datapunt...
    if isempty(Nsig)
        Nsig = length(find(~isnan(Ph)));
    end
    inc = 1:Nsig;
    
    while (p(1) <  -Param.delayacc) || (p(1) > Param.delayacc)
        n = find( (diff(Ph(inc)) > -Param.mxwrapstp) & ...
            (diff(Ph(inc)) < +Param.mxwrapstp) );
        idx = find(diff(n) > 1, 1 );
        if isempty(idx)
            n = length(inc);
        else
            n = n(idx)+1;
        end
        p = polyfit(Freq(1:n), Ph(1:n), 1);
        Delay = Delay + p(1);
        ncycles = p(1)./Period;
        Ph  = Ph - mod(ncycles, 1);
        %Alles binnen een cyclus terugbrengen
        Ph(Ph > (Center+0.5)) = Ph(Ph > (Center+0.5)) -1;
        Ph(Ph < (Center-0.5)) = Ph(Ph < (Center-0.5)) +1;
    end
elseif strncmpi(Param.unwrpalg, 'n', 1) %MARCEL's algoritme ...
    Ph = Ph - floor(Ph(1));
    Ph = Ph*2*pi;
    Ph = unwrap(Ph);
    
    Nsig = find(Z < Param.zcutoffthr, 1 ) - 1; %hoogste significante datapunt...
    if isempty(Nsig)
        Nsig = length(find(~isnan(Ph)));
    end
    Nspace = 5; %unwrapping algoritme blijft goed bij MF van 20Hz.
    %Nspace = max(find(diff(ds.indepval)<=50)) - 1; %unwrapping algoritme blijft goed als space tussen datapunten <= 50 Hz
    inc = 1:min(Nsig,Nspace); %vector met mee te nemen datapunten
    p = polyfit(Freq(inc), Ph(inc), 1);
    Delay1 = p(1);
    Ph = unwrap(Ph - Delay1./Period);
    
    inc = 1:Nsig; %bij tweede maal aanpassen van phase enkel rekening houden met significante punten...
    p = polyfit(Freq(inc), Ph(inc), 1);
    Delay2 = p(1);
    Ph = unwrap(Ph - Delay2./Period);
    
    Ph = Ph / (2*pi);
    Delay = (Delay1 + Delay2) / (2*pi);  %de uiteindelijke rico is de som van beide...
    
    %Alles binnen een cyclus terugbrengen 
    Ph(Ph > (Center+0.5)) = Ph(Ph > (Center+0.5)) -1;
    Ph(Ph < (Center-0.5)) = Ph(Ph < (Center-0.5)) +1;
else
    error('Invalid value for property unwrpalg, should iter or nl.');
end

Delay = Delay * 1000; %Omzetten naar milliseconden ...

%-------------------------------------------------------------------------------------
function PlotOSCOR(Data, Param)

switch Data.DS.StimType
case 'OSCRTD'  
    %Plotten van de gegevens ...
    Interface = figure('Name', sprintf('OSCR-project: %s <%s>', Data.DS.FileName, Data.DS.SeqID), ...
        'NumberTitle', 'off', ...
        'PaperOrientation', 'landscape', ...
        'PaperUnits', 'normalized', ...
        'PaperPosition', [0.04 0.04 0.96 0.96], ...
        'PaperType', 'a4letter');
    
    Ax_R = axes('Position', [0.10 0.10 0.35 0.80]); set(Ax_R, 'Box', 'on');
    line(Data.CALC.IndepVal, Data.CALC.R, 'LineStyle', '-', 'Marker', 'o', 'Color', 'b');
    xlabel('ITD(\mus)'); ylabel(['R @ ' int2str(unique(Param.calcbinfreq)) 'Hz']); 
    title(sprintf('R versus ITD for %s <%s>', Data.DS.FileName, Data.DS.SeqID));
    axis([min(Data.CALC.IndepVal) max(Data.CALC.IndepVal) 0 1]);
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.R(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    Ax_Ph = axes('Position', [0.55 0.10 0.35 0.80]); set(Ax_Ph, 'Box', 'on');
    line(Data.CALC.IndepVal, Data.CALC.WPh, 'LineStyle', '-', 'Marker', 'o', 'Color', 'b');
    xlabel('ITD(\mus)'); ylabel(['Ph @ ' int2str(unique(Param.calcbinfreq)) 'Hz']); 
    title(sprintf('Ph versus ITD for %s <%s>', Data.DS.FileName, Data.DS.SeqID));
    axis([min(Data.CALC.IndepVal) max(Data.CALC.IndepVal) 0 1]);
    
    line(Data.CALC.IndepVal(idx), Data.CALC.WPh(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
case 'NSPL'
    %GUI aanmaken ...
    Hdl = CreateGUI(['OSCOR-project:' Data.DS.FileName ' <' Data.DS.SeqID '>']);
    
    %Weergeven van informatie ...
    %Dataset gegevens
    set(Hdl.STB_df, 'String', ['DataFile: ' Data.DS.FileName]);
    set(Hdl.STB_dsID, 'String', ['DataSet ID: ' Data.DS.SeqID]);
    
    %Cell Parameters
    set(Hdl.STB_CF, 'String', ['CF: ' int2str(round(Data.THR.CF)) 'Hz']);
    set(Hdl.STB_SA, 'String', ['SA: ' int2str(round(Data.THR.SA)) 'spikes/sec']);
    set(Hdl.STB_THR, 'String', ['Thr @ CF: ' int2str(round(Data.THR.Thr)) 'dB']);
    set(Hdl.STB_Q10, 'String', ['Q10: ' num2str(Data.THR.Q10) ]);
    set(Hdl.STB_BW, 'String', ['BW: ' int2str(round(Data.THR.BW)) 'Hz' ]);
    
    %Stimulus Parameters
    set(Hdl.STB_nsub_nrep, 'String', [ int2str(Data.DS.nsubrecorded) '/' int2str(Data.DS.nsub) ' SubSeqs. & ' int2str(Data.DS.nrep) ' Reps. @ ' num2str(Data.DS.modfreq) 'Hz']);
    set(Hdl.STB_Stim_RepDur, 'String', ['StimDur: ' int2str(Data.DS.burstdur) 'ms / RepDur: ' int2str(Data.DS.repdur) 'ms']);
    set(Hdl.STB_ITD_SPL, 'String', ['ITD: ' int2str(Data.DS.ITD) 'microsec' ]);
    
    %Plot Parameters
    set(Hdl.STB_nbin, 'String', ['Nr. of bins: ' int2str(Param.nbin) ]);
    set(Hdl.STB_AnWindow, 'String', ['Analysiswindow: [' int2str(Param.anwin(1)) 'ms-' int2str(Param.anwin(2)) 'ms]' ]);
    
    %plotten van de curven ...
    %Vector Strength Magnitude plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_SyIndex);
    plot(Data.CALC.IndepVal, Data.CALC.R, 'bo-');
    title('Vector Strength Magnitude');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')' ]); ylabel(['Magnitude @ ' int2str(unique(Param.calcbinfreq)) 'Hz']);
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] 0 1]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 1]); end
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.R(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    Hdl_MaxRDot = line(Data.CALC.BVar, Data.CALC.MaxR, 'Color', [1 0 0], 'LineStyle', 'none', 'Marker', 'x');
    if (Data.CALC.MaxR < 0.7) || isnan(Data.CALC.MaxR)
        txt = text(Data.CALC.IndepVal(1),1,{[ 'Maximum Synchronisation: ' num2str(Data.CALC.MaxR)]; ...
                [ 'Best SPL: ' num2str(Data.CALC.BVar) 'dB']}, ... 
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    else
        txt = text(Data.CALC.IndepVal(1),0,{[ 'Maximum Synchronisation: ' num2str(Data.CALC.MaxR)]; ...
                [ 'Best SPL: ' num2str(Data.CALC.BVar) 'dB']}, ... 
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    end
    
    %Rayleigh Significantie plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Rayleigh);
    plot(Data.CALC.IndepVal, Data.CALC.Z, 'bo-');
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] 0 800]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 800]); end
    title('Rayleigh Significance');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')']); ylabel('Z = n * R^2');
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.Z(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24);
    
    Hdl_COLn = line([1,Data.CALC.IndepVal(end)], [Param.zcutoffthr, Param.zcutoffthr], 'Color', [1 0 0], 'LineStyle', '--');
    
    %Phase and Ratecurve plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Phasecurve);
    line(Data.CALC.IndepVal, Data.CALC.WPh, 'LineStyle', '-', 'Color', 'b', 'Marker', 'o');
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] 0 1]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 1]); end
    title('Phase- & Ratecurve');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')']);
    ylabel('Phase(cycles)');
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.WPh(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    text(Data.CALC.IndepVal(end), 0,{'O = phase'; 'X = rate'}, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
    
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Ratecurve);
    %Rate = 1000 * Data.CALC.N /(Param.anwin(2)-Param.anwin(1)) /Data.DS.nrep;
    line(Data.CALC.IndepVal, Data.CALC.Rate, 'LineStyle', '-', 'Color', 'r', 'Marker', 'x');
    if (length(Data.CALC.IndepVal) == 1), 
        axis([Data.CALC.IndepVal(1)+[-0.5,+0.5]  Data.CALC.Rate(1)+[-0.5,+0.5]]);
    elseif max(Data.CALC.Rate) < 15
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 15]);
    elseif max(Data.CALC.Rate) < 25
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 25]);
    elseif max(Data.CALC.Rate) < 50
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 50]);
    elseif max(Data.CALC.Rate) < 100   
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 100]);
    else
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 150]);
    end
    ylabel('Rate(spikes/sec)');
    
    PlotHists(Hdl, Data.CALC, Param, Data.StimParam);    
case {'OSCR', 'OSCRCTL', 'BB'}
    if strcmp(Data.DS.IndepVar.PlotScale, 'linear'), plotFunc = 'plot';
    else plotFunc = 'semilogx'; end
    
    %GUI aanmaken ...
    Hdl = CreateGUI(['OSCOR-project:' Data.DS.FileName ' <' Data.DS.SeqID '>']);
    
    %Weergeven van informatie ...
    %Dataset gegevens
    switch Data.Loc
    case 'AN', set(Hdl.STB_df, 'String', ['DataFile: ' Data.DS.FileName ' (NERVE)']);
    case 'IC', set(Hdl.STB_df, 'String', ['DataFile: ' Data.DS.FileName]); end
    set(Hdl.STB_dsID, 'String', ['DataSet ID: ' Data.DS.SeqID]);
    
    %Cell Parameters
    set(Hdl.STB_CF, 'String', ['CF: ' int2str(round(Data.THR.CF)) 'Hz']);
    switch Data.Loc
    case 'AN'
        if Data.THR.SA > 18, set(Hdl.STB_SA, 'String', ['SA: ' int2str(round(Data.THR.SA)) 'spikes/sec (HIGH)']);
        else set(Hdl.STB_SA, 'String', ['SA: ' int2str(round(Data.THR.SA)) 'spikes/sec (LOW)']); end
    case 'IC', set(Hdl.STB_SA, 'String', ['SA: ' int2str(round(Data.THR.SA)) 'spikes/sec']); end
    set(Hdl.STB_THR, 'String', ['Thr @ CF: ' int2str(round(Data.THR.Thr)) 'dB']);
    set(Hdl.STB_Q10, 'String', ['Q10: ' num2str(Data.THR.Q10) ]);
    set(Hdl.STB_BW, 'String', ['BW: ' int2str(round(Data.THR.BW)) 'Hz' ]);
    
    %Stimulus Parameters
    set(Hdl.STB_nsub_nrep, 'String', [ int2str(Data.DS.nsubrecorded) '/' int2str(Data.DS.nsub) ' Subsequences & ' int2str(Data.DS.nrep) ' Repetitions']);
    set(Hdl.STB_Stim_RepDur, 'String', ['StimDur: ' int2str(Data.DS.burstdur) 'ms / RepDur: ' int2str(Data.DS.repdur) 'ms']);
    set(Hdl.STB_ITD_SPL, 'String', ['ITD: ' int2str(Data.DS.ITD) 'microsec / SPL: ' int2str(Data.DS.SPL) 'dB' ]);
    
    %Plot Parameters
    set(Hdl.STB_nbin, 'String', ['Nr. of bins: ' int2str(Param.nbin) ]);
    set(Hdl.STB_AnWindow, 'String', ['Analysiswindow: [' int2str(Param.anwin(1)) 'ms-' int2str(Param.anwin(2)) 'ms]' ]);
    
    %plotten van de curven ...
    %Vector Strength Magnitude plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_SyIndex);
    feval(plotFunc, Data.CALC.IndepVal, Data.CALC.R, 'bo-');
    title('Vector Strength Magnitude');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')' ]); ylabel('Magnitude');
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] 0 1]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 1]); end

    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.R(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    Hdl_MaxRDot = line(Data.CALC.BVar, Data.CALC.MaxR, 'Color', [1 0 0], 'LineStyle', 'none', 'Marker', 'x');
    Hdl_MaxRLn  = line([1, Data.CALC.IndepVal(end)], [Data.CALC.MaxR, Data.CALC.MaxR], 'Color', [1 0 0], 'LineStyle', '--');
    RCutOff = Data.CALC.MaxR/(10^(Param.rcutoffthr/10));
    Hdl_COLn    = line([1, Data.CALC.IndepVal(end)], [RCutOff, RCutOff], 'Color', [1 0 0], 'LineStyle', '--');
    if (Data.CALC.MaxR < 0.7) || isnan(Data.CALC.MaxR)
        text(1,1,{[ 'Maximum Synchronisation: ' num2str(Data.CALC.MaxR)]; [ 'Best Freq.: ' num2str(Data.CALC.BVar) 'Hz']; ...
                [ 'CutOff Freq.: ' num2str(round(Data.CALC.COVar)) 'Hz for ' num2str(Param.rcutoffthr) 'dB']}, ...
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    else
        text(1,0,{[ 'Maximum Synchronisation: ' num2str(Data.CALC.MaxR)]; [ 'Best Freq.: ' num2str(Data.CALC.BVar) 'Hz']; ...
                [ 'CutOff Freq.: ' num2str(round(Data.CALC.COVar)) 'Hz for ' num2str(Param.rcutoffthr) 'dB']}, ...
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    end
    
    %Rayleigh Significantie plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Rayleigh);
    feval(plotFunc, Data.CALC.IndepVal, Data.CALC.Z, 'bo-');
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] 0 800]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 800]); end

    title('Rayleigh Significance');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')']); ylabel('Z = n * R^2');
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.Z(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    Hdl_COLn = line([1,Data.CALC.IndepVal(end)], [Param.zcutoffthr, Param.zcutoffthr], 'Color', [1 0 0], 'LineStyle', '--');
    text(1,800,[ 'Highest Significant Freq.: ' int2str(round(Data.CALC.HSVar)) 'Hz' ], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
    %Phase and Ratecurve plotten ...
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Phasecurve);
    feval(plotFunc, Data.CALC.IndepVal, Data.CALC.Ph, 'bo-');
    set(Hdl.Ax_Phasecurve, 'Box', 'off');
    if (length(Data.CALC.IndepVal) == 1), axis([Data.CALC.IndepVal(1)+[-0.5,+0.5] Data.CALC.Ph(1)-0.5 Data.CALC.Ph(1)+0.5]);
    else axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) Data.CALC.Ph(1)-0.5 Data.CALC.Ph(1)+0.5]); end
    title('Phase- & Ratecurve');
    xlabel([ Data.DS.indepname '(' Data.DS.indepunit ')']);
    ylabel('Phase - (Delay * Freq.)(cycles)');
    
    idx = find(Data.CALC.Z < Param.zcutoffthr);
    line(Data.CALC.IndepVal(idx), Data.CALC.Ph(idx), 'Color', [0 0 1], 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 24)
    
    text(Data.CALC.IndepVal(end), Data.CALC.Ph(1)-0.5,{'O = phase'; 'X = rate'}, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
    text(1, Data.CALC.Ph(1)-0.5, ['Delay = ' num2str(Data.CALC.Delay) 'ms.'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    
    set(Hdl.Interface, 'CurrentAxes', Hdl.Ax_Ratecurve);
    %Rate = 1000 * Data.CALC.N /(Param.anwin(2)-Param.anwin(1)) /Data.DS.nrep;
    feval(plotFunc, Data.CALC.IndepVal, Data.CALC.Rate, 'rx-');
    set(Hdl.Ax_Ratecurve, 'Box', 'off', 'Color', 'none', 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'XTickLabel', [], 'XTick', []);
    if (length(Data.CALC.IndepVal) == 1), 
        axis([Data.CALC.IndepVal(1)+[-0.5,+0.5]  Data.CALC.Rate(1)+[-0.5,+0.5]]);
    elseif max(Data.CALC.Rate) < 15
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 15]);
    elseif max(Data.CALC.Rate) < 25
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 25]);
    elseif max(Data.CALC.Rate) < 50
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 50]);
    elseif max(Data.CALC.Rate) < 100   
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 100]);
    else
        axis([Data.CALC.IndepVal(1) Data.CALC.IndepVal(end) 0 150]);
    end
    ylabel('Rate(spikes/sec)');
    
    PlotHists(Hdl, Data.CALC, Param, Data.StimParam);
end

%-------------------------------------------------------------------------------------
function Hdl = CreateGUI(TitleTxt)

Interface = figure('Name',TitleTxt, ...
   'Units','normalized', ...
	'NumberTitle','off', ...
   'ToolBar','none', 'MenuBar', 'figure',...
	'Position',[0 0.03645833333333333 1 0.9140625], ...
   'Tag','Interface', ...
   'PaperOrientation', 'landscape', ...
   'PaperUnits', 'normalized', ...
   'PaperType', 'A4', ...
   'PaperPosition', [0,0.030,0.95,0.96]);

Ax_SyIndex = axes('Parent', Interface, ...
	'Box','on', ...
	'Position',[0.05859375 0.6837606837606838 0.25390625 0.2849002849002849], ...
   'Tag','SynchronisationIndex');

Ax_Rayleigh = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.37109375 0.6837606837606838 0.244140625 0.2849002849002849], ...
	'Tag','RayleighSignificance');

Ax_Phasecurve = axes('Parent',Interface, ...
	'Box','off', ...
	'Position',[0.673828125 0.6837606837606838 0.2734375 0.2849002849002849], ...
   'Tag','Phasecurve');

Ax_Ratecurve = axes('Parent', Interface, ...
   'Box', 'off', ... 
   'Position', get(Ax_Phasecurve, 'Position'), ...
   'YAxisLocation', 'right', ...
   'XAxisLocation', 'top', ...
   'XTickLabel', [], ...
   'XTick', [], ...
   'Color', 'none', ...
   'Tag','Ratecurve');

Frame = uicontrol(Interface, 'Style', 'frame', ...
   'Units','normalized', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.5273    0.0142    0.4395    0.1994]);

STB_df = uicontrol(Interface, 'Style', 'text',...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.5371    0.1709    0.1855    0.0285], ...
   'String','DataFile:');

STB_dsID = uicontrol(Interface, 'Style', 'text',...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.5371    0.1425    0.1855    0.0285], ...
   'String','DataSet ID:');

STB_CellParam = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
   'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontSize',10, ...
	'Position',[0.5371    0.1140    0.1855    0.0285], ...
   'String','Cell Parameters:');

STB_CF = uicontrol(Interface, 'Style', 'text', ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','Arial', ...
	'HorizontalAlignment','left', ...
	'Position',[0.537109375 0.08547008547008547 0.087890625 0.02849002849002849], ...
   'String','CF: ');

STB_THR = uicontrol(Interface, 'Style', 'text', ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','Arial', ...
	'HorizontalAlignment','left', ...
	'Position',[0.625 0.08547008547008547 0.09765625 0.02849002849002849], ...
	'String','Thr @ CF:');

STB_Q10 = uicontrol(Interface, 'Style', 'text', ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','Arial', ...
	'HorizontalAlignment','left', ...
	'Position',[0.537109375 0.05698005698005698 0.087890625 0.02849002849002849], ...
   'String','Q10: ');

STB_BW = uicontrol(Interface, 'Style', 'text', ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','Arial', ...
	'HorizontalAlignment','left', ...
	'Position',[0.625 0.05698005698005698 0.09765625 0.02849002849002849], ...
   'String','BW: ');

STB_SA = uicontrol(Interface, 'Style', 'text',...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','Arial', ...
	'HorizontalAlignment','left', ...
	'Position',[0.537109375 0.02849002849002849 0.1855 0.02849002849002849], ...
	'String','SA: ');
    %'Position',[0.537109375 0.02849002849002849 0.087890625 0.02849002849002849], ...

STB_StimParam = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'FontSize',10, ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.7422    0.1709    0.2051    0.0285], ...
   'String','Stimulus Parameters:');

STB_nsub_nrep = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.740    0.15    0.205    0.028], ...
	'String','');

STB_Stim_RepDur = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.740    0.128    0.205    0.028], ...
   'String','Stim. Duration:');

STB_ITD_SPL = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.740    0.104    0.205    0.028], ...
   'String','Rep. Duration:');

STB_PlotParam = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'FontSize',10, ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.7421875 0.08547008547008547 0.205078125 0.02849002849002849], ...
   'String','Plot Parameters:');

STB_AnWindow = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.7421875 0.05698005698005698 0.205078125 0.02849002849002849], ...
   'String','Analysiswindow:');

STB_nbin = uicontrol(Interface, 'Style', 'text', ...
   'FontName', 'Arial', ...
	'Units','normalized', ...
   'HorizontalAlignment','left', ...
   'BackgroundColor', [1 1 1], ...
	'Position',[0.7421875 0.02849002849002849 0.205078125 0.02849002849002849], ...
	'String','Number of bins:');

Ax_Cycle1 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.05859375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram1');

Ax_Cycle2 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.21484375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram2');

Ax_Cycle3 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.37109375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram3');

Ax_Cycle4 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.52734375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram4');

Ax_Cycle5 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.68359375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram5');

Ax_Cycle6 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.83984375 0.4558404558404559 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram6');

Ax_Cycle7 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.05859375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
    'Tag','Cyclehistogram7');
   
Ax_Cycle8 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.21484375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram8');

Ax_Cycle9 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.37109375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram9');

Ax_Cycle10 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.52734375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram10');

Ax_Cycle11 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.68359375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram11');

Ax_Cycle12 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.83984375 0.2564102564102564 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram12');

Ax_Cycle13 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.05859375 0.04273504273504274 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram13');

Ax_Cycle14 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.21484375 0.04273504273504274 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram14');

Ax_Cycle15 = axes('Parent',Interface, ...
	'Box','on', ...
	'Position',[0.37109375 0.04273504273504274 0.126953125 0.1566951566951567], ...
    'Visible', 'off', ...
	'Tag','Cyclehistogram15');

WorkSpaceVar = whos;
Hdl = PackStruct(WorkSpaceVar.name);

%-------------------------------------------------------------------------------------
function PlotHists(Hdl, CalcData, Param, StimParam)

%If more than 15 cyclehistograms need to be plotted, than only 15 of them are plotted ...
N = length(CalcData.BinFreq); if (N <= 15), Nrs = 1:N; else Nrs = round(1:N/15:N); end
maxY = 0; %Maximum value on abcissa ...
for i = 1:min([15 N]),
    n = Nrs(i);
    
    eval([ 'set(Hdl.Interface, ''CurrentAxes'', Hdl.Ax_Cycle' int2str(i) ');' ]);
    eval([ 'set(Hdl.Ax_Cycle' int2str(i) ',''Visible'', ''on'');' ]);
    
    %Plotting cyclehistogram ...
    handle = bar(CalcData.X(n, :), CalcData.Y(n, :), 1); set(handle, 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', [0.7 0.7 0.7]);
    if (max(CalcData.Y(n, :)) > maxY), maxY = max(CalcData.Y(n, :)); end
    if any(i == [1,7,13]), ylabel('Rate(spikes/sec)'); 
    else set(gca, 'YTickLabel', []); end
    xlim([0 1]);
    
    %Assembling text for histogram ...
    if (length(StimParam.SPL) > 1),
        txt = {['SPL:' num2str(StimParam.SPL(n)) 'dB']; ...
                ['BF:' num2str(CalcData.BinFreq(n)) 'Hz']; ...
                ['R:' num2str(CalcData.R(n))]; ...
                ['\theta:' num2str(CalcData.WPh(n))]; ...
                ['#Spk:' int2str(CalcData.N(n)) ]};
    else    
        txt = {['BF:' num2str(CalcData.BinFreq(n)) 'Hz']; ...
                ['R:' num2str(CalcData.R(n))]; ...
                ['\theta:' num2str(CalcData.WPh(n))]; ...
                ['#Spk:' int2str(CalcData.N(n)) ]};
    end
    if (CalcData.Z(n) > Param.zcutoffthr),
        txt = {txt{:} ['Ry:' num2str(RayleighSign(CalcData.R(n), CalcData.N(n)))]};
    else txt = {txt{:} ['Ry:NS']}; end
    
    %Placing text in axis ...
    Hdl_Txt(i) = text(0.01,0, txt, 'VerticalAlignment', 'top', 'Interpreter', 'tex', 'FontSize', 8);
end
%Adjusting abcissa limits, so they are the same for all histograms ...
for i = 1:min([15 N])
    if (maxY ~= 0), eval(['set(Hdl.Ax_Cycle' int2str(i) ',''YLim'', [0,' num2str(maxY) ']);']); end
    set(Hdl_Txt(i), 'Position', [0.01, maxY]);
end

%-------------------------------------------------------------------------------------
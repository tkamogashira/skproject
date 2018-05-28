function [ds, iSubSeqs, Param, DSParam, StimParam] = ...
    EvalMove_parseArgs(DefParam, varargin)

%% Check mandatory input arguments, 1 for Madison datasets and 4 for SGSR datasets

NArgs = length(varargin);
if (NArgs < 1)
    error('Wrong number of input arguments.');
end
ds = varargin{1};
if ~isa(ds, 'dataset')
    error('First argument should be dataset.');
end
isSGSRds = strcmpi(ds.fileformat, 'sgsr'); % Are we dealing with an SGSR dataset?
if isSGSRds
    if(NArgs < 4)
        error('Wrong number of input arguments for an SGSR dataset. ');
    else
        ITDbgn     = varargin{2};
        ITDrate    = varargin{3};
        ITDend    = varargin{4};
        if (NArgs >= 5) && isnumeric(varargin{5})
            Pidx = 6;
            iSubSeqs = varargin{5};
        else
            Pidx = 5;
            iSubSeqs = 'all';
        end
    end
else % Madison dataset
    if (NArgs >= 2) && isnumeric(varargin{2})
        %EVALMOVE(ds, iSubSeqs)
        Pidx = 3;
        iSubSeqs = varargin{2};
    else
        %EVALMOVE(ds)
        Pidx = 2;
        iSubSeqs = 'all';
    end
end

%% Retrieving properties and checking their values ...
Param = checkproplist(DefParam, varargin{Pidx:end});
Param = CheckAndTransformParam(Param);

%% Retrieve stimulus parameters from dataset ...
if strcmpi(iSubSeqs, 'all')
    iSubSeqs = (1:ds.nrec)';
elseif strcmpi(Param.subseqinput, 'indepval') && all(ismember(iSubSeqs, ds.indepval(1:ds.nrec)))
    iSubSeqs = find(ismember(ds.indepval, iSubSeqs)); iSubSeqs = iSubSeqs(:);
elseif strcmpi(Param.subseqinput, 'subseq') && all(ismember(iSubSeqs, 1:ds.nrec))
    iSubSeqs = sort(iSubSeqs(:));
else
    error('One or more of the supplied subsequences doesn''t exist or wasn''t recorded.');
end
if isSGSRds
    StimParam = GetStimParam(ds, iSubSeqs, ITDbgn, ITDrate, ITDend);
else
    StimParam = GetStimParam(ds, iSubSeqs);
end

%Calculate ITD range for following calculations ...
if iscell(Param.calcitdrng)
    if strcmpi(Param.pbratecor, 'yes')
        ITDs = [StimParam.itdbgn; StimParam.effitdend];
    else
        ITDs = [StimParam.itdbgn; StimParam.itdend];
    end
    [MinITD, MaxITD] = deal(min(ITDs)+min(StimParam.delayslave), max(ITDs)+max(StimParam.delayslave));
    for n = 1:2
        Param.calcitdrng{n} = evalexpr(Param.calcitdrng{n}, {MinITD, MaxITD});
    end
    Param.calcitdrng = cat(2, Param.calcitdrng{:});
end
if iscell(Param.cmppstanwin)
    if strcmpi(Param.pbratecor, 'yes')
        StimDur = [StimParam.stimdurmaster; StimParam.effstimdurslave; Param.nitdds.burstdur(:)];
    else
        StimDur = [StimParam.stimdurmaster; StimParam.stimdurslave; Param.nitdds.burstdur(:)];
    end
    for n = 1:2
        Param.cmppstanwin{n} = evalexpr(Param.cmppstanwin{n}, {StimDur});
    end
    Param.cmppstanwin = cat(2, Param.cmppstanwin{:});
end

%% Format parameter information ...
if isnan(Param.effsplcf)
    EffSPLCFStr = 'auto';
elseif ischar(Param.effsplcf)
    EffSPLCFStr = lower(Param.effsplcf);
else
    EffSPLCFStr = EvalMove_param2Str(Param.effsplcf, 'Hz', 0);
end

if strcmpi(Param.runavunit, '#')
    RunAvUnit = '';
else
    RunAvUnit = '\mus';
end

if ~isnan(Param.binwidth)
    if strcmpi(Param.binmode, 'itd')
        BWUnit = '\mus';
    else
        BWUnit = 'ms';
    end
    Str = {sprintf('\\itBinWidth(%s):\\rm %s', upper(Param.binmode), EvalMove_param2Str(Param.binwidth, BWUnit, 0))};
else
    Str = {sprintf('\\itNBin:\\rm %s', EvalMove_param2Str(Param.nbin, '', 0))};
end
Str = [Str; {sprintf('\\itPbRateCor:\\rm %s', upper(Param.pbratecor)); ...
    sprintf('\\itRunAv:\\rm %s', EvalMove_param2Str(Param.runav, RunAvUnit, 0)); ...
    sprintf('\\itCalcITDRange:\\rm %s', EvalMove_param2Str(Param.calcitdrng, '\mus', 0))}];
if isequal(StimParam.type, 1)
    Str = [Str; {sprintf('\\itBinWidth(XCorr):\\rm %s', EvalMove_param2Str(Param.corrbinwidth, '\mus', 0))}];
end
if isequal(StimParam.type, 3)
    Str = [Str; {sprintf('\\itNBin(CmpPST):\\rm %s', EvalMove_param2Str(Param.cmppstnbin, '', 0)); ...
        sprintf('\\itAnWin(CmpPST):\\rm %s', EvalMove_param2Str(Param.cmppstanwin, 'ms', 0))}];
end
Str = [Str; {sprintf('\\itCF(EffSPL):\\rm %s', EffSPLCFStr); ...
    sprintf('\\itBW(EffSPL):\\rm %s', EvalMove_param2Str(Param.effsplbw, 'Oct', 2))}];
if ~isvoid(Param.nitdds)
    Str = [Str; {sprintf('\\itNDfunction:\\rm %s <%s>', upper(Param.nitdds.filename), ...
        upper(Param.nitdds.seqid)); ...
        sprintf('\\itAnWin(NDFnc):\\rm %s', EvalMove_param2Str(Param.ndfncanwin, 'ms', 0))}];
end
Param.str = Str;

%Assemble general information ...
DSParam = GetDSParam(ds);

%% GetStimParam
function StimParam = GetStimParam(ds, iSubSeqs, varargin)
%Four different kind of datasets can be analyzed:
% 1)MOV1-datasets: ITD1 and ITD2 are held constant, while ITDrate is changed. This
%   results in a noise delay function over the specified range (ITD1->ITD2) for each
%   movement speed ...
% 2)MOV2-datasets: ITD1 and ITDrate are held constant, while ITD2 is changed. This
%   results in noise delay functions with a different range but with the same speed of
%   movement. These noise delay functions overlap eachother ... (rare)
% 3)MOV3-datasets: ITD1(mostly zero), ITD2 and ITDrate are held constant and DELM, the
%   delay of the master DSS, is changed. The result is a patched noise delay function,
%   with patches of size (ITD2-ITD1) and from the first requested master delay till the
%   last masterdelay plus (ITD2-ITD1) ...
% 4)MOV4-datasets: ITD2 and ITDrate are held constant, while ITD1 is changed. Like
%   MOV2-datasets but now in a different direction ...

%Attention! the dataset ID cannot be used to distinguish a MOV-dataset from other datasets,
%and it is also not possible to use the ID to discern the different classes of MOV-datasets.
%Different MOV-datasets are discerned by the sizes of the different applicable stimulus
%parameters. Another possibility would be to check the name of the varied stimulus parameter ...

fromLeuven = strcmpi(ds.fileformat, 'sgsr');

if strcmpi(ds.fileformat, 'edf') && ~isempty(ds.StimParam.ShiftGWParam)
    % Madison
    ITDbgn     = ds.ShiftGWParam.ITD1;
    ITDend     = ds.ShiftGWParam.ITD2;
    ITDrate    = ds.ShiftGWParam.ITDRate;
    DelaySlave = ds.StimParam.Delay;
elseif fromLeuven % Leuven dataset
    % Eric's program takes Delay (= begin ITD), ITDrate and end ITD as input.
    ITDbgn     = varargin{1};
    ITDrate    = varargin{2};
    DelaySlave = 0; % Not applicable for SGSR datasets
    ITDend = varargin{3};
    StimDur    = abs(ITDend - ITDbgn)/ITDrate * 1e3;
else
    error(['Only EDF datasets with SHFTGW mode recordings or SGSR' ...
        'datasets can contain MOV responses.']);        
end

Nreq = length(iSubSeqs);

% If no paramater is varied, then dataset is assumed being MOV1.
% Hence, the length of ITDrate may also be one ...
if (length(ITDbgn) == 1) && (length(ITDend) == 1) && ...
        (length(ITDrate) >= 1) && (size(DelaySlave, 1) == 1)
    Type       = 1;
    [ITDbgn, ITDend] = deal(repmat(ITDbgn, Nreq, 1), repmat(ITDend, Nreq, 1));
    ITDrate    = ITDrate(iSubSeqs);
    DelaySlave = zeros(Nreq, 1); %Discard information about master delay ...
elseif (length(ITDbgn) == 1) && (length(ITDend) > 1) && ...
        (length(ITDrate) == 1) && (size(DelaySlave, 1) == 1)
    Type       = 2;
    [ITDbgn, ITDrate] = deal(repmat(ITDbgn, Nreq, 1), repmat(ITDrate, Nreq, 1));
    ITDend     = ITDend(iSubSeqs);
    DelaySlave = zeros(Nreq, 1);  %Discard information about master delay ...
elseif (length(ITDbgn) == 1) && (length(ITDend) == 1) && ...
        (length(ITDrate) == 1) && (size(DelaySlave, 1) > 1)
    Type       = 3;
    [ITDbgn, ITDend, ITDrate] = deal(repmat(ITDbgn, Nreq, 1), ...
        repmat(ITDend, Nreq, 1), repmat(ITDrate, Nreq, 1));
    DelaySlave = DelaySlave(iSubSeqs, 2); %Slave DSS always delayed ...
elseif (length(ITDbgn) > 1) && (length(ITDend) == 1) && ...
        (length(ITDrate) == 1) && (size(DelaySlave, 1) == 1)
    Type       = 4;
    ITDbgn     = ITDbgn(iSubSeqs);
    [ITDend, ITDrate] = deal(repmat(ITDend, Nreq, 1), repmat(ITDrate, Nreq, 1));
    DelaySlave = zeros(Nreq, 1);  %Discard information about master delay ...
else
    error('Unknown type of MOV responses');
end

if ~strncmpi(ds.stimtype, 'mov', 3) && ~strncmpi(ds.stimtype, 'wav', 3)
    warning('Unknown dataset stimulus identifier: ''%s''.', ds.stimtype); %#ok
elseif strncmpi(ds.stimtype, 'mov', 3)
    [MovNr, N, Err] = sscanf(lower(ds.exptype), 'mov%d', 1);
    MovNr = abs(MovNr);
    if ~isempty(Err) || ~isequal(MovNr, Type)
        warning('Stimulus identifier is not consistent with stimulus parameters.'); %#ok
    end
end

%Assess movement direction. If for all requested subsequences the start ITD
%is smaller then the end ITD then the movement of the stimulus is
%designated as +1, else if all start ITDs are larger than the end ITDs the
%direction of movement is -1 ...
if all(ITDbgn <= ITDend)
    MoveDir = +1;
elseif all(ITDbgn >= ITDend)
    MoveDir = -1;
else
    MoveDir = NaN;
end

%Attention! The stimulus and repetition duration is not applicable for
%MOV-datasets, the actual duration of the stimulus depends on the requested ITD
%range and on the ITD speed ...

%Repetition number ...
Nrep = ds.nrep;

%Sound pressure level (dB) is always returned as a scalar ... if the SPL administered
%at both ears is different, then the SPLs are combined using the power average ...
%For Leuven datasets the attenuation is used.
if fromLeuven
    SPL = CombineSPLs(ds.atten); 
else
    SPL = CombineSPLs(ds.spl);
end

%Extract sample period of noise token for the master DSS. The playback rate for
%the noise token at the Master DSS is the sample rate of that noise token ...
if fromLeuven
    SamplePeriodMaster = NaN;
    %Noise information
    FileName1 = ds.wavlistname;
    NoiseTokenMaster = sprintf('%s', upper(FileName1));
    NoiseTokenSlave = 'N/A';
else
    SamplePeriodMaster = ds.GWParam.PbPer(1); %in microsecs ...
    %Noise information
    [dummy, dummy, FileName1] = unravelVMSPath(ds.GWParam.FileName{1});
    NoiseTokenMaster = sprintf('%s<%s>', upper(FileName1), upper(ds.GWParam.ID{1}));
    [dummy, dummy, FileName2] = unravelVMSPath(ds.GWParam.FileName{2});
    NoiseTokenSlave = sprintf('%s<%s>', upper(FileName2), upper(ds.GWParam.ID{2}));
end

%Time of recording is important for calculating the effective ITD rate ...
RecTime = ds.time([3,2,1,4:6]);

% If a second event timer was used then the effective stimulus duration can
% be verified ...
UETStimDur = GetUETStimDur(ds, iSubSeqs);

%Format stimulus parameters ...
Str = {sprintf('\\bfMOV%d\\rm', Type)};
switch Type
    case {1, 2, 4}
        Str = [Str; {sprintf('\\itITD_{begin}:\\rm %s', EvalMove_param2Str(ITDbgn, '\mus', 0)); ...
            sprintf('\\itITD_{end}:\\rm %s', EvalMove_param2Str(ITDend, '\mus', 0)); ...
            sprintf('\\itITD_{rate}:\\rm %s', EvalMove_param2Str(ITDrate, '\mus/s', 0))}];
    case 3
        Str = [Str; {sprintf('\\itITD_{begin}:\\rm %s', EvalMove_param2Str(ITDbgn, '\mus', 0)); ...
            sprintf('\\itITD_{end}:\\rm %s', EvalMove_param2Str(ITDend, '\mus', 0)); ...
            sprintf('\\itITD_{rate}:\\rm %s', EvalMove_param2Str(ITDrate, '\mus/s', 0)); ...
            sprintf('\\itDelay_{S}:\\rm %s', EvalMove_param2Str(DelaySlave, '\mus', 0))}];
end

if fromLeuven
     Str = [Str; {sprintf('\\itNoise:\\rm %s/%s', NoiseTokenMaster, NoiseTokenSlave); ...
        sprintf('\\it#Reps:\\rm %s', EvalMove_param2Str(Nrep, '', 0)); ...
        sprintf('\\itAtten:\\rm %s', EvalMove_param2Str(unique(SPL), 'dB', 0))}];
else
    Str = [Str; {sprintf('\\itNoise:\\rm %s/%s', NoiseTokenMaster, NoiseTokenSlave); ...
        sprintf('\\it#Reps:\\rm %s', EvalMove_param2Str(Nrep, '', 0)); ...
        sprintf('\\itSPL:\\rm %s', EvalMove_param2Str(unique(SPL), 'dB', 0))}];
end

StimParam = CollectInStruct(Type, ITDbgn, ITDend, ITDrate, DelaySlave, MoveDir, Nrep, ...
    SPL, SamplePeriodMaster, NoiseTokenMaster, NoiseTokenSlave, RecTime, UETStimDur, Str);
if fromLeuven
    StimParam.StimDur = StimDur;
end

%Calculate effective stimulus parameters ...
StimParam = lowerFields(CalcEffStimParam(StimParam));

%% CheckAndTransformParam
function Param = CheckAndTransformParam(Param)

if ~any(strcmpi(Param.subseqinput, {'subseq', 'indepval'}))
    error('Property subseqinput must be ''subseq'' or ''indepval''.');
end

if ~isa(Param.nitdds, 'dataset')
    error('Invalid value for property nitdds.');
end
Param.ndfncanwin = ExpandAnWin(Param.nitdds, Param.ndfncanwin);
if isempty(Param.ndfncanwin)
    error('Invalid value for property ndfncanwin.');
end
if ~any(strcmpi(Param.pbratecor, {'yes', 'no'}))
    error('Property pbratecor must be ''yes'' or ''no''.');
end
if ~any(strcmpi(Param.binmode, {'itd', 'stmdur'}))
    error('Property binmode must be ''itd'' or ''stmdur''.');
end
if isnan(Param.nbin) && isnan(Param.binwidth)
    error('Properties binwidth and nbin cannot be both NaN.');
elseif ~isnan(Param.nbin) && ~isnan(Param.binwidth)
    error('One of the properties binwidth and nbin must be NaN.');
elseif isnan(Param.nbin) && (~isnumeric(Param.binwidth) || ...
        (length(Param.binwidth) ~= 1) || (Param.binwidth <= 0))
    error('Invalid value for property binwidth.');
elseif isnan(Param.binwidth) && (~isnumeric(Param.nbin) || ...
        (length(Param.nbin) ~= 1) || (Param.binwidth <= 0))
    error('Invalid value for property nbin.');
end

if ~isnumeric(Param.runav) || (length(Param.runav) ~= 1) || (Param.runav < 0)
    error('Property runav must be positive and scalar integer.');
end
if ~any(strcmpi(Param.runavunit, {'#', 'mus'}))
    error('Property runavunit must be ''#'' or ''mus''.');
end
try
    if iscellstr(Param.calcitdrng) && (numel(Param.calcitdrng) == 2)
        for n = 1:2,
            Param.calcitdrng{n} = parseExpr(Param.calcitdrng{n}, {'minitd', 'maxitd'});
        end
    elseif ~isnumeric(Param.calcitdrng) || (numel(Param.calcitdrng) ~= 2) || ...
            ~isinrange(Param.calcitdrng, [-Inf, +Inf])
        error('To catch block ...');
    end
catch
    error(['Property calcitdrng must be two-element numerical vector or ' ...
        'two-element cell-array of strings.']);
end
if ~isnumeric(Param.corrbinwidth) || (numel(Param.corrbinwidth) ~= 1) || ...
        (Param.corrbinwidth <= 0)
    error('Invalid value for property corrbinwidth.');
end
try
    if iscellstr(Param.cmppstanwin) && (numel(Param.cmppstanwin) == 2)
        for n = 1:2,
            Param.cmppstanwin{n} = parseExpr(Param.cmppstanwin{n}, {'stimdur'});
        end
    elseif ~isnumeric(Param.cmppstanwin) || (numel(Param.cmppstanwin) ~= 2) || ...
            ~isinrange(Param.cmppstanwin, [-Inf, +Inf])
        error('To catch block ...');
    end
catch
    error(['Property cmppstanwin must be two-element numerical vector or two-element ', ...
        'cell-array of strings.']);
end
if ~isnumeric(Param.cmppstnbin) || (numel(Param.cmppstnbin) ~= 1) || (Param.cmppstnbin <= 0)
    error('Invalid value for property cmppstnbin.');
end
if ~(isnumeric(Param.effsplcf) && ((Param.effsplcf > 0) || isnan(Param.effsplcf))) && ...
        ~(ischar(Param.effsplcf) && any(strcmpi(Param.effsplcf, {'cf', 'df'})))
    error('Property effsplcf must be positive integer, NaN, ''cf'' or ''df''.');
end
if ~isnumeric(Param.effsplbw) || (length(Param.effsplbw) ~= 1) || (Param.effsplbw <= 0)
    error('Invalid value for property effsplbw.');
end

if ~any(strcmpi(Param.plot, {'yes', 'no'}))
    error('Property plot must be ''yes'' or ''no''.');
end
if ~any(strcmpi(Param.plottype, {'color', 'b&w'}))
    error('Property plottype must be ''color'' or ''b&w''.');
end
if ~any(strcmpi(Param.dbg, {'yes', 'no'}))
    error('Property dbg must be ''yes'' or ''no''.');
end
if ~isinrange(Param.xlim, [-Inf +Inf])
    error('Invalid value for property xlim.');
end
if ~isinrange(Param.ylim, [-Inf +Inf])
    error('Invalid value for property ylim.');
end
if ~isinrange(Param.corrrng, [-Inf +Inf])
    error('Invalid value for property corrrng.');
end
if ~ismember(lower(Param.corrnorm), {'biased', 'unbiased', 'coeff', 'none'})
    error('Invalid value for property corrnorm.');
end

%% GetDSParam
function DSParam = GetDSParam(ds)

DSParam.datafile = upper(ds.filename);
DSParam.cellnr   = ds.icell;
[dummy, DSParam.testnr, DSParam.dsid] = unraveldsID(ds.SeqID);

%Format dataset parameters ...
DSParam.idstr    = sprintf('%s <%d-%d>', DSParam.datafile, DSParam.cellnr, DSParam.testnr);
mfileName = mfilename;
underscore_idx = findstr(upper(mfileName), '_');
mfileName = mfileName(1:underscore_idx);
DSParam.titlestr = {sprintf('\\bfMOVE ITD-curves for %s <%s>\\rm', DSParam.datafile, ds.SeqID); ...
    sprintf('\\fontsize{7}Created by %s @ %s', strtok(mfilename, '_'), datestr(now))};

%% CalcEffStimParam
function StimParam = CalcEffStimParam(StimParam) 
Nrec = size(StimParam.ITDbgn, 1);

isSGSRds = isfield(StimParam,'StimDur');

%Attention! The playback rate of the noise token for the Master DSS is equal to
%the sample rate of the noise token ...
PbPeriodMaster = StimParam.SamplePeriodMaster;

if ~isSGSRds
    [PbPeriodSlave, EffPbPeriodSlave, EffITDrate] = deal(zeros(Nrec, 1));
    idx = find(StimParam.ITDend >= StimParam.ITDbgn);
    if ~isempty(idx),
        %Noise token for Slave DSS is played slower, which gives the perception of the
        %sound moving to the master ...
        PbPeriodSlave(idx)    = PbPeriodMaster.*(1+StimParam.ITDrate(idx)/1e6);
        EffPbPeriodSlave(idx) = GetEffPbPeriod(PbPeriodSlave(idx), -Inf);
        EffITDrate(idx)       = 1e6*((EffPbPeriodSlave(idx)./PbPeriodMaster)-1);
    end
    idx = find(StimParam.ITDend < StimParam.ITDbgn);
    if ~isempty(idx),
        %Noise token for Slave DSS is played faster. The perception of the sound
        %moving to the slave is introduced ...
        PbPeriodSlave(idx)    = PbPeriodMaster.*(1-StimParam.ITDrate(idx)/1e6);
        EffPbPeriodSlave(idx) = GetEffPbPeriod(PbPeriodSlave(idx), StimParam.RecTime);
        EffITDrate(idx)       = 1e6*(1-(EffPbPeriodSlave(idx)./PbPeriodMaster));
    end

    %Number of points actually played by the Master and Slave DSS (always equal) ...
    GWNPoints = round(1e6*(abs(StimParam.ITDend-StimParam.ITDbgn)./StimParam.ITDrate)/PbPeriodMaster);

    %Stimulus duration is different for both DSS's ...
    StimDurMaster   = GWNPoints.*PbPeriodMaster/1e3;   %in millisec ... (= |ITDend-ITDbgn|/ITDrate )
    StimDurSlave    = GWNPoints.*PbPeriodSlave/1e3;    %in millisec ...
    EffStimDurSlave = GWNPoints.*EffPbPeriodSlave/1e3; %in millisec ...

    %Effective ITDend ...
    EffITDend = zeros(Nrec, 1);
    idx = find(StimParam.ITDend >= StimParam.ITDbgn);
    EffITDend(idx) = (EffStimDurSlave(idx)-StimDurMaster(idx))*1e3+StimParam.ITDbgn(idx);
    idx = find(StimParam.ITDend < StimParam.ITDbgn);
    EffITDend(idx) = StimParam.ITDbgn(idx)-(StimDurMaster(idx)-EffStimDurSlave(idx))*1e3;
else % SGSR dataset
    EffITDrate = StimParam.ITDrate;
    PbPeriodSlave = NaN;
    EffPbPeriodSlave = NaN;
    StimDurMaster = StimParam.StimDur;
    StimDurSlave = StimDurMaster;
    EffStimDurSlave = StimDurSlave;
    EffITDend = StimParam.ITDend;
    GWNPoints = NaN;
end

%Assembling debugging information ...
if ~all(isnan(StimParam.UETStimDur))
    DbgStr = [char('ITDbgn ', num2str(StimParam.ITDbgn, '%+.0f ')), ...
        char('ITDrate(Req./Eff.) ', [num2str(StimParam.ITDrate, '%.0f'), num2str(EffITDrate, '/%.2f ')]), ...
        char('ITDend(Req./Eff.) ', [num2str(StimParam.ITDend, '%+.0f'), num2str(EffITDend, '/%+.2f ')]), ...
        char('Duration(#M/Req.#S/Eff.#S/UET) ', [num2str(StimDurMaster, '%.2f'), num2str(StimDurSlave, '/%.2f'), ...
        num2str(EffStimDurSlave, '/%.2f'), num2str(StimParam.UETStimDur, '/%.2f ')]), ...
        char('Delay(#S)', num2str(StimParam.DelaySlave, '%+.0f'))];
else
    DbgStr = [char('ITDbgn ', num2str(StimParam.ITDbgn, '%+.0f ')), ...
        char('ITDrate(Req./Eff.) ', [num2str(StimParam.ITDrate, '%.0f'), num2str(EffITDrate, '/%.2f ')]), ...
        char('ITDend(Req./Eff.) ', [num2str(StimParam.ITDend, '%+.0f'), num2str(EffITDend, '/%+.2f ')]), ...
        char('Duration(#M/Req.#S/Eff.#S) ', [num2str(StimDurMaster, '%.2f'), num2str(StimDurSlave, '/%.2f'), ...
        num2str(EffStimDurSlave, '/%.2f ')]), ...
        char('Delay(#S)', num2str(StimParam.DelaySlave, '%+.0f'))];
end

StimParam = structcat(StimParam, CollectInStruct(PbPeriodMaster, PbPeriodSlave, EffPbPeriodSlave, ...
    EffITDrate, GWNPoints, StimDurMaster, StimDurSlave, EffStimDurSlave, EffITDend, DbgStr));

%% GetEffPbPeriod
function EffPbPeriod = GetEffPbPeriod(ReqPbPeriod, RecTime)

%DSS-II specific information ...
RefDSSNr  = 2^16; %32-bit integer is used to store req. playback rate ...
MaxPbRate = 2^19*10/12; %in Hz ...

%Calculate the 32-bit integer that stores the playback rate of the DSS ...
RefPbPeriod = 1e6/MaxPbRate; %in microsecs ...
DSSNr = fix((RefDSSNr*RefPbPeriod)./ReqPbPeriod); %truncation ...

%If dataset is recorded after August 10, 1998 and ITDend < ITDbgn then calculation
%of effective playback period is different ...
Inc = datenum(RecTime) > datenum(1998, 8, 10);
DSSNr = DSSNr + Inc;

%Find the effective playback period (calculation is performed in maximum
%precision possible) ...
EffPbPeriod = (RefDSSNr*RefPbPeriod)./DSSNr; %in microsecs ...

%% GetUETStimDur
function UETStimDur = GetUETStimDur(ds, iSubSeqs)

NReq = length(iSubSeqs);
NRep = ds.nrep;

if (~strcmpi(ds.fileformat, 'sgsr') && ds.ntimers > 1)
    UETNrs = ds.timernrs;
    Spt    = eval(sprintf('ds.spt%d(%s, :)', UETNrs(2), mat2str(iSubSeqs)));
    NSpk   = sum(cellfun('prodofsize', Spt(:)));

    if any(cellfun('isempty', Spt))
        UETStimDur = repmat(NaN, NReq, 1);
        return;
    end

    if isequal(NSpk, NReq*NRep) %Only offset timing ...
        Spt = reshape(cat(1, Spt{:}), NReq, NRep);
        UETStimDur = reshape(mean(Spt, 2), NReq, 1);
    elseif isequal(NSpk, 2*NReq*NRep) %Onset and offset timing ...
        Spt = reshape(cat(1, Spt{:}), NReq, 2*NRep);
        OnSet = Spt(:, 1:2:end); OffSet = Spt(:, 2:2:end);
        UETStimDur = reshape(mean(OffSet-OnSet, 2), NReq, 1);
    else
        UETStimDur = repmat(NaN, NReq, 1);
    end
else
    UETStimDur = repmat(NaN, NReq, 1);
end
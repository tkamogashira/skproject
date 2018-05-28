function CalcData = EvalMove_calcCurve(ds, iSubSeqs, StimParam, Param)

%Assembling parameters needed in calculation ...
Nreq = length(iSubSeqs);
ITDbgn     = StimParam.itdbgn;
DelaySlave = StimParam.delayslave;

if strcmpi(Param.pbratecor, 'yes')
    ITDend     = StimParam.effitdend;
    StimDur    = StimParam.effstimdurslave;
else
    ITDend     = StimParam.itdend;
    StimDur    = StimParam.stimdurslave;
end

%Calculate PST histograms ...
AnWin    = [zeros(Nreq, 1), StimDur(:)]; %in millisec ...
AnDur    = abs(diff(AnWin, 1, 2));       %in millisec ...
ITDRange = abs(ITDend-ITDbgn);           %in microsec ...
if ~isnan(Param.binwidth)
    if strcmpi(Param.binmode, 'itd')
        NBin = floor(ITDRange./Param.binwidth);
    else
        NBin = floor(AnDur./Param.binwidth);
    end
else
    NBin = repmat(Param.nbin, Nreq, 1);
end
if strcmpi(Param.runavunit, 'mus')
    RunAvN = round((NBin./ITDRange)*Param.runav);
else
    RunAvN = repmat(Param.runav, Nreq, 1);
end
Hist = struct('BC', num2cell(repmat(NaN, Nreq, 1)), 'N', num2cell(repmat(NaN, Nreq, 1)), ...
    'Rate', num2cell(repmat(NaN, Nreq, 1)), 'MaxN', num2cell(repmat(NaN, Nreq, 1)), ...
    'MaxRate', num2cell(repmat(NaN, Nreq, 1)), 'BCAtMax', num2cell(repmat(NaN, Nreq, 1)), ...
    'MinN', num2cell(repmat(NaN, Nreq, 1)), 'MinRate', num2cell(repmat(NaN, Nreq, 1)), ...
    'BCAtMin', num2cell(repmat(NaN, Nreq, 1)), 'ModDepth', num2cell(repmat(NaN, Nreq, 1)));

if isequal(1, StimParam.type)
    % convert Param.dynanwin to Nreq*2 numeric matrix
    if ischar(Param.dynanwin)
        if isequal( 'stimdur', lower(Param.dynanwin) ) ...
                || isequal( '$stimdur$', lower(Param.dynanwin) )
            Param.dynanwin = repmat({0, 'stimdur'}, Nreq, 1);
        end
    end
    if isequal(1, size(Param.dynanwin, 1))
        Param.dynanwin = repmat(Param.dynanwin, Nreq, 1);
    end
    if ~isequal([Nreq 2], size(Param.dynanwin))
        error('Parameter dynanwin is in wrong format!');
    end

    if iscell( Param.dynanwin )
        newDynAnWin = zeros(Nreq, 2);
        for cRow = 1:Nreq
            for cCol = 1:2
                if ischar(Param.dynanwin{cRow, cCol})
                    Param.dynanwin{cRow, cCol} = strrep(lower(Param.dynanwin{cRow, cCol}), ...
                        '$stimdur$', num2str(StimDur(cRow)));
                    Param.dynanwin{cRow, cCol} = strrep(lower(Param.dynanwin{cRow, cCol}), ...
                        'stimdur', num2str(StimDur(cRow)));
                    Param.dynanwin{cRow, cCol} = eval(Param.dynanwin{cRow, cCol});
                elseif ~isnumeric(Param.dynanwin{cRow, cCol}) || isnan(Param.dynanwin{cRow, cCol})
                    error('Parameter dynanwin is in wrong format!');
                end
                newDynAnWin(cRow, cCol) = Param.dynanwin{cRow, cCol};
            end
        end
        Param.dynanwin = newDynAnWin;
    end

    if ~isnumeric( Param.dynanwin )
        error('Parameter dynanwin is in wrong format!');
    end

    beginProportion = Param.dynanwin(:, 1) ./ StimDur;
    endProportion = Param.dynanwin(:, 2) ./ StimDur;
    ITDAnBgn = ITDbgn + beginProportion .* (ITDend - ITDbgn);
    ITDAnEnd = ITDbgn + endProportion .* (ITDend - ITDbgn);
end

for n = 1:Nreq
    %Checking for zero number of bins also makes sure that a zero ITD range is
    %checked for, because a zero ITD range always results in zero number of bins ...
    if ~isequal(NBin(n), 0)
        Data = CalcPSTH(ds.spt(iSubSeqs(n), :), 'isubseqs', 'all', 'ireps', ...
            'all', 'anwin', AnWin(n, :), 'nbin', NBin(n));
        BinWidth = ITDRange(n)/NBin(n);
        if (ITDend(n) >= ITDbgn(n))
            Hist(n).BC   = (DelaySlave(n)+ITDbgn(n)+BinWidth/2):BinWidth:(DelaySlave(n)+ITDend(n)-BinWidth/2);
            Hist(n).N    = runav(Data.hist.n, RunAvN(n));
            Hist(n).Rate = runav(Data.hist.rate, RunAvN(n));
        else
            Hist(n).BC   = (DelaySlave(n)+ITDend(n)+BinWidth/2):BinWidth:(DelaySlave(n)+ITDbgn(n)-BinWidth/2);
            Hist(n).N    = runav(fliplr(Data.hist.n), RunAvN(n));
            Hist(n).Rate = runav(fliplr(Data.hist.rate), RunAvN(n));
        end

        if isequal(1, StimParam.type)
            % limit to dynanwin
            if (ITDend(n) >= ITDbgn(n))
                idx = find( Hist(n).BC >= ITDAnBgn(n) & Hist(n).BC <= ITDAnEnd(n));
            else
                idx = find( Hist(n).BC <= ITDAnBgn(n) & Hist(n).BC >= ITDAnEnd(n));
            end
            Hist(n).BC = Hist(n).BC(idx);
            Hist(n).N = Hist(n).N(idx);
            Hist(n).Rate = Hist(n).Rate(idx);
        end

        [Hist(n).BCAtMax, Hist(n).MaxN] = getmaxloc(Hist(n).BC, Hist(n).N, 0, Param.calcitdrng);
        [dummy, Hist(n).MaxRate] = getmaxloc(Hist(n).BC, Hist(n).Rate, 0, Param.calcitdrng);
        [Hist(n).BCAtMin, Hist(n).MinN] = getmaxloc(Hist(n).BC, -Hist(n).N, 0, Param.calcitdrng);
        [dummy, Hist(n).MinRate] = getmaxloc(Hist(n).BC, -Hist(n).Rate, 0, Param.calcitdrng);
        [Hist(n).MinN, Hist(n).MinRate] = deal(-Hist(n).MinN, -Hist(n).MinRate);
        if (Hist(n).MaxN ~= 0)
            Hist(n).ModDepth = (Hist(n).MaxN-Hist(n).MinN)/Hist(n).MaxN;
        end
    end
end
Hist = lowerFields(Hist);

%If ND-function is supplied ...
if ~isvoid(Param.nitdds)
    NDFnc = CalcNDFnc(Param.nitdds, Param);
else
    NDFnc = struct([]);
end

%Calculate specific metrics and assemble metrics information ...
Str = cell(0);
if isequal(StimParam.type, 1) && ~isvoid(Param.nitdds)
    [MOV1, Str] = CalcMOV1(NDFnc, Hist, StimParam, Param, Str);
else
    MOV1 = struct([]);
end
if (StimParam.type == 3)
    [MOV3, Str] = CalcMOV3(ds, iSubSeqs, Hist, Param, Str);
else
    MOV3 = struct([]);
end

CalcData = lowerFields(CollectInStruct(Hist, NDFnc, MOV1, MOV3, Str));

%% CalcNDFnc
function NDFnc = CalcNDFnc(dsntd, Param)

%Calculate noise delay function ...
Nrec = dsntd.nrec;
Nrep = dsntd.nrep;
iSubSeqs = 1:Nrec;
[ITD, idx] = sort(dsntd.indepval(iSubSeqs));
iSubSeqs = iSubSeqs(idx);
Spt = ApplyAnWin(dsntd.spt(iSubSeqs, :), Param.ndfncanwin);
WinDur = GetAnWinDur(Param.ndfncanwin);
N    = sum(cellfun('length', Spt), 2);
Rate = 1e3*N/WinDur/Nrep;
[ITDAtMax, MaxN] = getmaxloc(ITD, N, 0, Param.calcitdrng);
[dummy, MaxRate] = getmaxloc(ITD, Rate, 0, Param.calcitdrng);

%Assemble structure ...
NDFnc = lowerFields(CollectInStruct(ITD, N, Rate, MaxN, MaxRate, ITDAtMax));

%% CalcMOV1
function [MOV1, Str] = CalcMOV1(NDFnc, Hist, StimParam, Param, Str)

Nsamples = ceil(abs(diff(Param.calcitdrng))/Param.corrbinwidth);
ITDs = linspace(Param.calcitdrng(1), Param.calcitdrng(2), Nsamples);

%Calculate correlogram between static noise delay function and every
%dynamic PST ...
Lags = (-(Nsamples-1):+(Nsamples-1))*Param.corrbinwidth;
Ncorrs = length(Hist);
Corr = repmat(NaN, Ncorrs, 2*Nsamples-1); %Pre-allocation ...
[LagAtMax, Max] = deal(repmat(NaN, Ncorrs, 1));
for n = 1:Ncorrs
    if and(~isnan(Hist(n).bc), ~isnan(Hist(n).n))
        % first interpolate
        RefFnc = interp1(NDFnc.itd, NDFnc.n, ITDs);
        HistFnc = interp1(Hist(n).bc, Hist(n).n, ITDs);

        % then limit to common ITD's, and detrend
        MinITD = max([min(NDFnc.itd), min(Hist(n).bc)]);
        MaxITD = min([max(NDFnc.itd), max(Hist(n).bc)]);
        CommonITDsIdx = find(ITDs >= MinITD & ITDs <= MaxITD);

        RefFncLtd = detrend(RefFnc(CommonITDsIdx));
        HistFncLtd = detrend(HistFnc(CommonITDsIdx));

        % now correlate, and put in Corr array
        [LocalCorr, LocalLags] = xcorr(RefFncLtd, HistFncLtd, Param.corrnorm);
        LocalLags = LocalLags * Param.corrbinwidth;
        StartLagIdx = find(LocalLags(1) == Lags);

        if isequal(1, StimParam.movedir)
            LocalCorr = fliplr(LocalCorr);
        end

        Corr(n, StartLagIdx:(StartLagIdx+length(LocalLags)-1)) = LocalCorr;
        [LagAtMax(n), Max(n)] = getmaxloc(Lags, Corr(n, :));
    end
end

%Linear regression on ITDrate versus lag at maximum correlation ...
if strcmpi(Param.pbratecor, 'yes')
    ITDrate = StimParam.effitdrate;
else
    ITDrate = StimParam.itdrate;
end

% convert lags at max to absolute times
ITDBegin = StimParam.itdbgn;
if strcmpi(Param.pbratecor, 'yes')
    ITDEnd = StimParam.effitdend;
    StimDur = StimParam.effstimdurslave;
else
    ITDEnd = StimParam.itdend;
    StimDur = StimParam.stimdurslave;
end
ITDDur = abs( ITDEnd - ITDBegin );

corrLagAtMaxRatio = LagAtMax ./ ITDDur;
StimLagAtMax = corrLagAtMaxRatio .* StimDur;

if (length(ITDrate) > 1)
    [Y, idx] = deNaN(LagAtMax);
    X = ITDrate(idx);
    P = polyfit(X, Y, 1);
    [Slope, Yintercept] = deal(P(1), P(2));
    Str = [Str; {sprintf('\\itSlope:\\rm %s \\itYintercept:\\rm %s', ...
        EvalMove_param2Str(Slope * 1000, 'ms', 1) , ...
        EvalMove_param2Str(Yintercept, 'ms', 2))}];
else
    [Slope, Yintercept] = deal(NaN);
end

%Assemble structure ...
MOV1 = struct('lags', Lags, 'corr', Corr, 'corrmax', Max, 'corrlagatmax', LagAtMax, ...
    'stimcorrlagatmax', StimLagAtMax, ...
    'itdrate', ITDrate, 'latency', Slope, 'ycpt', Yintercept);

%% CalcMOV3
function [MOV3, Str] = CalcMOV3(ds, iSubSeqs, Hist, Param, Str)

%Calculate DSSI ...
[DSSI, Segments] = CalcDSSI(Hist, Param.calcitdrng);
Str = [Str; {sprintf('\\itDSSI:\\rm %s', EvalMove_param2Str(DSSI, '', 2))}];

%Calculate pooled histograms for dynamic and static ITDs. First average
%dynamic PSTHs ...
Nreq = length(iSubSeqs); boolean = zeros(Nreq, 1);
for n = 1:Nreq
    boolean(n) = all((Hist(n).bc >= Param.calcitdrng(1)) & (Hist(n).bc <= Param.calcitdrng(2)));
end
iSubSeqs = iSubSeqs(boolean);
PST = CalcPSTH(ds, 'isubseqs', iSubSeqs, 'nbin', Param.cmppstnbin, 'anwin', ...
    Param.cmppstanwin, 'poolsubseqs', 'yes');
BC      = PST.hist.bincenters(:);
DynN    = PST.hist.n(:);
DynRate = PST.hist.rate(:);

%Average static PSTHs ...
if ~isvoid(Param.nitdds)
    iSubSeqs = find((Param.nitdds.indepval >= Param.calcitdrng(1)) & ...
        (Param.nitdds.indepval <= Param.calcitdrng(2)));
    PST = CalcPSTH(Param.nitdds, 'iSubSeqs', iSubSeqs, 'nbin', ...
        Param.cmppstnbin, 'anwin', Param.cmppstanwin, 'poolsubseqs', 'yes');
    [StatN, StatRate] = deal(PST.hist.n(:), PST.hist.rate(:));
else
    [StatN, StatRate] = deal(repmat(NaN, Param.cmppstnbin, 1));
end

%Assemble structure ...
MOV3 = struct('dssi', DSSI, 'segments', Segments, 'bc', BC, 'dynn', ...
    DynN, 'dynrate', DynRate, 'statn', StatN, 'statrate', StatRate);

%% CalcDSSI
function [DSSI, Segments] = CalcDSSI(Hist, ITDRng)

%From "Responses of Inferior Colliculus Neurons to Time-Varying Interaural Phase Disparity:
%Effects of Shifting the Locus of Virtual Motion", M.W. Spitzer and M. N. Semple, JOURNAL OF
%NEUROPHYSIOLOGY, Vol. 69, No. 4 (April 1993)

NOverlap = length(Hist)-1;
Segments = [];
[MaxArea, OverLapArea] = deal(zeros(1, NOverlap)); % preallocating memory
for n = 1:NOverlap
    [X, Y, Xn, Yn, Xroots] = deal([]);

    [BC1, BC2]     = deal(Hist([n, n+1]).bc);
    [Rate1, Rate2] = deal(Hist([n, n+1]).rate);

    if isempty(BC1) || isempty(BC2)
        Xoverlap = zeros(1,0);
    else
        Xoverlap = union(BC1(BC1 > min(BC2)), BC2(BC2 < max(BC1)));
    end
    if ~isempty(Xoverlap)
        Xrng = [min(Xoverlap), max(Xoverlap)];
    else
        Xrng = [NaN, NaN];
    end
    X = union( Xoverlap((Xoverlap >= ITDRng(1)) & (Xoverlap <= ITDRng(2))), ...
        ITDRng((ITDRng >= Xrng(1)) & (ITDRng <= Xrng(2))) );
    if ~isempty(X)
        Y(1, :) = interp1(BC1, Rate1, X); Y(2, :) = interp1(BC2, Rate2, X);

        %When crossings are present, subdivide ...
        idx = find(diff(sign(diff(Y, 1, 1))) ~= 0);
        if ~isempty(idx)
            NSubAreas = length(idx)+1;
            for i = 1:(NSubAreas-1)
                Tidx = idx(i)+[0,1];
                Xroots(i) = roots(polyfit(X(Tidx), Y(1, Tidx), 1)-polyfit(X(Tidx), Y(2, Tidx), 1));
            end
            Xn = union(X, Xroots);
            Yn(1, :) = interp1(X, Y(1, :), Xn);
            Yn(2, :) = interp1(X, Y(2, :), Xn);
            [X, Y] = deal(Xn, Yn);
        end

        %The first row in Y always contains the highest line ...
        idx = find(Y(1, :) < Y(2, :));
        [Y(1, idx), Y(2, idx)] = swap(Y(1, idx), Y(2, idx));

        Segments(end+1).X = repmat(X([1, 1:end, end]), 2, 1);
        Segments(end).Y   = [zeros(2, 1), Y, zeros(2, 1)];

        Area = trapz(X, Y, 2);
        MaxArea(n) = max(Area); OverLapArea(n) = abs(diff(Area));
    else
        [MaxArea(n), OverLapArea(n)] = deal(0);
    end
end
if (NOverlap == 0)
    DSSI = NaN;
elseif ~all(MaxArea == 0)
    DSSI = sum(OverLapArea)/sum(MaxArea);
else
    DSSI = NaN;
end

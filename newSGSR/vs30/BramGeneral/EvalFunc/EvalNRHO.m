function D = EvalNRHO(ds,varargin)
% EvalNRHO  Use all pairs of stimulus tokens to calculate a
% correlation function for monaural data
%
%   D = EvalNRHO(DS) calculate the correlation function from
%   the dataset DS and return in struct D. Use default parameters.
%
%   D = EvalNRHO(DS,params) use parameters specified in params as a
%   string-value sequence, the defaults are: 
%       corbinwidth : 0.05;                in ms
%       anwin       : [0 ds.burstdur];     in ms
%       plot        : 'yes'                yes/no
%       rising      : 'yes'                no changes the fit function

% Procedure for monaural datasets:
% 1) Finds all possible unique PAIRS of noise tokens (subsequences).
% 2) Uses sptcorr to calculate the number of coincidences at zero delay (RATE)
%    for all reps of each PAIR.
% 3) Calculates the stimulus correlation value (RHO) of each PAIR.
% 4) Finds unique RHO values and calculates the average RATE at that RHO.

% MMCL 18/09/2009
% RdN 2010

%% main program

% params
defaultParams.corbinwidth  = .05;
defaultParams.anwin        = [0 ds.burstdur];
defaultParams.plot         = 'yes';
defaultParams.rising       = 'yes';

params = processParams(varargin, defaultParams);
params.windur = getWindur(params);

if strcmpi(params.plot, 'yes')
    params.plot = true;
else
    params.plot = false;
end
if strcmpi(params.rising, 'yes')
    params.rising = true;
else
    params.rising = false;
end

% are we dealing with binaural data?
if isequal(ds.activechan, 0)
    D = binauralEvalNHRO(ds, params);
else
    D = monauralEvalNHRO(ds, params);
end


%% windur
function windur = getWindur(params)
windur = abs(diff(params.anwin));

%% Binaural eval
function D = binauralEvalNHRO(ds, params)

% get spike rate
spikeRate = CalcRATE(ds, 'anwin', params.anwin);

rho = spikeRate.curve.indepval;
R = spikeRate.curve.rate;

powerfunction = getPowerfunction(params.rising);

% Power Method
p = [0 1 1];
RPowers = lsqcurvefit(powerfunction, p, rho, R,[0 0 0],[200000 200000 1000]);

D.R = R;
D.rho = rho;
D.fit.RPowers = RPowers;

if params.plot
    if params.rising
        sign = '+';
    else
        sign = '-';
    end
    RString = sprintf('R \\approx %0.1f+%0.1f*((1%s\\rho)/2)^{%0.1f}', ...
        RPowers(1), RPowers(2), sign, RPowers(3));
    RFit = powerfunction(RPowers, rho);
    
    GridPlot({[rho; rho]}, {[R; RFit]}, ds, ...
        'subsequences', false, ...
        'plotparams', {'LineStyle' '-', 'Marker', 'none'}, ...
        'xlabel', 'Interaural correlation', 'ylabel', 'Spike Rate (spk/sec)', ...
        'mfilename', mfilename, 'PlotString', RString);
end

%% Monaural eval
function D = monauralEvalNHRO(ds, params)

% get spike trains
spt = ds.spt;
spt = anwin(spt,params.anwin);

% calculate all possible pairs
nseqs = size(spt,1);
pairs  = nchoosek(1:nseqs,2);
doubles = [(1:nseqs)' (1:nseqs)'];
pairs = [doubles;pairs]; % include autocor
sizepairs = size(pairs);
lpairs = sizepairs(1);

% mashed datatset?
if isfield(ds.ID,'mashed')
    mashed = ds.ID.mashed;
else
    mashed = 0;
end

% calculate rates of pairs
allR = zeros(1, lpairs);
allRn = zeros(1, lpairs);
for n = 1:nseqs
    spt1 = spt(pairs(n,1),:);
    [allR(n) X NC] = SPTCORR(spt1, 'nodiag', 0, params.corbinwidth, ...
        params.windur, '', mashed);
    allRn(n) = allR(n)/NC.DriesNorm;
    allR(n) = allR(n) / (NC.dur/1000 * NC.Nrep1);
end

for n = nseqs+1:lpairs
    spt1 = spt(pairs(n,1),:);
    spt2 = spt(pairs(n,2),:);
    [allR(n) X NC] = SPTCORR(spt1, spt2, 0, params.corbinwidth, params.windur, ...
        '', mashed);
    allRn(n) = allR(n)/NC.DriesNorm;
    % watch out, we divide by the duration _in seconds_ while NC.dur is in ms
    allR(n) = allR(n) / (NC.dur/1000 * NC.Nrep1);
end

% calculate correlation values of pairs
ph = acos(ds.xval);                               %   Convert to phase angle
pairs_ph = ph(pairs);                             %   APP of phase angles
pairs_dph = pairs_ph(:,1) - pairs_ph(:,2);        %   All available phase differences
allrho = cos(pairs_dph);                          %   Convert back to rho-measure
rho = unique(allrho);

% get mean rate for each correlation value
R = zeros(size(rho));
Rn = zeros(size(rho));
for n = 1:length(rho)
    ind = find(rho(n) == allrho);
    R(n) = mean(allR(ind));
    Rn(n) = mean(allRn(ind));
end

powerfunction = getPowerfunction(params.rising);

% Power Method
p = [0 1 1];
RPowers = lsqcurvefit(powerfunction, p, rho, R ,[0 0 0],[200000 200000 1000]);
RnPowers = lsqcurvefit(powerfunction, p, rho, Rn ,[0 0 0],[200000 200000 1000]);

% get spike rate
spikeRate = CalcRATE(ds, 'anwin', params.anwin);

% collect return arguments in struct
D.R = R;
D.Rn = Rn;
D.rho = rho;
D.fit.RPowers = RPowers;
D.fit.RnPowers = RnPowers;

if params.plot
    if params.rising
        sign = '+';
    else
        sign = '-';
    end
    RString = sprintf('R \\approx %0.1f+%0.1f*((1%s\\rho)/2)^{%0.1f}', ...
        RPowers(1), RPowers(2), sign, RPowers(3));
    RnString = sprintf('Rn \\approx %0.1f+%0.1f*((1%s\\rho)/2)^{%0.1f}', ...
        RnPowers(1), RnPowers(2), sign, RnPowers(3));
    RFit = powerfunction(RPowers, rho);
    RnFit = powerfunction(RnPowers, rho);


    GridPlot({spikeRate.curve.indepval; [rho'; rho']; [rho'; rho']}, ...
        {spikeRate.curve.rate; [R'; RFit']; [Rn'; RnFit']}, ds, ...
        'subsequences', false, ...
        'plotparams', {'LineStyle' '-', 'Marker', 'none'}, ...
        'xlabel', repmat({'Interaural correlation'}, 1, 3), ...
        'ylabel', ...
        {'Spike Rate (spk/sec)', '#coincidences/sec' 'Normalized #coincidences'}, ...
        'mfilename', mfilename, 'PlotString', {'', RString, RnString});
end

%% getPowerfunction
function powerfunction = getPowerfunction(rising)
if rising
    powerfunction = @powerfunctionRising;
else
    powerfunction = @powerfunctionFalling;
end

%% powerfunctions
function y = powerfunctionRising(p,x)

y = p(1)+p(2)*((1+x)./2).^p(3);
y = real(y);

function y = powerfunctionFalling(p,x)

y = p(1)+p(2)*((1-x)./2).^p(3);
y = real(y);

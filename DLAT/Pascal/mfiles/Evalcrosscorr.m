function S = Evalcrosscorr(varargin)

% EVALcrosscorr calculate the cross correlogram
%   EVALcrosscorr(ds1,subseq1,ds2,subseq2) calculates the correlogram between
%   subseq1 of ds1 and subseq2 of ds2.
%
%   ds1 = dataset('D0121C',-38)
%   S = Evalcrosscorr(ds1,5,ds1,6,'anwin',10000)

%--------------------------- Default Parameters -----------------------
DefParam.anwin         = [0 +Inf];   %in ms (Infinite designates stimulus duration) 
DefParam.corbinwidth   = 0.05;       %in ms ...
DefParam.cormaxlag     = 10;         %in ms ...   
DefParam.plot          = 'yes';      %make plot ('no')

%-------------------------------- Main --------------------------------

% Check input arguments and parameters 
[ds,subseq,Param,ndatasets] = CheckInput(DefParam, varargin{:});

% get subseq spike trains from datasets
for n = 1:ndatasets
    SptX = getspt(ds(n),subseq(n));
    SPLX = findspl(ds(n),subseq(n));
    eval(['Spt' num2str(n) ' = SptX;']);
    eval(['SPL' num2str(n) ' = SPLX;']);
end

% calculate shuffeled correlogram: ds1-subseq1 with ds1-subseq1
S = calcSC(Spt1,Param);
S.SPL = [SPL1 SPL1];

% calculate cross correlograms: ds1-subseq1 with ds2-subseq2, ds1-subseq1 with ds3-subseq3, ...
for n = 2:ndatasets
    eval(['SptX = Spt' num2str(n) ';']);
    eval(['SPLX = SPL' num2str(n) ';']);
    C = calcXC(Spt1,SptX,Param);
    C.SPL = [SPL1 SPLX];
    S = [S C];
end

% plot correlograms
if ~isempty(strmatch(Param.plot,'yes'))
    figure; hold on
    for n = 1:ndatasets
        cor = S(n).cor;
        lag = S(n).lag;
        plot(lag,cor,lcolor(n))
    end
end
%------------------------------- Locals -------------------------------
function [ds,subseq,Param,ndatasets] = CheckInput(DefParam, varargin);

% set parameters to their default values
Param = DefParam;
Param
% count and define the datasets 
numargs = length(varargin);
ndatasets = 0;
for n = 1:numargs
    if isobject(varargin{n}) % a dataset 
        ndatasets = ndatasets+1;
        ds(ndatasets) = varargin{n};
        subseq(ndatasets) = varargin{n+1};
    end
end

% get parameter values from datasets
for n = 1:ndatasets
    burstdur(n) = ds(n).burstdur;
end
Param.anwin(2) = min(burstdur); % set analysis window to minimum burst duration

% update any parameters given as inputs
for n = 1:numargs
    if ischar(varargin{n}) % might be a parameter ...
        if isfield(Param,varargin{n}) % ... if so the updata parameters
            Param = setfield(Param,varargin{n},varargin{n+1});
        end
    end
end
   Param  

%----------------------------------------------------------------------
function Spt = getspt(ds,subseq)

AllSpikes = ds.Data.SpikeTimes;
Spt = AllSpikes(subseq,:);

%----------------------------------------------------------------------
function SPL = findspl(ds,subseq)

AllSPL = getspl(ds);
SPL = AllSPL(subseq);

%----------------------------------------------------------------------
function C = calcSC(Spt,Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
Spt = anwin(Spt, Param.anwin);

[Ysac, T, NC] = SPTCORR(Spt, 'nodiag', Param.cormaxlag, Param.corbinwidth, WinDur); 
Ysac = ApplyNorm(Ysac, NC, 'rate');

C.lag = T;
C.cor = Ysac;

%----------------------------------------------------------------------
function C = calcXC(Spt1,Spt2,Param)

WinDur = abs(diff(Param.anwin)); %Duration of analysis window in ms ...
Spt1 = anwin(Spt1, Param.anwin);
Spt2 = anwin(Spt2, Param.anwin);

[Yxac, T, NC] = SPTCORR(Spt1, Spt2, Param.cormaxlag, Param.corbinwidth, WinDur); 
Yxac = ApplyNorm(Yxac, NC, 'rate');

C.lag = T;
C.cor = Yxac;

%----------------------------------------------------------------------
function Y = ApplyNorm(Y, N, NormStr)

if (nargin == 2), NormStr = 'dries'; end

switch lower(NormStr),
case 'dries',
    if ~all(Y == 0), Y = Y/N.DriesNorm;
    else, Y = ones(size(Y)); end
case 'rate',
    Y = 1e3*Y/N.NF;
end

%----------------------------------------------------------------------
function c = lcolor(n)

co = {'b','g','r','c','m','y','k'};
c = co{n};
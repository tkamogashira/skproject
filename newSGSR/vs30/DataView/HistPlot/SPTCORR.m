function [x, BC, NC, x2, BC2, NC2] = SPTCORR(spt1, spt2, maxlag, binwidth, ...
    dur, normStr, isMashed)
% SPTCORR - spike time correlogram
%    H = SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH), where SPT1 and SPT2 are vectors
%    containing spiketimes, returns the histogram of the spike-time differences 
%    between the spike pairs from SPT1 and SPT2. The histogram is restricted
%    to intervals DT between -maxlag and maxlag. BINWIDTH is the bin width
%    of the histogram. All arguments must be specified in the same time unit,
%    e.g. ms. The middle bin is centered around zero lag.
%
%    The convention of time order matches that of XCORR: if
%    t1 and t2 are spike times from SPT1 and SPT2, respectively, then t1>t2 
%    will count as a positive interval.
%
%    [H, BC] = SPTCORR(...) also returns the position of the bin centers in H.
%
%    If SPT1 and SPT2 are cell arrays, the elements of these arrays are considered
%    as "repetitions." Spike times from the different cells are merged prior to
%    to the computation: SPTCORR(SPT1,SPT2, ...) = SPTCORR([SPT1{:}],SPT2[SPT1{:}], ...).
%
%    If SPT is a cell array containing spike time vectors, then 
%    SPTCORR(SPT, 'nodiag', ...) returns the autocorrelation with the
%    diagonal terms removed, i.e., the histogram is compiled only across
%    different repetitions. Note: an autocorrelogram without this correction
%    is obtained by SPTCORR(SPT, SPT, ...).
%
%    [H, BC, N] = = SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH, DUR) returns a struct N 
%    containing various named normalization constants. DUR is the duration of
%    the analysis window; DUR does not affect the unnormalized correlogram itself,
%    but is needed to compute the normalization constants.
%
%    SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH, DUR, NS) directly applies the 
%    normalization specified in NS, where NS is one of the fieldnames
%    of the struct N mentioned above. The case of the names must match.
%
%    SPTCORR(SPT1, SPT2, MAXLAG, BINWIDTH, DUR, NS, isMashed) is used to
%    indicate whether the spiketrains are mashed. When the original
%    spiketrains are mashed, correctMashed is applied. A correlogram is
%    then calculated between the first vector resulting from spt1 and the
%    first from spt2 and a second correlogram is given for the second
%    vector of spt1 and the second one of stp2.
%    The output arguments x2, BC2 and NC2 contain the results of this
%    second correlation.
%
%    See also ANWIN, XCORR, correctMashed

%Marcel van der Heijden 20-08-2004, adjusted by Bram Van de Sande

if nargin<5, dur = NaN; end
if nargin<6, normStr = ''; end
if nargin<7, isMashed = false; end

x2 = [];
BC2 = [];
NC2 = struct;

%% special recursive cases
% only executed when spt1 and/or spt2 is a cell array
if iscell(spt1) && iscell(spt2)
   % grand correlogram: merge all spikes of each set
   [x, BC, NC, x2, BC2, NC2] = SPTCORR([spt1{:}], [spt2{:}], maxlag, ...
       binwidth, dur, '', isMashed);
   Nrep1 = length(spt1);
   Nrep2 = length(spt2);
   % evaluate normalization and apply if requested
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   if isMashed
       NC2 = localNormCoeff(NC2.Nspike1, NC2.Nspike2, binwidth, dur, Nrep1, Nrep2);
       x2 = localApplyNorm(x2, NC2, normStr);
   end
   return;
elseif iscell(spt1)
   try
       gEr = ~isequal('nodiag', lower(spt2));
   catch
       gEr = 1; % pessimistic default
   end
   if gEr
       error([ 'If SPT1 is a cell array, SPT2 must be either a cell' ...
           'array or the string "nodiag".' ]);
   end
   % non-diagonal autocorr; apply no normalization yet
   [x, BC, NC, x2, BC2, NC2] = SPTCORR([spt1{:}], [spt1{:}], maxlag, ...
       binwidth, dur, '', isMashed);
   Nrep1 = length(spt1);
   Nrep2 = nan;
   for irep=1:length(spt1) % subtract diagonal terms
      [xd, dummy, dummy, x2d] = SPTCORR(spt1{irep}, spt1{irep}, maxlag, ...
          binwidth, dur, '', isMashed);
      x = x - xd;
      if isMashed
          x2 = x2 - x2d;
      end
   end
   % evaluate normalization and apply if requested
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   if isMashed
       NC2 = localNormCoeff(NC2.Nspike1, NC2.Nspike2, binwidth, dur, Nrep1, Nrep2);
       x2 = localApplyNorm(x2, NC2, normStr);
   end
   return;
end

%% Calculation through sptcorrmex
if isMashed
   [ spt11 spt12 ] = correctMashed(spt1);
   [ spt21 spt22 ] = correctMashed(spt2);
   
   [ x BC ] = sptcorrmex(spt11, spt21, maxlag, binwidth);
   Nspike1 = length(spt11);
   Nspike2 = length(spt21);
   NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur);
   % apply normalization if requested
   x = localApplyNorm(x, NC, normStr);
   
   [ x2 BC2 ] = sptcorrmex(spt12, spt22, maxlag, binwidth);
   Nspike1 = length(spt12);
   Nspike2 = length(spt22);
   NC2 = localNormCoeff(Nspike1, Nspike2, binwidth, dur);
   % apply normalization if requested
   x2 = localApplyNorm(x2, NC2, normStr);
else
    [x, BC] = sptcorrmex(spt1, spt2, maxlag, binwidth);
    Nspike1 = length(spt1);
    Nspike2 = length(spt2);
    NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur);
    % apply normalization if requested
    x = localApplyNorm(x, NC, normStr);
end

%% Local functions
function NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur, Nrep1, Nrep2)
%Compute normalization coefficients ...

if nargin<5, Nrep1 = 1; end
if nargin<6, Nrep2 = 1; end
Rate1 = (1e-10+Nspike1)/dur/Nrep1; % innocent 1e-10 to prevent divde by zero warning
Rate2 = (1e-10+Nspike2)/dur/Nrep2;
if isnan(Nrep2) % autocorr w/o diag
   NF = dur*(Nrep1*(Nrep1-1));
   Rate2 = Rate1;
else % cross corr
   NF = dur*Nrep1*Nrep2;
end
DriesNorm = NF*Rate1*Rate2*binwidth;
NC = CollectInStruct(Nspike1, Nspike2, Rate1, Rate2, Nrep1, Nrep2, dur, ...
    binwidth, NF, DriesNorm);

function x = localApplyNorm(x, NC, normStr)
%Apply normalization ...

if ~isempty(normStr)
   if ~isfield(NC, normStr)
       error(['"' normStr '" is not a known normalization mode.']);
   end
   NormVal = NC.(normStr);
   x = x/NormVal; 
end

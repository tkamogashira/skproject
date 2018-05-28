function [x, BC, NC]=SPTCORR(spt1, spt2, maxlag, binwidth, dur, normStr, cacheParam);
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
%    digonal terms removed, i.e., the histogram is compiled only across
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
%    See also ANWIN, XCORR.

if nargin<5, dur = nan; end;
if nargin<6, normStr = ''; end;
if nargin<7, cacheParam = []; end;

% look in cachefile to save time
[found, x, BC, NC] = localFromCache(cacheParam, maxlag, binwidth);
if found, return; end
if ~isempty(cacheParam),
   QQ = FromCacheFile(mfilename, cacheParam);
   if ~isempty(QQ), % same calculation has been done before - copy the old results and quit
      eval(DealStructCommandStr(QQ)); % "unpack" fields of struct QQ
      return;
   end
end

% special recursive cases
if iscell(spt1) & iscell(spt2),
   % grand correlogram: merge all spikes of each set. Apply no normalization yet
   [x, BC, NC] = SPTCORRMATLAB([spt1{:}], [spt2{:}], maxlag, binwidth, dur, '');
   Nrep1 = length(spt1); Nrep2 = length(spt2);
   % evaluate normalization and apply if requested
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   % store in cache if requested
   localStoreInCache(cacheParam, x, NC);
   return;
elseif iscell(spt1),
   gEr=1; % pessimistic default
   try, gEr = ~isequal('nodiag',lower(spt2)); end
   if gEr, error('If SPT1 is a cell array, SPT2 must be either a cell array or the string "nodiag".'); end
   % non-diagonal autocorr; apply no normalization yet
   [x, BC, NC] = SPTCORRMATLAB([spt1{:}], [spt1{:}], maxlag, binwidth, dur, '');
   Nrep1 = length(spt1); Nrep2 = nan;
   for irep=1:length(spt1), % subtract diagonal terms
      x = x - SPTCORRMATLAB(spt1{irep}, spt1{irep}, maxlag, binwidth, dur, '');
   end
   % evaluate normalization and apply if requested
   NC = localNormCoeff(NC.Nspike1, NC.Nspike2, binwidth, dur, Nrep1, Nrep2);
   x = localApplyNorm(x, NC, normStr);
   % store in cache if requested
   localStoreInCache(cacheParam, x, NC);
   return;
end

% sort spike times to enable segmentation (see below)
spt1 = sort(spt1);
spt2 = sort(spt2);
% compute bincenters for crosscor histogram; include flanking out-of-range (garbage) bins
% the output param BC does not contain the garbage bins
[BC, bincenters] = localBinCenters(maxlag, binwidth);

% divide spiketimes in segments containing spiketimes in consecutive ranges 
% ... as follows: 0<spt<=maxlag,  maxlag<spt<=2*maxlag, etc
[I1, N1] = localSegments(spt1, maxlag);
[I2, N2] = localSegments(spt2, maxlag);
x = 0;
for n1=1:N1,
   i1 = I1(n1,:); % start & end indices of segment 1
   % compare to adjacent segments in spt2 - they are 3 at most
   n2min = max(1,n1-1);
   n2max = min(N2,n1+1);
   for n2=n2min:n2max, % compare respective segments
      % n1,n2
      i2 = I2(n2,:); % start & end indices of segment 2
      seg1 = spt1(i1(1):i1(2));
      seg2 = spt2(i2(1):i2(2));
      x = x + localXcorr(seg1,seg2,maxlag,bincenters); 
   end
end
% compute normalization coefficients
Nspike1 = length(spt1); Nspike2 = length(spt2);
NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur);
% apply normalization if requested
x = localApplyNorm(x, NC, normStr);
% store in cache if requested
localStoreInCache(cacheParam, x, NC);

%==========================================================================
%-------------------------------locals-------------------------------------
%==========================================================================
function [BC, bincenters] = localBinCenters(maxlag, binwidth);
% compute bincenters for crosscor histogram; include flanking out-of-range (garbage) bins
% the output param BC does not contain the garbage bins
bincenters = -(maxlag+binwidth):binwidth:(maxlag+binwidth); 
BC = bincenters(2:end-1);

function [I, N] = localSegments(spt, L);
% returns indices that partition spt array into values in segments [0, L], [L, 2L], etc
% spt must be positive & ascending.
Nsp = length(spt); Kmax = ceil(max(spt)/L)-1;
if (Nsp == 1), I = repmat(NaN, Kmax+1, 1); I(end) = 1;
else,
    dspt = diff(spt); dspt = dspt(find(dspt~=0)); minDT = min(dspt);
    % find the borders using interp1. Note: the linspace() forces the abcissae ...
    % ... to be different (as needed for interp1) without effecting the sorting properties
    I = 1+floor(interp1(spt+linspace(0,minDT,Nsp), 1:Nsp, (0:Kmax)*L));
    I(ceil(min(spt)/L)) = 1; I = I(:);
end
I = [I [I(2:end)-1; Nsp]];
iEmpty = find(any(isnan(I).'));
for ii=iEmpty, I(ii,:) = [1 0]; end;
N = size(I,1);


function A = localXcorr(t1,t2,maxlag,bincenters);
% non-normalized cross coincider using brute force
% t1 & t2 are assumed to be sorted
NNmax = 500^2;
N1 = length(t1); N2 = length(t2);
NN = N1*N2;
if NN>NNmax, % chop up in 4 smaller "quadrants"
   n1 = round(N1/2); n2 = round(N2/2);
   A = localXcorr(t1(1:n1),t2(1:n2),maxlag,bincenters);
   A = A + localXcorr(t1(1:n1),t2(n2+1:end),maxlag,bincenters);
   A = A + localXcorr(t1(n1+1:end),t2(1:n2),maxlag,bincenters);
   A = A + localXcorr(t1(n1+1:end),t2(n2+1:end),maxlag,bincenters);
   return;
elseif NN==0,
   A = zeros(1, length(bincenters)-2); 
   return;
end
% -- shift and normalize to prevent overflow and/or gross rounding errors
m1 = mean(t1); m2 = mean(t2);
range1 = t1(end)-t1(1);
range2 = t2(end)-t2(1);
Temper = max(range1, range2); if Temper==0, Temper=1; end;
z1 = (t1(:)-m1)/Temper;
z2 = (t2(:)-m2)/Temper;
% generate matrix containing all differences (e1-e2) across the elements of z1 and z2
Mdiff = Temper*log(exp(z1)*exp(-z2.'))+m1-m2;
% bin up
A = hist(Mdiff(:), bincenters);
% delete garbage bins
A = A(2:end-1);

function NC = localNormCoeff(Nspike1, Nspike2, binwidth, dur, Nrep1, Nrep2);
% compute normalization coefficients
if nargin<5, Nrep1 = 1; end
if nargin<6, Nrep2 = 1; end
Rate1 = (1e-10+Nspike1)/dur/Nrep1; % innocent 1e-10 to prevent divde by zero warning
Rate2 = (1e-10+Nspike2)/dur/Nrep2;
if isnan(Nrep2), % autocorr w/o diag
   NF = dur*(Nrep1*(Nrep1-1));
   Rate2 = Rate1;
else, % cross corr
   NF = dur*Nrep1*Nrep2;
end
DriesNorm = NF*Rate1*Rate2*binwidth;
NC = CollectInStruct(Nspike1, Nspike2, Rate1, Rate2, Nrep1, Nrep2, dur, binwidth, NF, DriesNorm);

function x = localApplyNorm(x, NC, normStr);
% apply normalization
if ~isempty(normStr),
   if ~isfield(NC, normStr), error(['"' normStr '" is not a known normalization mode.']); end;
   NormVal = getfield(NC, normStr);
   x = x/NormVal; 
end

function localStoreInCache(cacheParam, x, NC);
% store the results of the computation in cache file, i.e., a lookup table.
% CacheParam serves as the unique lookup label.
if isempty(cacheParam), return; end;
QQ = collectInStruct(x, NC);
ToCacheFile(mfilename, -5e3, cacheParam, QQ);

function [found, x, BC, NC] = localFromCache(cacheParam, maxlag, binwidth);
% look in cachefile to save time
found = 0; [x, BC, NC]=deal([]); % pessimistic defaults
if ~isempty(cacheParam),
   QQ = FromCacheFile(mfilename, cacheParam);
   if ~isempty(QQ), % same calculation has been done before - copy the old results and quit
      eval(DealStructCommandStr(QQ)); % "unpack" fields of struct QQ
      BC = localBinCenters(maxlag, binwidth); % too trivial to store
      found = 1;
      return;
   end
end


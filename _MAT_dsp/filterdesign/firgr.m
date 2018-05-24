function [h,err,res] = firgr(order, ff1, aa, varargin)
%FIRGR Generalized Remez FIR filter design.
%   FIRGR is a minimax filter design algorithm that can be used to design
%   the following types of real FIR filters: types 1-4 linear phase,
%   minimum phase, maximum phase, minimum order (even or odd), extra
%   ripple, maximal ripple, constrained ripple, single-point band (notching
%   and peaking), forced gain and arbitrarily shaped filters.
%
%   B = FIRGR(N,F,A,W) returns a length N+1 linear phase FIR filter which
%   has the best approximation to the desired frequency response described
%   by F and A in the minimax sense.  W is a vector of weights, one per
%   band. If W is omitted, all bands are weighted equally.  For more
%   information on the input arguments see the FIRPM help entry.
%
%   B = FIRGR(N,F,A,'Hilbert') and B = FIRGR(N,F,A,'differentiator') design
%   FIR Hilbert transformers and differentiators respectively.  For more
%   information on the design of these filters see the FIRPM help entry.
%
%   B = FIRGR(M,F,A,DEV) where M is either 'minorder', 'mineven' or
%   'minodd', designs filters repeatedly until the minimum order filter (as
%   specified in M) that meets the specifications is found.  DEV is a
%   vector containing the maximum deviation or ripple (in linear units) per
%   frequency band.  DEV must be specified. If 'mineven' or 'minodd' is
%   specified, the minimum even or odd order filter is found.  A maximum of
%   50 different filter orders are attempted.  If M is 'estorder', B is
%   simply the estimated order of the filter and the filter is not
%   designed.
%
%   B = FIRGR({M,NI},F,A,DEV) where M is either 'minorder', 'mineven' or
%   'minodd', uses NI as the initial estimate of the filter order.  NI is
%   optional for common filter designs, but it must be specified for
%   designs in which FIRPMORD cannot be used, such as the design of
%   differentiators or Hilbert transformers.
%
%   B = FIRGR(N,F,A,W,E) specifies independent approximation errors for
%   different bands and is used to design extra ripple or maximal ripple
%   filters.  These filters have interesting properties such as having the
%   minimum transition width. E is a cell array of strings indicating the
%   approximation errors to use and its length must equal the number of
%   bands.  The entries of E must of the form 'e#' where # indicates which
%   approximation error to use for the corresponding band. For example, if
%   E = {'e1','e2','e1'}, the first and third bands use the same
%   approximation error whereas the second band uses a different one.  Note
%   that if all bands use the same approximation error, i.e.,
%   {'e1','e1','e1',...} then it is equivalent to not specifying E at all,
%   as in B = FIRGR(N,F,A,W).
%
%   B = FIRGR(N,F,A,S) is used to design filters with special properties at
%   certain frequency points. S is a cell array of strings and must be the
%   same length as F and A.  The entries of S must be one of: 'n' - normal
%   frequency point. Nothing new about this point. 's' - single-point band.
%   The frequency "band" is given by a single point. The corresponding gain
%   at this frequency point must be specified in A. 'f' - forced frequency
%   point.  The gain at the specified frequency band edge is forced to be
%   the value specified. 'i' - indeterminate frequency point.  It is used
%   when adjacent bands touch (no transition region). For instance, EXAMPLE
%   2 below designs a filter with two zero-valued single-point bands
%   (notches) at 0.25 and 0.55. EXAMPLE 3 below designs a highpass filter
%   whose gain at 0.06 is forced to be zero.  The band edge at 0.055 is
%   indeterminate since the first two bands actually touch.  The other band
%   edges are normal.
%
%   B = FIRGR(N,F,A,S,W,E) specifies weights and independent approximation
%   errors for filters with special properties in vectors W and E.  It is
%   sometimes necessary to use independent approximation errors to get
%   designs with forced values to converge.  For instace, see EXAMPLE 3
%   below.
%
%   B = FIRGR(...,'1') designs a type 1 filter (even-order symmetric). One
%   can also specify type 2 (odd-order symmetric), type 3 (even-order
%   antisymmetric), and type 4 (odd-order antisymmetric) filters. Note that
%   there are restrictions on A at f=0 or f=1 for types 2 to 4.
%
%   B = FIRGR(...,'minphase') designs a minimum-phase FIR filter.  There is
%   also 'maxphase'.
%
%   B = FIRGR(..., 'check') produces a warning if there are potential
%   transition-region anomalies.
%
%   B = FIRGR(...,{LGRID}), where {LGRID} is a scalar cell array containing
%   an integer, controls the density of the frequency grid.
%
%   [B,ERR] = FIRGR(...) returns the unweighted approximation error
%   magnitudes. ERR has one element for each independent approximation
%   error.
%
%   [B,ERR,RES] = FIRGR(...) returns a structure RES of optional results
%   computed by FIRGR, and contains the following fields:
%
%      RES.fgrid: vector containing the frequency grid used in
%                 the filter design optimization
%        RES.des: desired response on fgrid
%         RES.wt: weights on fgrid
%          RES.H: actual frequency response on the grid
%      RES.error: error at each point on the frequency grid (desired - actual)
%      RES.iextr: vector of indices into fgrid of extremal frequencies
%      RES.fextr: vector of extremal frequencies
%      RES.order: filter order
%  RES.edgeCheck: transition-region anomaly check.  One element per band edge:
%                 1 = OK
%                 0 = probable transition-region anomaly
%                -1 = edge not checked
%                 Only computed if the 'check' option is specified.
% RES.iterations: number of Remez iterations for the optimization
%      RES.evals: number of function evaluations for the optimization
% RES.returnCode: indicates if design converged.  Useful when FIRGR is
%                 invoked from another file
%                 0  = convergence
%                 -1 = computed err was a NaN
%                 -2 = computed err decreased during iteration.
%                      should be monotonically increasing.
%                 -3 = insufficient number of band edges was specified.
%                 -4 = too many constraints (e.g., fixed in-band points)
%                 -5 = grid density LGRID is probably too low.
%
%   FIRGR is also a "function function", allowing you to write a
%   function that defines the desired frequency response.
%
%   B = FIRGR(N,F,@fresp,W) returns a length N+1 FIR filter which has the
%   best approximation to the desired frequency response as returned by the
%   function handle @fresp.  The function is called from within FIRGR using
%   the syntax:
%                    [DH,DW] = fresp(N,F,GF,W);
%   where:
%   N is the filter order.
%   F is the vector of frequency band edges which must appear
%     monotonically between 0 and 1, where 1 is the Nyquist
%     frequency.  The frequency bands span F(k) to F(k+1) for k odd;
%     the intervals  F(k+1) to F(k+2) for k odd are "transition bands"
%     or "don't care" regions during optimization.
%   GF is a vector of grid points which have been chosen over
%     each specified frequency band by FIRGR, and determines the
%     frequency grid at which the response function will be evaluated.
%   W is a vector of real, positive weights, one per band, for use
%     during optimization.  W is optional; if not specified, it is set
%     to unity weighting before being passed to 'fresp'.
%   DH and DW are the desired frequency response and optimization
%     weight vectors, respectively, evaluated at each frequency
%     in grid GF.
%
%   The predefined frequency response function handle for FIRGR is
%   @firpmfrf2, but you can write your own based on the simpler @firpmfrf.
%   See the help for PRIVATE/FIRPMFRF for more information.
%
%   B = FIRGR(N,F,{@fresp,P1,P2,...},W) specifies optional arguments
%   P1, P2, etc., to be passed to the response function handle @fresp.
%
%   B = FIRGR(N,F,A,W) is a synonym for B = FIRGR(N,F,{@firpmfrf2,A},W),
%   where A is a vector of response amplitudes at each band edge in F.
%
%   By default, FIRGR designs symmetric (even) FIR filters. B =
%   FIRGR(...,'h')  and B = FIRGR(...,'d') design antisymmetric (odd)
%   filters. Each frequency response function handle @fresp can tell FIRGR
%   to design either an even or odd filter in the absence of the 'h' or 'd'
%   flags.  This is done with
%         SYM = fresp('defaults',{N,F,[],W,P1,P2,...})
%   FIRGR expects @fresp to return SYM = 'even' or SYM = 'odd'.
%   If @fresp does not support this call, FIRGR assumes 'even' symmetry.
%
%   EXAMPLE 1:
%      % Design of filter with two single-band notches at .25 and .55
%      B = firgr(42,[0 0.2 0.25 0.3 0.5 0.55 0.6 1],[1 1 0 1 1 0 1 1],...
%      {'n' 'n' 's' 'n' 'n' 's' 'n' 'n'});
%
%   EXAMPLE 2:
%      % Highpass filter whose gain at 0.06 is forced to be zero. The gain
%      % at 0.055 is indeterminate since it should abut the band
%      B = firgr(82,[0 0.055 0.06 0.1 0.15 1],[0 0 0 0 1 1],...
%      {'n' 'i' 'f' 'n' 'n' 'n'});
%
%   EXAMPLE 3:
%      % Highpass filter with forced values and independent approx. errors
%      B = firgr(82,[0 0.055 0.06 0.1 0.15 1], [0 0 0 0 1 1], ...
%      {'n' 'i' 'f' 'n' 'n' 'n'}, [10 1 1] ,{'e1' 'e2' 'e3'});
%
%   See also FIRPM, FIRGRDEMO, CFIRPM, FIRCBAND, FIRLS, IIRLPNORM,
%   IIRLPNORMC, IIRGRPDELAY, IIRNOTCH, IIRPEAK.

%   Author(s): D. Shpak
%   Copyright 1999-2011 The MathWorks, Inc.

%   References:
%     Shpak, D. and A. Antoniou, A Generalized Remez Method for the Design
%     of FIR Digital filters, IEEE Trans. Circ. & Sys, vol 37, No 2, 1990.

if (nargin < 3)
    error(message('dsp:firgr:NARGCHK'))
end

minOrder = 0;
estOrder = false;

s = parseOrder(order,estOrder,minOrder);

s = parse_inputs(s, ff1, aa, varargin{:});

% Estimate the filter order with firpmord?
if s.estOrder
    s.nfilt = estimateOrder(s);
end

if s.params.minOrder == 4
    h = s.nfilt - 1;
    err = 0;       res = 0;
    return;
end

% For minorder designs, enforce the boundary conditions for
% the filter types
if s.params.minOrder == 1 && ~iscell(s.aa) && ~isequal(s.frf, @genlp) 
    s = enforceType(s);
end

if (s.params.minOrder == 1 && isequal(s.frf, @genhp))
  % Minimum order designs using genhp need to be forced to even order if no
  % order constraint was specified. 
 s.ftype = 1;  
 s.params.minOrder = 2;
end
 
 
% For minOrder designs the minimum increment of the order is 1 unless
% the filter is specified to be even-order, odd-order, or minphase
s.minOrderInc = 1;
if s.params.minOrder
    s = determineIncrement(s);
    doMinOrder(true);
end


% Try up to 50 different orders if we are finding the minimum order
[h,err,s] = design(s);

% Validate and generate filter
[h,err] = genfilter(h,err,s);

if nargout > 2,
    res = genresstruct(h,s);
end

if s.params.check
    k = find(s.checks == 0, 1);
    if ~isempty(k)
        warning(message('dsp:firgr:transitionAnomaly'));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,err,s] = design(s)

% Try up to 50 different orders if we are finding the minimum order
done = false;
s.valid = false;
saveit = [];
s.lastNfilt = s.nfilt;
for tries=1:50
    if done, break; end;

    % Design the filter
    [h,err,s] = firgrso(s);

    if s.ret_code == -3 || s.ret_code == -4 || s.ret_code == -5
        break;
    end

    if s.params.minOrder

        % Check if we met specs
        [done,saveit,restoreIt,s] = checkDesign(h,err,saveit,s);

        if restoreIt
            h=saveit{1};		err=saveit{2};		s.iext=saveit{3};
            s.checks = saveit{4};	s.iters=saveit{5};
            s.zero=saveit{6};     s.ftype = saveit{7};	s.nfilt = saveit{8};
            s.grid=saveit{9};		s.des=saveit{10};		s.wt=saveit{11};
            s.ret_code = 0;
        end
    else
        done = true;
        if s.ret_code == 0
            s.valid = true;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,err] = genfilter(h,err,s)
% Genfilter - generate the final filter when design is valid
if s.valid == 0
    if err(1) > 1.0
        warning(message('dsp:firgr:finalFilterOrder1', s.lastNfilt));
    else
        warning(message('dsp:firgr:finalFilterOrder2', s.lastNfilt));
    end
end
if ~s.params.minOrder && ~s.valid
    handleErrorCode (s.ret_code, s.iters(1));
end

if s.valid && any(abs(err) < 100*max(abs(s.des))*eps)
    warning(message('dsp:firgr:machineAccuracy'));
end
% For minimum-phase filters, we now find the required half-order polynomial
if s.params.minPhase
    h = firminphase(h, s.zero, 'angles');
    err = sqrt(abs(err));
    % Handle maximum phase
    if s.params.minPhase == 2
        h = fliplr(h);
    end
else
    err = abs(err);
end

% Correct the sign for a differentiator
h = h * s.sign_val;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Handle error codes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handleErrorCode (ret_code, iters)
if ret_code == -1
    %error('%s\n%s\n%s\n%s%s', ...
    %    'Approximation error was not computable:', ...
    %    '1) Check the specifications.', ...
    %    '2) Transition region could be much too narrow or too wide for filter order.', ...
    %    '3) For multiband filters, try making the transition regions', ...
    %    ' more similar in width.');
elseif ret_code == -2
    warning(message('dsp:firgr:notConverging', iters));
elseif ret_code == -3
    error(message('dsp:firgr:InvalidDimensions'));
elseif ret_code == -4
    error(message('dsp:firgr:FilterErr1'));
elseif ret_code == -5
    error(message('dsp:firgr:FilterErr2'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = genresstruct(h,s)
% arrange 'results' structure

res.order = s.nfilt - 1;
res.fgrid = s.grid(:);
res.H = freqz(h,1,res.fgrid*pi);
if s.neg  % asymmetric impulse response
    linphase = exp(sqrt(-1)*(res.fgrid*pi*(res.order/2) - pi/2));
else
    linphase = exp(sqrt(-1)*res.fgrid*pi*(res.order/2));
end
if s.hilbert == 1  % hilbert
    res.error = real(s.des(:) + res.H.*linphase);
elseif ~s.params.minPhase
    res.error = real(s.des(:) - res.H.*linphase);
else
    res.error = s.des(:) - abs(res.H);
end
if s.params.minPhase
    res.des = sqrt(s.des(:));
    res.wt = sqrt(s.wt(:));
else
    res.des = s.des(:);
    res.wt = s.wt(:);
end
res.iextr = s.iext(1:end);
res.fextr = s.grid(res.iextr);  % extremal frequencies
res.fextr = res.fextr(:);
res.iterations = s.iters(1);
res.evals = s.iters(2);
res.edgeCheck = s.checks;
res.returnCode = s.ret_code;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [done,saveit,restoreIt,s] = checkDesign(h,err,saveit,s)
% Check if we met specs

if s.ret_code == 0
    ok = metSpecs(s,err);
else
    ok = false;
end

if ok
    % Save what might be the desired solution
    saveit = {h, err, s.iext, s.checks, s.iters, s.zero, s.ftype, s.nfilt, s.grid, s.des,s.wt};
end
[done,restoreIt,s] = doMinOrder(false,err,saveit,ok,s);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check if the filter meets the specifications when we
% are finding the lowest-order filter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ok = metSpecs (s,err)
ok = true;
if s.ret_code ~= 0
    ok = false;
else
    for m=1:s.nbands
        if ~s.constr(m) && abs(err(s.banderr(m)))/s.wtx1(m) > s.devs(m)
            ok = false;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check if a minorder design is successful
% Compute the next filter order to try
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [done,restoreIt,s] = doMinOrder(init,err,saveit,ok,s)
persistent orderFactor orderDirection orderHigh orderLow lowErr highErr;
persistent tried orderSlow lowNfilt highNfilt;
if init
    % If the minimum order design is not yet bracketed by two designs,
    % we want to increase (or decrease) the order by a multiplicative
    % factor
    orderFactor = [0.3 0.1];
    orderDirection = 1;  % 1=increase, -1=decrease
    % Both orderHigh and orderLow must become true to bracket the solution
    orderHigh = false;  lowErr = 0;
    orderLow = false;   highErr = 0;
    saveit = [];        tried = [];
    orderSlow = false;
    lowNfilt = -1; % Make sure that lower-order filter is attempted
    highNfilt = 0;
    return;
else
    restoreIt = false;           done = false;

    if ok
        % Found a filter with sufficient order
        orderHigh = true;
        orderDirection = -1;
        s.valid = 1;
        done = true;
        lowErr = err;    highNfilt = s.nfilt;
    elseif abs(err(1)) > 1
        % Found a filter with insufficient order
        orderLow = true;
        orderDirection = 1;
        highErr = err;    lowNfilt = s.nfilt;
    elseif orderLow && orderHigh && highNfilt-s.nfilt == s.minOrderInc
        orderLow = true;  lowNfilt = s.nfilt;
    end

    if ~ok && lowNfilt >= 0 && ~isempty(saveit) ...
            && highNfilt-lowNfilt == s.minOrderInc
        % Restore the previous design
        restoreIt = true;
        s.valid = 1;
        done = true;
    end
    s.lastNfilt = s.nfilt;
    % Must have solution bracketed by the minimum order increment
    if ~orderLow || ~orderHigh || highNfilt-lowNfilt > s.minOrderInc
        done = false;
    elseif done
        return;
    end

    if any(tried == s.nfilt2), orderSlow = true; end
    if orderSlow
        % Avoid a limit cycle in the order
        s.nfilt = s.nfilt + orderDirection * s.minOrderInc;
    elseif orderLow && orderHigh && isfinite(err)
        % The solution is bracketed. Interpolate the approximation
        % errors to get the next order estimate
        lowErr = saveit{2};
        dOrder = (abs(err(1)) - 1) / (abs(highErr(1)) - abs(lowErr(1))) ...
            * (saveit{8} - lowNfilt);
        signum = sign(dOrder);
        dOrder = round(dOrder);
        if abs(dOrder) < s.minOrderInc
            dOrder = s.minOrderInc * signum;
        elseif s.minOrderInc == 2 && mod(dOrder,2)
            dOrder = dOrder + 1;
        end
        if abs(dOrder) > s.nfilt/2, dOrder = round(sign(dOrder)*s.nfilt/2); end
        s.nfilt = s.nfilt + dOrder;
    else
        % Solution is not bracketed.  Extend the interval.
        if abs(err(1)) < 0.5 || abs(err(1)) > 2.0
            dOrder = round(s.nfilt * orderFactor(1));
        else
            dOrder = round(s.nfilt * orderFactor(2));
        end
        if dOrder > s.minOrderInc
            if s.minOrderInc == 2 && mod(dOrder,2)
                dOrder = dOrder + 1;
            end
        else
            dOrder = s.minOrderInc;
        end
        s.nfilt = s.nfilt + orderDirection*dOrder;
    end

    if s.nfilt < 4,
        if orderHigh,
            s.nfilt = highNfilt;
            return
        else
            error(message('dsp:firgr:orderTooSmall1'));
        end
    end
    tried = [tried s.nfilt2];
    s.ftype = new_ftype(s.ftype, s.nfilt, s.ff, s.aa);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% determine Increment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = determineIncrement(s)
% Determine order increment

if s.params.minPhase
    s.minOrderInc = 2; % Because order is doubled
    % If even or odd order is requested, make it so.
elseif s.params.minOrder == 2  % Even-order (odd-length) design
    if rem(s.nfilt,2) == 0, s.nfilt = s.nfilt + 1; end
    s.minOrderInc = 2;
elseif s.params.minOrder == 3 % Odd-order design
    if rem(s.nfilt,2) == 1, s.nfilt = s.nfilt + 1; end
    s.minOrderInc = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% enforce filter type
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = enforceType(s)
% Enforce the correct filter type

if (s.ftype == 1 || s.ftype == 2) && s.ff(end) == 1 && s.aa(end) ~=0
    s.ftype = 1;    s.params.minOrder = 2;
elseif (s.ftype == 3 || s.ftype == 4) && s.ff(1) == 0 && s.aa(1) ~= 0
    error(message('dsp:firgr:oddSymmetry'));
elseif s.ftype == 3 && s.ff(end) == 1 && s.aa(end) ~= 0
    s.ftype = 4;    s.params.minOrder = 3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nfilt = estimateOrder(s)

% We can only estimate the order using firpmord if it's
% a typical multiband filter.
% Otherwise, we'll use start with the order that was
% specified in the call to firpm
if ~isequal(s.frf, @firpmfrf2)
    error(message('dsp:firgr:orderEstimation1'));
end
if any(diff(s.aa(1:2:end)-s.aa(2:2:end))) ~= 0.0
    error(message('dsp:firgr:orderEstimation2'));
end
if s.ff(1) ~= 0 || s.ff(end) ~= 1
    error(message('dsp:firgr:orderEstimation3'));
end

% If we are designing with an estimated minimum order, need to call the frf
% to pre-process the specifications
grid = s.ff(1):s.ff(2);
[des,wt,wtx1,s.ff,s.free_edges,devs,constr,banderr,lb,ub,errindex] = ...
    s.frf(0, s.ff, s.free_edges, grid, s.wtx, s.wtx_prop, ...
    s.params.minPhase, s.params.minOrder, s.frf_params{:}); %#ok

nfilt = firpmord(s.ff(2:end-1), s.aa(1:2:end), devs, 2);
if (s.params.minPhase && rem(nfilt,2) == 0)
    nfilt = nfilt + 1;
end
if nfilt < 3
    % disp('Estimated filter order was < 3.  Trying order=3.');
    nfilt = 3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Process the specified order, which may be an integer, string
% or cell array
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = parseOrder(order,estOrder,minOrder)
% If we have a character string for the order, we will
% need to call firpmord to estimate the order
ordstring = [];
if ischar(order)
    estOrder = true;
    ordstring = order;
    order = 0;
    %params.newFeatures = 1;
end
if iscell(order)
    %params.newFeatures = 1;
    ordstring = order{1};
    if length(order) == 2
        % An estimate of the order has been specified
        order = order{2};
    else
        estOrder = true;
        order = 0;
    end
end

% If we have a string for the order, parse it
if ~isempty(ordstring)
    if strncmp(ordstring, 'minorder', 5)
        minOrder = 1;
    elseif strncmp(ordstring, 'mineven', 5)
        minOrder = 2;
    elseif strncmp(ordstring, 'minodd', 5)
        minOrder = 3;
    elseif strncmp(ordstring, 'estorder', 5)
        minOrder = 4;
        estOrder = true;
    else
        error(message('dsp:firgr:wrongOrder'));
    end
end

s.order = order; s.estOrder = estOrder; s.params.minOrder = minOrder;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = parse_inputs(s, ff1, aa, varargin)

%
% Define default values for input arguments:
%
ftype = 'f';
lgrid = 16;   % Grid density (should be at least 16)
%
% parse inputs and alter defaults
%
%  First find cell array and remove it if present
%  This cell array is used for changing lgrid
%
%  Also, check for any features that are new in the
%  C-mex version.  If no new features are used,
%  we will use the new Remez in "legacy" mode for
%  maximum compatibility with the FORTRAN version.

s.params.newFeatures = 0;  % Legacy mode

% If we have a cell array argument in varargin
% containing one scalar, it is the grid density specification.
% Use this value and remove it from varargin
for i=1:length(varargin)
    if (iscell(varargin{i}) && length(varargin{i}) == 1 && isnumeric(varargin{i}{:}))
        lgrid = varargin{i}{:};
        if lgrid < 16,
            warning(message('dsp:firgr:lowDensity'));
        end
        if lgrid < 1,
            error(message('dsp:firgr:negativeGridDensity'));
        end
        varargin(i) = [];
        break
    end
end

% If the first varargin is a cell array, then it must be
% a cell array of characters specifying band edge properties
edge_prop = [];
if ~isempty(varargin) && iscell(varargin{1})
    edge_prop = varargin{1};
    varargin(1) = [];
    s.params.newFeatures = 1;
end

% The default is a vanilla linear-phase filter
% and no checking for transition-region anomalies
s.params.minPhase = 0;
s.params.check = 0;
wtx = [];
wtx_prop = [];
for i=1:length(varargin)
    if ischar(varargin{i})
        % We have a string argument, so look for text-based options
        str = lower(varargin{i});
        if length(varargin{i}) == 1
            ftype = varargin{i};
        elseif strncmp(str, 'minphase', 5)
            s.params.minPhase = 1;
        elseif strncmp(str, 'maxphase', 5)
            s.params.minPhase = 2;
        elseif strncmpi(str, 'hilbert',length(str))
            ftype = 'h';
        elseif strncmpi(str, 'differentiator',length(str))
            ftype = 'd';
        elseif strcmp (str, 'check')
            s.params.check = 1;
        end
    elseif iscell(varargin{i})
        % If there is a cell array remaining,
        % it must be the weight properties
        wtx_prop = varargin{i};
        s.params.newFeatures = 1;
        if any(strcmpi(wtx_prop{1}, {'w', 'c'})),
            warning(message('dsp:firgr:DeprecatedFeature'));
        end
    else
        % Otherwise it is the error weights for the bands
        wtx = varargin{i};
    end
end

if s.params.check ~= 0 || s.params.minPhase ~= 0
    s.params.newFeatures = 1;
end

% To get accurate location for stopband zeros, minPhase filter
% need more grid points
if s.params.minPhase
    if lgrid < 64; lgrid = 64; end
end

if isempty(ftype), ftype = 'f'; end

if length(ftype) == 1 && ftype(1)=='m'
    error(message('dsp:firgr:noMFile'));
end

if ~s.estOrder && (fix(s.order) ~= s.order || s.order < 3)
    error(message('dsp:firgr:orderTooSmall2'))
end
%
% Error checking
%
% Need to frequencies and band-edge properties
[ff,aa,free_edges] = firpmedge(ff1, aa, edge_prop);
if isempty(wtx)
    if s.params.minOrder ~= 0
        error(message('dsp:firgr:missingDeviations'));
    end
    wtx = ones(fix((1+length(ff))/2),1);
end
wtx1 = wtx;

if rem(length(ff),2)
    error(message('dsp:firgr:oddNumberOfFreqPoints'));
end
% Error check the band-edge frequencies
if any(ff < 0) || any(ff > 1)
    error(message('dsp:firgr:freqOutOfRange'));
end
df = diff(ff);
if (any(df < 0))
    error(message('dsp:firgr:decreasingFreqs'));
end
if length(wtx) ~= fix((1+length(ff))/2)
    if s.params.minOrder,
        error(message('dsp:firgr:wrongNumberOfDevs'));
    else
        error(message('dsp:firgr:wrongNumberOfWeights'));
    end
end

if (any(sign(wtx) == 1) && any(sign(wtx) == -1)) || any(sign(wtx) == 0),
    error(message('dsp:firgr:nonPositiveWeights'));
end

nbands = length(ff)/2;

%
% Determine "Frequency Response Function" (frf)
% by inspecting the amplitude specification
%

% The following comment, MATLAB compiler pragma, is necessary to allow the
% Compiler to find the private functions. Do not remove.
%#function firpmfrf
%#function firpmfrf2

if ischar(aa)
    % If still using a string, convert to function handle
    frf = str2func(aa);
    frf_params = {};
elseif isa(aa, 'function_handle')
    % We have a user-specified frf
    frf = aa;
    frf_params = {};
elseif iscell(aa)
    frf = aa{1};
    if ischar(frf)
        frf = str2func(frf);
    end
    frf_params = aa(2:end);
else
    % We have a standard bandwise filter design
    frf = @firpmfrf2;
    % A differentiator gets a special weighting function
    frf_params = { aa, strcmpi(ftype(1),'d') };
end

% We need the following code to generate fcn handles to private functions.
% Otherwise the syntax h=firgr(n,f,{@firpmfrf2,m},w); will not work
fcns = functions(frf);
if isempty(fcns.file)
    frf = str2func(func2str(frf));
end


% Work with filter length
nfilt = s.order + 1;        % filter length

% Create a structure of outputs to return
s.nfilt = nfilt; s.lgrid = lgrid; s.ff=ff; s.aa = aa;
s.ftype=ftype; s.free_edges=free_edges; s.nbands = nbands; s.wtx=wtx;
s.wtx1=wtx1; s.wtx_prop = wtx_prop; s.frf=frf; s.frf_params=frf_params; 


% Determine symmetry of filter
s = doFtype(s);

% Make sure that we can find the mex file
if (exist('gremezmex', 'file') ~= 3)
    error(message('dsp:firgr:noExecutable'));
end

if s.params.minPhase && rem(s.nfilt, 2) == 0
    error(message('dsp:firgr:evenOrder'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Determine and verify the filter type
% (1 = even-order symmetric)
% (2 = odd-order symmetric)
% (3 = even-order antisymmetric)
% (4 = odd-order antisymmetric)
% Also, the special cases of Hilbert transformer or differentiator
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = doFtype(s)

nodd = rem(s.nfilt,2);      % nodd == 1 ==> filter length is odd
% nodd == 0 ==> filter length is even
sign_val = 1; % Signs of coefficients get changed for a Differentiator

% Support the existing filter types 'hilbert' and 'differentiator'
% but also let the user specify types 1, 2, 3, or 4
hilbert = 0;
switch (lower(s.ftype(1)))
    case 'h'
        s.ftype = 3;  % Hilbert transformer
        hilbert = 1;
        if (rem(s.order, 2) == 1)
            s.ftype = 4;
        end
    case 'd'
        s.ftype = 4;  % Differentiator
        sign_val = -1;
        if (rem(s.order, 2) == 0)
            s.ftype = 3;
        end
    case '1'
        s.ftype = 1;
        if (nodd == 0)
            error(message('dsp:firgr:incompatibleSpecs1'));
        end
    case '2'
        s.ftype = 2;
        if (nodd == 1)
            error(message('dsp:firgr:incompatibleSpecs2'));
        end
    case '3'
        s.ftype = 3;
        if (nodd == 0)
            error(message('dsp:firgr:incompatibleSpecs3'));
        end
    case '4'
        s.ftype = 4;
        if (nodd == 1)
            error(message('dsp:firgr:incompatibleSpecs4'));
        end
    otherwise
        % If symmetry was not specified, call the fresp function
        % with 'defaults' string and a cell-array of the actual
        % function call arguments to query the default value.
        if isequal(s.frf, @firpmfrf2)
            h_sym = 'even';
        else
            try
                h_sym = s.frf('defaults', {s.order, s.ff, [], s.wtx, s.frf_params{:}});
            catch
                h_sym = 'even';
            end
        end

        if ~any(strcmp(h_sym,{'even' 'odd'})),
            error(message('dsp:firgr:invalidSymmetry', h_sym, s.frf));
        end

        switch h_sym
            case 'even' % Symmetric filter
                s.ftype = new_ftype(1, s.nfilt, s.ff, s.aa);
            case 'odd'		% Odd (antisymmetric) filter
                s.ftype = new_ftype(3, s.nfilt, s.ff, s.aa);
        end
end

if (s.ftype == 3 || s.ftype == 4)
    neg = 1;  % neg == 1 ==> antisymmetric imp resp,
else
    neg = 0;  % neg == 0 ==> symmetric imp resp
end

% Add properties to structure
s.sign_val = sign_val; s.neg=neg; s.hilbert=hilbert;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Since the order can change when finding the lowest filter
% order, the filter type can change too.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newtype = new_ftype(ftype, nfilt, ff, aa)
switch ftype
    case {1, 2}
        if rem(nfilt, 2)
            newtype = 1;
        else
            newtype = 2;
            if iscell(aa), return; end
            if (ff(end) == 1 && aa(end) ~= 0)
                error(message('dsp:firgr:incompatibleSpecs5'));
            end
        end
    case {3, 4}
        if rem(nfilt, 2)
            newtype = 3;
            if iscell(aa), return; end
            if (ff(1) == 0 && aa(1) ~= 0) || (ff(end) == 1 && aa(end) ~= 0)
                error(message('dsp:firgr:incompatibleSpecs6'));
            end

        else
            newtype = 4;
            if iscell(aa), return; end
            if (ff(1) == 0 && aa(1) ~= 0)
                error(message('dsp:firgr:incompatibleSpecs7'));
            end
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Specify order design
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,err,s] = firgrso(s)
%FIRGRSO   Specify-order FIRGR.

% Core design function. Generate frequency grid and call mex-file for
% design

% Create grid of frequencies on which to perform firpm exchange iteration
%
% We use the new grid function even in legacy mode since
% the results are more accurate
s.grid = firpmgrid(s.nfilt,s.lgrid,s.ff,s.ftype,s.free_edges);
while length(s.grid)<=s.nfilt
    s.lgrid = s.lgrid*4;  % need more grid points
    s.grid = firpmgrid(s.nfilt,s.lgrid,s.ff,s.ftype,s.free_edges);
end

%
% Get desired frequency characteristics at the frequency points
% in the specified frequency band intervals.
%
% NOTE! The frf needs to see normalized frequencies in the range [0,1].
%
% Unconstrained designs have empty constraints lb and ub
lb = [];
ub = [];
errindex = ones(length(s.grid),1);
s.banderr = ones(s.nbands, 1);

try
    % First we will see if the "frf" returns the maximum nargout
    [s.des,s.wt,s.wtx1,s.ff,s.free_edges,s.devs,s.constr,s.banderr,lb,ub,errindex] = ...
        s.frf(s.order, s.ff, s.free_edges, s.grid, s.wtx, s.wtx_prop, ...
        s.params.minPhase, s.params.minOrder, s.frf_params{:}); 
catch
    if isequal(s.frf, @firpmfrf2)
        error(message('dsp:firgr:cannotEvalSpecs'));
    end
    % Otherwise we must be using a user-supplied legacy frf
    [s.des,s.wt] = s.frf(s.order, s.ff, s.grid, s.wtx, s.frf_params{:}); 
end

s.ftype = new_ftype(s.ftype, s.nfilt, s.ff, s.aa); 

if (s.nfilt < 100)
    s.params.fast = 1;  % Use fast Vandermonde solver
else
    s.params.fast = 0;
end

s.params.dof = max(errindex);

if s.params.minPhase
    % Minimum-phase designs start with a filter of twice the order
    s.nfilt2 = 2*(s.nfilt-1) + 1;
    % We also need to square the weights, constraints, and the desired values
    k = find(s.des == 0);
    s.wt(k) = s.wt(k).^2;
    k = find(s.des > 0);
    s.wt(k) = s.des(k).*s.wt(k)/2;
    %s.wt(k) = sqrt(s.wt(k));
    lb = lb.^2;
    ub = ub.^2;
    s.des = s.des.^2;
else
    s.nfilt2 = s.nfilt;
end

s.params.ftype = s.ftype;


% Call MEX-file
[h,err,s.iext,s.ret_code,s.checks,s.iters,s.zero] = gremezmex(s.nfilt2,s.ff,s.grid,s.des,s.wt,s.wtx1, ...
    s.free_edges,lb,ub,errindex,s.params);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set up the grid of frequency points for the approximation
% on a compact subset of the interval [0, pi]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function grid = firpmgrid(nfilt,lgrid,ff,ftype,free_edges)
nfcns = fix(nfilt/2);
if ftype == 1
    nfcns = nfcns + 1;
end
nbands = length(ff) / 2;
ngrid = lgrid*nfcns;

% Sum the parts of the frequency axis that are
% used (i.e., exclude "don't care" regions
fsum = 0.0;
for i=1:nbands
    fsum = fsum + (ff(2*i) - ff(2*i-1));
end

if (fsum == 0)
    error(message('dsp:firgr:finiteWidthBand'));
end
grid = [];
delf = fsum / ngrid;

if (nbands == 1)
    grid = ff(1) + (0:ngrid-2)*delf;
    grid(ngrid) = ff(2);
else
    % Double the number of grid points near internal band edges
    % This results in more accurate designs with a small increase
    % in computational effort
    for i=1:nbands
        if free_edges(2*i-1) == 1
            if i == 1
                left = 0;
            else
                left = ff(2*i-2) + delf;
            end
        else
            left = ff(2*i - 1);
        end
        if free_edges(2*i) == 1
            if i == nbands
                right = 1;
            else
                right = ff(2*i + 1);
            end
        else
            right = ff(2*i);
        end
        % Do not duplicate grid points
        if (i > 1)
            if (grid(end) == left)
                if (length(grid) > 1)
                    grid = grid(1:end-1);
                else
                    grid = [];
                end
            end
        end
        ngrid = 2*round((right - left) / delf);
        delf1 = (right - left) / (ngrid-1);
        if (ngrid <= 1 && (right-left) < eps)
            % One grid point
            grid = [grid 0.5*(left+right)];
        elseif (ngrid < 3*lgrid)
            % Not many grid points in the band, so
            % increase density for accuracy and robustness
            ngrid = 3*lgrid;
            delf1 = (right - left) / (ngrid-1);
            grid = [grid left:delf1:right];
            grid(end) = right;
        elseif (i == 1)
            % Normal spacing
            stop = right - lgrid*(2*delf1);
            grid = [grid left:2*delf1:stop];
            % Narrow spacing
            grid = [grid(1:end-1) grid(end):delf1:right+eps];
            grid(end) = right;
        elseif (i == nbands)
            % Narrow spacing
            stop = left + lgrid*(2*delf1);
            grid = [grid left:delf1:stop;];
            % Normal spacing
            grid = [grid(1:end-1) grid(end):2*delf1:right+eps];
            grid(end) = right;
        else
            % Narrow spacing
            stop = left + lgrid*(1.3*delf1);
            grid = [grid left:delf1:stop];
            % Normal spacing
            stop = right - lgrid*(1.3*delf1);
            grid = [grid(1:end-1) grid(end):2*delf1:stop];
            % Narrow spacing
            grid = [grid(1:end-1) grid(end):delf1:right+eps];
            grid(end) = right;
        end
    end
end

% If the filter has odd symmetry, the value at f=0
% is constrained to be zero and the first grid point
% must not be at zero.
if (ftype == 3 || ftype == 4) && (grid(1) < delf)
    grid = grid(2:end);
end
% If the filter has even length, the value at f=1
% is constrained to be zero and the last grid
% point must not be at 1.0.
if (ftype == 2 || ftype == 3) && grid(end) > (1 - delf)
    grid = grid(1:end-1);
end


% [EOF]

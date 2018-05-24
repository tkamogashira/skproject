function [DH,DW,WX,F,FE,devs,constr,erridx,LB,UB,ERRNO] = ...
    genhp(N, F, FE, GF, W, WP, minPh, minOrd, slope, p1, p2,slopepass,oneoverfdecay) %#ok<*INUSL>
%GENHP Generalized highpass frequency response function for FIRGR.
%   GENHP is frequency response function (FRF) that can be used for basic
%   equiripple highpass designs as well as sloped highpass and inverse-sinc
%   highpass. Moreover, minorder and minphase designs are enabled. Note that
%   for minorder designs, an initially guess of the order must be provided
%   since the formulas for guessing the minorder (firpmord) do not handle
%   sloped/inv-sinc cases.
%
%   Usage:
%   The general usage is of the form
%   b = firgr(N,F,{'genhp',slope,p1,p2},W);
%   where N, F, and W are the usual order, frequency vector, and weight
%   vector inputs for highpass design. Note that F must be of length 4 and W
%   of length 2. Same as with FIRGR, if minorder is used, W becomes a
%   vector of maximum ripples allowed:
%   b = firgr({'minorder',initord},F,{'genhp',slope,p1,p2},[Rstop Rpass]);
%
%   The extra parameters that can be given are the stopband slope (in dB),
%   the frequency factor and the inv-sinc power. These parameters mimic
%   those in FIRCEQRIP. See the help for FIRCEQRIP for further description.
%
%   The remaining inputs/outputs are the same as in PRIVATE/FIRPMFRF2, see
%   that function for a description.
%
%   Copyright 2011 The MathWorks, Inc.


% Support query by FIRPM for the default symmetry option:
if nargin==2,
    % Return symmetry default:
    if strcmp(N,'defaults'),
        DH = 'even';   % can be 'even' or 'odd'
        return
    end
end

% Default the stopband slope to 0 (equiripple)
if nargin < 9,
    slope = 0;
end

if nargin < 10,
    p1 = 0.5;
end

% Default the sinc power to zero, i.e. flat passband
if nargin < 11,
    p2 = 0;
end

if nargin < 12,
  % genhp does not implement the slopepass option
    slopepass = false; %#ok<NASGU>
end

if nargin < 13,
    oneoverfdecay = false;
end

[WX,constr,erridx] = parse_firgrweights(W, WP);
devs = zeros(2,1);

if minPh
    LB = zeros(length(GF), 1);
else
    LB = [];
end
UB = [];

% Determine deltay from slope
deltax = F(2)-F(1);
deltay = slope*deltax;

% There are only two bands
DH = zeros(size(GF)); % Preallocate
DW = W(1)*ones(size(DH));

% Set passband/stopband gain/weights
for band = 1:2,

    % Select grid in band
    sel = find( GF>=F(2*band-1) & GF<=F(2*band));

    ERRNO(sel) = erridx(band); %#ok<*AGROW>

    if band == 2
        %------- Insert isinc passband----
        DH(sel) = 1./sinc(p1*(1-GF(sel))).^p2;        
        DW(sel) = WX(band);        
    else
        %%% Don't alter DH, stopband is zero
        fstopindx = find(GF==F(2));
        
        if oneoverfdecay
            % (1/f).^slope stopband                        
            DW(sel) = WX(band).*(((1-GF(sel))/(1-GF(fstopindx))).^slope);
        elseif ~isempty(fstopindx)
            % Weight must decrease exponentially for linear dB slope
            DW(sel) = WX(band).*10.^(linspace(deltay/20,0,fstopindx));
        end
    end

    if minOrd,
        DW(sel) = DW(sel)/WX(band)^2;
        devs(band) = WX(band);
        % Change the relative constrained error magnitude into an error weight
        WX(band) = 1.0 / WX(band);
    end
end


if minPh
    % For minimum phase, the lower bound must be non-negative
    k = LB < 0.0;
    LB(k) = 0.0;
end






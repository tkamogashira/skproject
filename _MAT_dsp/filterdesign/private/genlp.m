function [DH,DW,WX,F,FE,devs,constr,erridx,LB,UB,ERRNO] = ...
    genlp(N, F, FE, GF, W, WP, minPh, minOrd, slope, p1, p2,...
    slopepass,oneoverfdecay, RCF)
%GENLP Generalized lowpass frequency response function for FIRGR.
%   GENLP is frequency response function (FRF) that can be used for basic
%   equiripple lowpass designs as well as sloped lowpass and inverse-sinc
%   lowpass. Moreover, minorder and minphase designs are enabled. Note that
%   for minorder designs, an initially guess of the order must be provided
%   since the formulas for guessing the minorder (firpmord) do not handle
%   sloped/inv-sinc cases. When rate change factor intput, RCF, is not
%   equal to 1, then this function implements an inverse Dirichlet sinc
%   instead of an inverse sinc response in the passband. The default value
%   for RCF is 1.
%
%   Usage:
%   The general usage is of the form
%   b = firgr(N,F,{'genlp',slope,p1,p2},W);
%   where N, F, and W are the usual order, frequency vector, and weight
%   vector inputs for lowpass design. Note that F must be of length 4 and W
%   of length 2. Same as with FIRGR, if minorder is used, W becomes a
%   vector of maximum ripples allowed:
%   b = firgr({'minorder',initord},F,{'genlp',slope,p1,p2},[Rpass Rstop]);
%
%   The extra parameters that can be given are the stopband slope (in dB),
%   the frequency factor and the inv-sinc power. These parameters mimic
%   those in FIRCEQRIP. See the help for FIRCEQRIP for further description.
%
%   The remaining inputs/outputs are the same as in PRIVATE/FIRPMFRF2, see
%   that function for a description.
%
%   Example 1. Basic lowpass design
%   (same as firgr(50,[0 .4 .5 1],[1 1 0 0],[1 10]);:
%   b = firgr(50,[0 .4 .5 1],{'genlp'},[1 10]);
%
%   Example 2. Sloped lowpass design:
%   b = firgr(50,[0 .3 .35 1],{'genlp',10},[1 10]); % slope of 10
%
%   Example 3. Minorder inv-sinc design:
%   b = firgr({'minorder',50},[0 .45 .5 1],{'genlp',0,0.5,1},[.1, .01]);
%
%   Example 4. Minorder, minphase, sloped, inv-sinc design:
%   b = firgr({'minorder',50},[0 .4 .44 1],{'genlp',60,0.4,5},[.1, .01],'minphase');

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.


% Support query by FIRPM for the default symmetry option:
if nargin==2
    % Return symmetry default:
    if strcmp(N,'defaults'),
        DH = 'even';   % can be 'even' or 'odd'
        return
    end
end

% Default the stopband slope to 0 (equiripple)
if nargin < 9
    slope = 0;
end

if nargin < 10
    p1 = 0.5;
end

% Default the sinc power to zero, i.e. flat passband
if nargin < 11
    p2 = 0;
end

if nargin < 12
    slopepass = false;
end

if nargin < 13
    oneoverfdecay = false;
end

if nargin < 14
    RCF = 1;
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
deltax = F(4)-F(3);
deltay = slope*deltax;

% There are only two bands
DH = zeros(size(GF)); % Preallocate
DW = W(1)*ones(size(DH));

% Set passband/stopband gain/weights
for band = 1:2,

    % Select grid in band
    sel = find( GF>=F(2*band-1) & GF<=F(2*band));

    ERRNO(sel) = erridx(band);

    if band == 1,
        if RCF == 1
          fpassindx = find(GF==F(2));
          %------- Insert isinc passband----          
          DH(sel) = 1./sinc(p1*GF(sel)).^p2;          
        else
          %------- Insert Dirichlet isinc passband----  
          % p1 is the differential delay of the CIC filter divided by 2
          diffDelay = p1*2;
          x = GF(sel)*pi;
          y = ones(size(x));
          i = find(x & sin(x));  
          y(i) = RCF*diffDelay * sin(x(i)/(2*RCF))./sin(diffDelay*x(i)/2);          
          DH(sel) = (y).^p2;                  
        end

        if slopepass,
            DW(sel) = WX(band).*10.^(linspace(deltay/20,0,fpassindx));
        else
            DW(sel) = WX(band);
        end
    else
        %%% Don't alter DH, stopband is zero
        fstopindx = find(GF==F(3));
        
        if oneoverfdecay,
            % (1/f).^slope stopband
            DW(sel) = WX(band).*((GF(sel)/GF(fstopindx)).^slope);
        elseif ~isempty(fstopindx)
            % Weight must increase exponentially for linear dB slope
            DW(sel) = WX(band).*10.^(linspace(0,deltay/20,length(GF)-fstopindx+1));
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
    k = find(LB < 0.0);
    LB(k) = 0.0;
end






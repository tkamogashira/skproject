function varargout = actualdesign(this, hs, varargin)
%ACTUALDESIGN   Perform the actual design.

%   Author(s): R. Losada
%   Copyright 2005-2010 The MathWorks, Inc.

Dstop  = convertmagunits(hs.Astop,'db','linear','stop');
Dev    = [Dstop, Dstop];
B      = hs.Band;
TW     = hs.TransitionWidth;
Fedges = [1/B-TW/2, 1/B+TW/2];
Aedges = [1 0];
rcf    = this.rcf; % Rate change factor
nstages = this.NStages;
filtstruct = this.FilterStructure;
if strcmpi(filtstruct,'dffir'),
    filtstruct = 'firdecim';
end

initrcf = rcf;
rcf = abs(rcf); % Negative rcf means decimation
if rcf == 1,
    error(message('dsp:fdfmethod:multistagenyq:actualdesign:FilterErr'));
end

if isprime(rcf),
    % Rate-change is prime, cannot do multistage
    s = warning('off');
    args = {rcf,'nyquist',hs.band,hs.TransitionWidth,hs.Astop};
    if initrcf < 0,
        f = fdesign.decimator(args{:});
    else
        f = fdesign.interpolator(args{:});
    end
    try,
        hc = equiripple(f);
    catch,
        hc = kaiserwin(f);
    end
else

    % Single-stage

    % Determine order estimate for single-section case
    N = firpmord(Fedges,Aedges,Dev);

    c(1,:) = [(N+1)./rcf];


    hin = [];
    Fstop = Fedges(2);

    for k = 1:length(rcf),
        n = 2;
        ufcost = 0;
        tempFedges = Fedges;
        done = false;
        while ~done,
            [c(n,k),ufcost,uf(n-1,k),tempFedges,rcf(k)] = ...
                minstagecost(this,N,tempFedges,Fstop,Aedges,Dev,rcf(k),ufcost);
            n = n+1;
            if isprime(rcf(k)) || rcf(k)==1,
                done = true;
            end
        end
    end

    c(c==0)=inf;

    if strcmpi(nstages,'auto'),
        [minvals,minx] = min(c);
        [minval, miny] = min(minvals);
        nstages = minx(miny);
    else
        % Verify that the requested number of stages is valid
        maxnstages = size(c,1);
        nstagesfact = 1;
        if initrcf == 0,
            if rem(nstages,2),
                error(message('dsp:fdfmethod:multistagenyq:actualdesign:MustBeEven'));
            end
            nstages = nstages/2;
            nstagesfact = 2;
        end
        if nstages > maxnstages,
            error(message('dsp:fdfmethod:multistagenyq:actualdesign:InvalidNumStages', maxnstages*nstagesfact));            
        end
        [minval, miny] = min(c(nstages,:));
    end

    designinterp = true;
    if initrcf < 0,
        designinterp = false;
        initrcf = abs(initrcf);
    end

    s = warning('off');
    hc = ...
        computefilters(this,initrcf,uf,nstages,Fedges,Fstop,Dev,designinterp,filtstruct,B);
end

varargout{1} = {hc};

warning(s);

%--------------------------------------------------------------------------
function hc = ...
    computefilters(this,rcf,uf,nstages,Fedges,Fstop,Dev,designinterp,filtstruct,B)

for n = 1:nstages - 1,
    % Find all factors of rcf
    fctrs = factors(this,rcf);

    k = uf(n);

    % Design filter
    newrcf    = max(gcd(k,fctrs));
    rcf1 = rcf/newrcf;
    TW = 2*min(abs(1/rcf1-k*Fedges));
    args = {rcf1,'nyquist',rcf1,TW,Dev(2),'linear'};
    if designinterp,
        f = fdesign.interpolator(args{:});
        if rcf1 == 2,
            h(nstages-(n-1)) = feval(this.HalfbandDesignMethod,f);
        else
            try,
                h(nstages-(n-1)) = equiripple(f);
            catch
                h(nstages-(n-1)) = kaiserwin(f);
            end
        end
    else
        f = fdesign.decimator(args{:});
        if rcf1 == 2,
            if any(strcmpi(this.HalfbandDesignMethod,{'equiripple','kaiserwin'})),
                designargs = {'filterstructure',filtstruct};
            else
                designargs = {};
            end
            h(nstages-(n-1)) = feval(this.HalfbandDesignMethod,f,designargs{:});
        else
            try,
                h(nstages-(n-1)) = equiripple(f,'filterstructure',filtstruct);
            catch,
                h(nstages-(n-1)) = kaiserwin(f,'filterstructure',filtstruct);
            end
        end
    end
    rcf = newrcf;
    Fedges = [Fedges(1) 2/k-Fstop];
end

TW = 2*min(abs(1/rcf-Fedges));
args = {rcf,'nyquist',rcf,TW,Dev(2),'linear'};
if designinterp,
    f = fdesign.interpolator(args{:});
    if rcf == 2,
        h(1) = feval(this.HalfbandDesignMethod,f);
    else
        try,
            h(1) = equiripple(f);
        catch,
            h(1) = kaiserwin(f);
        end
    end
else
    f = fdesign.decimator(args{:});
    if rcf == 2,
        if any(strcmpi(this.HalfbandDesignMethod,{'equiripple','kaiserwin'})),
            designargs = {'filterstructure',filtstruct};
        else
            designargs = {};
        end
        h(1) = feval(this.HalfbandDesignMethod,f,designargs{:});
    else
        try,
            h(1) = equiripple(f,'filterstructure',filtstruct);
        catch
            h(1) = kaiserwin(f,'filterstructure',filtstruct);
        end
    end
end

if designinterp,
    h = fliplr(h);
end

hc = cascade(h);

%--------------------------------------------------------------------------

function [msc,ufcost,uf,newFedges,newrcf] = ...
    minstagecost(this,N,Fedges,Fstop,Aedges,Dev,rcf,ufcost)

% Determine maximum possible upsampling factor
maxufact = floor((1-eps)/Fedges(2));

% Initialize cost matrix
cm = zeros(maxufact,2);

% Start filling in the matrix. Columns are as follows:
%    [interpolatingcost, upsampledcost]

cm(1,:) = [inf,inf];

% Find all factors of rcf
fctrs = factors(this,rcf);

for k = 2:maxufact,

    % Find simple number of multipliers
    if  k == 2 && k*Fedges(2) > .5,
        Fp = .5 - min(abs(.5-k*Fedges));
        Nus = ceil(1/2*firpmord([Fp,1-Fp],Aedges,Dev));
    else,
        Nus = firpmord(k*Fedges,Aedges,[Dev(1)./2 Dev(2)]); % upsampled filter order
    end
    if  k == 2 && 2/k-Fstop > .5 && rcf == 4,
        % Last stage can be a halfband
        Fp = .5 - min(abs(.5-[Fedges(1), 2/k-Fstop]));
        Nis = max(3,ceil(1/2*firpmord([Fp,1-Fp],Aedges,Dev)));
    else
        Nis = max(3,...
            firpmord([Fedges(1) 2/k-Fstop],Aedges,Dev)); % image suppressor filter order
    end

    % Determine cost
    rcf1   = max(gcd(k,fctrs));
    cm(k,:)  = [(Nis+1)/rcf1,(Nus+1)/rcf];
end

[msc,uf]  = min(sum(cm,2));
msc       = msc + ufcost;
ufcost    = ufcost + cm(uf,2);
newFedges = [Fedges(1) 2/uf-Fstop];
newrcf    = max(gcd(uf,fctrs));



% [EOF]

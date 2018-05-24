function varargout = actualdesign(this, hs, varargin)
%ACTUALDESIGN   Perform the actual design.

%   Copyright 2008 The MathWorks, Inc.

Dpass  = convertmagunits(hs.Apass,'db','linear','pass');
Dstop  = convertmagunits(hs.Astop,'db','linear','stop');
Dev    = [Dpass, Dstop];
Fedges = [hs.Fpass, hs.Fstop];
Aedges = [1 0];
rcf    = this.rcf; % Rate change factor
nstages = this.NStages;
UseHalfbands = this.UseHalfbands;
filtstruct = this.FilterStructure;
if strcmpi(filtstruct,'firinterp'),
    filtstruct = 'firdecim';
end


% Determine order estimate for single-section case
N = firpmord(Fedges,Aedges,Dev);
dosinglestage = true;

initrcf = rcf;
rcf = abs(rcf); % Negative rcf means decimation

% If rate-change factor is one, maintain overall rate from input to output
% by designing decimators followed by interpolators
if rcf == 1,

    % Passband ripple is split in half since it will be shared by
    % interpolation/decimation stages
    Dev(1) = Dev(1)/2;

    % Determine order estimate for two-section case
    N2 = firpmord(Fedges,Aedges,Dev);

    % Determine maximum possible rate-change factor 
    maxrcf = floor((1-eps)/Fedges(2));

    % Set up cost matrix, the row index is the number of stages, the column
    % index is the rate-change factor
    c = zeros(1,maxrcf);

    % Setup rcf vector
    rcf = 1:maxrcf;

    % Setup cost vector two-section case (one decimator, one interpolator)
    N = [N, 2*N2*ones(1,length(rcf)-1)];

    % If two stages are requested, adjust the cost of the single-rate case
    if isnumeric(nstages) && nstages == 2,
        N(1) = 2*firpmord(Fedges,Aedges,[Dev(1), sqrt(Dev(2))]);
        dosinglestage = false;
    end
end

% Fill in cost for single-stage design. Note that if the rate-change factor
% is not equal to 1, c will grow to be a column vector, each row being the
% cost associated with the number of stages, which is the row index.
c(1,:) = (N+1)./rcf;
uf = 1;
Fstop = Fedges(2);

for k = 1:length(rcf),
    n = 2;
    ufcost = 0;
    tempFedges = Fedges;
    done = false;
    while ~done,
        % Determine maximum possible upsampling factor
        maxufact = floor((1-eps)/tempFedges(2));
        if maxufact>1,
            [c(n,k),ufcost,uf(n-1,k),tempFedges,rcf(k)] = ...
                minstagecost(this,maxufact,N,tempFedges,Fstop,Aedges,Dev,rcf(k),ufcost,UseHalfbands);
            n = n+1;
            if isprime(rcf(k)) || rcf(k)==1,
                done = true;
            end
        else,
            done = true;
        end
    end
end

c(c==0)=inf;

% Duplicate the cost for more than one stage if we want to maintain the
% overall rate from input to output because of the cost of the
% interpolation section
if initrcf == 1,
    c(2:end,:)= 2*c(2:end,:);
end

nstagesfact = 1;
if ~isnumeric(nstages) && strcmpi(nstages,'auto'),
    % Determine the optimal number of stages
    [minvals,minx] = min(c);
    [~, miny] = min(minvals);
    nstages = minx(miny);
else
    % Verify that the requested number of stages is valid
    maxnstages = size(c,1);
    if initrcf == 1,
        if rem(nstages,2),
            error(message('dsp:fdfmethod:multistage:actualdesign:MustBeEven'));
        end
        nstages = nstages/2;
        nstagesfact = 2;
    end
    if nstages > maxnstages,
        error(message('dsp:fdfmethod:multistage:actualdesign:InvalidNumStages', maxnstages*nstagesfact));
    end
    [~, miny] = min(c(nstages,:));
end

if nstagesfact*nstages == 1 && initrcf == 1 && miny == 1 && dosinglestage,
    % Single-stage design
    hc = equiripple(hs,'UniformGrid',false);
else
    % Multistage design
    singlerate = false;
    designinterp = true;
    if initrcf == 1,
        initrcf = miny;
        uf = uf(:,miny);
        singlerate = true;
        designinterp = false;
    elseif initrcf < 0,
        designinterp = false;
        initrcf = abs(initrcf);
    end

    hc = ...
        computefilters(this,initrcf,uf,nstages,Fedges,Fstop,Dev,designinterp,singlerate,filtstruct,UseHalfbands);
end

varargout{1} = {hc};

%--------------------------------------------------------------------------
function hc = ...
    computefilters(this,rcf,uf,nstages,Fedges,Fstop,Dev,designinterp,singlerate,filtstruct,UseHalfbands)

for n = 1:nstages - 1,
    % Design all stages except for first

    % Find all factors of rcf
    fctrs = factors(this,rcf);

    k = uf(n);

    % Design filter
    newrcf    = max(gcd(k,fctrs));
    rcf1 = rcf/newrcf;
    if UseHalfbands && rcf1 == 2 && k*Fedges(1) < 0.5 ...
            && (n > 1 || norm(sum(.5-k*Fedges)) < 1e-3),
        % Last stage should not be a halfband unless the specs match a
        % halfband very closely
        TW = 2*min(abs(.5-k*Fedges));
        newDev = min([Dev(1)./2 Dev(2)]);
        args = {rcf1,'halfband',TW,newDev,'linear'};
    else
        args = {rcf1,'lowpass',k*Fedges(1),k*Fedges(2),Dev(1)./2,Dev(2),'linear'};
    end
    if designinterp,
        f = fdesign.interpolator(args{:});
        if strcmpi(args{2},'halfband'),
            h(nstages-(n-1)) = feval(this.HalfbandDesignMethod,f);
        else
            h(nstages-(n-1)) = equiripple(f,'UniformGrid',false);
        end
    else
        f = fdesign.decimator(args{:});
        if strcmpi(args{2},'halfband'),
            if any(strcmpi(this.HalfbandDesignMethod,{'equiripple','kaiserwin'})),
                designargs = {'filterstructure',filtstruct};
            else
                designargs = {};
            end
            h(nstages-(n-1)) = feval(this.HalfbandDesignMethod,f,designargs{:});
        else
            h(nstages-(n-1)) = equiripple(f,'filterstructure',filtstruct,'UniformGrid',false);
        end
    end
    if singlerate,
        h(n+nstages) = constrinterp(h(nstages-(n-1)),rcf1);
    end
    rcf = newrcf;
    Fedges = [Fedges(1) 2/k-Fstop];
    Dev = [Dev(1)./2 Dev(2)];
end

% Now design the first stage
if UseHalfbands && rcf == 2 && Fedges(1) < 0.5 && ...
        (nstages > 1 || norm(sum(.5-Fedges)) < 1e-3),
    TW = 2*min(abs(.5-Fedges));
    newDev = min(Dev);
    args = {rcf,'halfband',TW,newDev,'linear'};
else
    args = {rcf,'lowpass',Fedges(1),Fedges(2),Dev(1),Dev(2),'linear'};
end
if designinterp,
    f = fdesign.interpolator(args{:});
    if strcmpi(args{2},'halfband'),
        h(1) = feval(this.HalfbandDesignMethod,f);
    else
        h(1) = equiripple(f,'UniformGrid',false);
    end
else
    f = fdesign.decimator(args{:});
    if strcmpi(args{2},'halfband'),
        if any(strcmpi(this.HalfbandDesignMethod,{'equiripple','kaiserwin'})),
            designargs = {'filterstructure',filtstruct};
        else
            designargs = {};
        end
        h(1) = feval(this.HalfbandDesignMethod,f,designargs{:});
    else
        h(1) = equiripple(f,'filterstructure',filtstruct,'UniformGrid',false);
    end
end
if singlerate,
    h(2*nstages) = constrinterp(h(1),rcf);
end

if designinterp,
    h = fliplr(h);
end

if length(h) > 1,
    hc = cascade(h);
else
    hc = h;
end

%--------------------------------------------------------------------------

function [msc,ufcost,uf,newFedges,newrcf] = ...
    minstagecost(this,maxufact,N,Fedges,Fstop,Aedges,Dev,rcf,ufcost,UseHalfbands)

% Initialize cost matrix
cm = zeros(maxufact,2);

% Start filling in the matrix. Columns are as follows:
%    [interpolatingcost, upsampledcost]

cm(1,:) = [inf,inf];

% Find all factors of rcf
fctrs = factors(this,rcf);

for k = 2:maxufact, 
    
    % Find simple number of multipliers
    Nus = firpmord(k*Fedges,Aedges,[Dev(1)./2 Dev(2)]); % upsampled filter order
    Nis = max(3,...
        firpmord([Fedges(1) 2/k-Fstop],Aedges,[Dev(1)./2 Dev(2)])); % image suppressor filter order

    % Determine cost
    rcf1   = max(gcd(k,fctrs));
    cm(k,:)  = [(Nis+1)/rcf1,(Nus+1)/rcf];
end

[msc,uf]  = min(sum(cm,2));
msc       = msc + ufcost;
ufcost    = ufcost + cm(uf,2);
newFedges = [Fedges(1) 2/uf-Fstop];
newrcf    = max(gcd(uf,fctrs));

%--------------------------------------------------------------------------
function hi = constrinterp(h,rcf)

indx = find(strcmpi(class(h),...
    {'mfilt.iirdecim','mfilt.iirwdfdecim'}));
if isempty(indx),
    % Regular FIR decimator
    f  = getfdesign(h);
    m  = getfmethod(h);
    if strcmpi(f.Response,'Lowpass')
        hf = fdesign.interpolator(f.DecimationFactor,f.Response,f.Specification,...
            f.Fpass,f.Fstop,f.Apass,f.Astop);
    else
        % Halfband
        hf = fdesign.interpolator(f.DecimationFactor,f.Response,f.Specification,...
            f.TransitionWidth,f.Astop);
    end
    hi = mfilt.firinterp(rcf,rcf*h.Numerator);
    setfdesign(hi,hf); 
    setfmethod(hi,m); 
elseif indx == 1,
    cs  = struct2cell(h.Polyphase.Phase1);
    cs2 = struct2cell(h.Polyphase.Phase2);
    hi = mfilt.iirinterp({cs{:}},{cs2{:}});
elseif indx == 2,
    cs  = struct2cell(h.Polyphase.Phase1);
    cs2 = struct2cell(h.Polyphase.Phase2);
    hi = mfilt.iirwdfinterp({cs{:}},{cs2{:}});
end

% [EOF]

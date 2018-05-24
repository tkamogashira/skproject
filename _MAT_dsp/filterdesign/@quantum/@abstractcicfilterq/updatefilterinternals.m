function updatefilterinternals(this,N,R,D)
%UPDATEFILTERINTERNALS

%   Copyright 2005-2011 The MathWorks, Inc.

inwl = this.InputWordLength;
infl = this.InputFracLength;
outwl = this.privOutputWordLength;
wl = this.privSectionWordLengths;
filterInternals = this.FilterInternals;
if length(wl)~=2*N
    if strcmpi(filterInternals, 'specifyprecision') 
        warning(message('dsp:quantum:abstractcicfilterq:updatefilterinternals:FLReset'));
    elseif strcmpi(filterInternals, 'specifywordlengths'),
        warning(message('dsp:quantum:abstractcicfilterq:updatefilterinternals:WLReset'));
    end
    filterInternals = 'FullPrecision';
    wl = zeros(1,2*N);
end
    
if ~strcmpi(filterInternals, 'specifyprecision'),
    % Set wordlengths and fractionlengths appropriately
    if ~isempty(N),
        fcnhndl = ufifcnhndl(this);
        [wl,fl,outwl,outfl] = feval(fcnhndl,inwl,infl, filterInternals, N, R, D,outwl,wl);
        this.privOutputWordLength = outwl;
        this.privSectionWordLengths = wl;
        this.privOutputFracLength = outfl;
        this.privSectionFracLengths = fl;
    end
end

% [EOF]

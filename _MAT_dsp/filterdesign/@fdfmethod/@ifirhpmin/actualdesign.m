function varargout = actualdesign(this, hs, varargin)
%ACTUALDESIGN   Perform the actual design.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

Dpass  = convertmagunits(hs.Apass,'db','linear','pass');
Dstop  = convertmagunits(hs.Astop,'db','linear','stop');
Dev    = [Dstop, Dpass];
Fedges = [hs.Fstop, hs.Fpass];
Aedges = [0 1];
F      = [0 Fedges 1];
A      = [0 Aedges 1];
rcf    = this.rcf; % Rate change factor

if strcmpi(this.UpsamplingFactor,'auto'),
    cm = determineufactor(this,fliplr(1-Fedges),fliplr(Aedges),...
        fliplr(Dev),rcf);
    Hd = ifirdesign(this,hs,cm);
    varargout{1} = {Hd};
elseif length(varargin) == 0,
    Hd = ifirdesign(this,hs);
    varargout{1} = {Hd};
else

    if this.UpsamplingFactor == 1,
        h1 = firgr('minorder',F,A,Dev);
        h2 = firgr('minorder',F,A,Dev,'h');
        if length(h1) < length(h2),
            h = h1;
        else
            h = h2;
        end
        g = [];
        d = [];
    else
        [h,g,d]=ifir(this.UpsamplingFactor,'high',Fedges,Dev,varargin{:});
    end

    varargout{1} = {h,g,d};
end
varargout{2} = this.UpsamplingFactor;



% [EOF]

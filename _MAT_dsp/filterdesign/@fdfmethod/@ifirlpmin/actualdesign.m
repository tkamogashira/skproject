function varargout = actualdesign(this, hs, varargin)
%ACTUALDESIGN   Perform the actual design.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

Dpass  = convertmagunits(hs.Apass,'db','linear','pass');
Dstop  = convertmagunits(hs.Astop,'db','linear','stop');
Dev    = [Dpass, Dstop];
Fedges = [hs.Fpass, hs.Fstop];
Aedges = [1 0];
F      = [0 Fedges 1];
A      = [1 Aedges 0];
rcf    = this.rcf; % Rate change factor

if strcmpi(this.UpsamplingFactor,'auto'),
    % Determine best upsampling factor and design
    cm = determineufactor(this,Fedges,Aedges,Dev,rcf);
    Hd = ifirdesign(this,hs,cm);
    varargout{1} = {Hd};
elseif length(varargin) == 0,
    % Design for the given upsampling factor
    Hd = ifirdesign(this,hs);
    varargout{1} = {Hd};
else
    % Call functional form of ifir with appropriate 'advanced' or 'simple'
    % flag
    if this.UpsamplingFactor == 1,
        h = firgr('minorder',F,A,Dev);
        g = [];
        d = [];
    else
        [h,g,d] = ifir(this.UpsamplingFactor,'low',Fedges,Dev,varargin{:});
    end

    varargout{1} = {h,g,d};
end
varargout{2} = this.UpsamplingFactor;

% [EOF]

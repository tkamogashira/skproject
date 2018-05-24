function varargout = drawmask(this, varargin)
%DRAWMASK   Draw the mask for the filter specifications.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

hd = getfdesign(this);

if isempty(hd)
    warning(message('dsp:mfilt:abstractcic:drawmask:GUIErr'));
    return;
end

% Make sure that we scale the mask if the filter has any interpolation.
if nargin > 1 && strcmpi(varargin{end}, 'normalize')
    scalefactor   = 1;
    varargin(end) = [];
else
    scalefactor = nominalgain(this);
end

hm = getfmethod(this);

[x, y, h, fcns] = drawmask(hd, hm, varargin{:});

if scalefactor ~= 1

    ydata = get(h, 'YData');
    switch lower(fcns.getunits())
        case 'db'
            ydata = ydata+db(scalefactor);
        case 'squared'
            ydata = ydata*scalefactor^2;
        otherwise
            ydata = ydata*scalefactor;
    end

    set(h, 'YData', ydata);
end

if nargout == 2
    varargout = {x,y};
else
    varargout = {h};
end

% [EOF]

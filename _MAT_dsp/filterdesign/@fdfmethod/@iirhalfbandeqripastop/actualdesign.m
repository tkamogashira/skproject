function h = actualdesign(this,hs)
%ACTUALDESIGN

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


% Design Nyquist filters until order is met
f=fdesign.halfband('N,TW',hs.FilterOrder,0.5);

filtstruct = get(this, 'FilterStructure');
desmode = this.DesignMode;

% Try design
[h,notConverging] = iterateOrd(hs,f,filtstruct,desmode);

if notConverging,
    error(message('dsp:fdfmethod:iirhalfbandeqripastop:actualdesign:notConverging'));
end
%--------------------------------------------------------------------------
function [h,notConverging] = iterateOrd(hs,f,filtstruct,desmode)

% Design initial filter
h = design(f,'iirlinphase',...
    'filterstructure',filtstruct,...
    'DesignMode',desmode);
m = measure(h);

count = 0;
maxCount = 40;
notConverging = false;

% Set lower and upper bounds for TW
lowerTW = 0;
upperTW = 1;
while norm(m.Astop - hs.Astop,inf) > 1e-4 && count < maxCount,
    % Use bisection to find the correct TW to yield desired Astop
    if m.Astop > hs.Astop,
        % Decrease TW
        upperTW = f.TransitionWidth;
        f.TransitionWidth = 1/2*(f.TransitionWidth+lowerTW);
    else
        % Increase TW
        lowerTW = f.TransitionWidth;
        f.TransitionWidth = 1/2*(f.TransitionWidth+upperTW);
    end
    h = design(f,'iirlinphase',...
        'filterstructure',filtstruct,...
        'DesignMode',desmode);
    m = measure(h);
    count = count + 1;
end
if count == maxCount,
    notConverging = true;
end



% [EOF]

function delay = quantizefd(this,delay)
%QUANTIZEFD   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

if this.privfdautoscale,
    delay = fi(delay,0,this.privfdwl,'RoundMode', 'round', 'OverflowMode','saturate');
    this.privfdfl = delay.FractionLength;
    updateinternalsettings(this);
else
    delay = fi(delay,0,this.privfdwl,this.privfdfl,'RoundMode', 'round', 'OverflowMode','saturate');
end


% [EOF]

function [vp,Vp] = nlmrescaleinput(this,vp,Vp)
%NLMRESCALEINPUT   
%   Author(s): R. Losada
%   Copyright 1999-2003 The MathWorks, Inc.

% Ensure that inheritSettings is false
% We cannot do this in quantizeinput (even though it would seem like the
% right place) because quantizeinput is not noisepsd (nlm) specific and we
% are changing the dfilt object wit this.
this.InheritSettings = false; % We need this so quantizeinput method works ok

% Determine "onesided" range of input quantizer (i.e. the positive range
% only)
iwl = this.InputWordLength;
ifl = this.InputFracLength;
r = 2^(iwl-ifl-1); % The "-1" is needed for onesided range

vpm = max(max(abs(vp)));
vp = r*vp./vpm;
Vp = fft(vp);
   

% [EOF]

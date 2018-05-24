function xunits_exp = coreSpecVecScopeSlupdate(block)
% Core function used by SLUPDATE mechanism for the Spectrum Scope and the Vector
% Scope when it is in 'Frequency' domain

%   Copyright 2008-2010 The MathWorks, Inc.

block_data = get_param(block, 'UserData');
    
% copied in bits and pieces from sdspfscope2->setup_axes() --- start
if strcmpi(block_data.params.InheritXIncr, 'on')
    % Inherited sample rate:
    if block_data.Ts==-1,
        Fs = block_data.samples_per_frame;  % unusual, but we'll allow it
    else
        Fs = 1 ./ block_data.Ts;  % sample rate
    end
else
    % User-defined sample time for frequency domain:
    Fs = 1 ./ block_data.params.XIncr;  % sample rate
end

Fn = Fs/2;  % Nyquist rate

switch block_data.params.XRange
  case 1,
    xLimits = [0 Fn];
  case 2,
    xLimits = [-Fn Fn];
  otherwise,
    xLimits = [0 Fs];
end
        
if block_data.params.XUnits == 2
    % 'Frequency units' = rad/sec
    xLimits = 2 * pi * xLimits;
end

% Adjust x-axes for engineering units:
% Allow scalar
if xLimits(2)==0,
    xLimits=[0 1];
elseif (xLimits(1) > xLimits(2)),
    xLimits(1:2)=xLimits([2 1]);
end

[xunits_valNotUsed, xunits_exp, xunits_prefixNotUsed] = ...
    engunits(max(abs(xLimits)), 'latex', 'freq'); %#ok

% copied in bits and pieces from sdspfscope2->setup_axes() --- end

% [EOF]

% LocalWords:  sdspfscope

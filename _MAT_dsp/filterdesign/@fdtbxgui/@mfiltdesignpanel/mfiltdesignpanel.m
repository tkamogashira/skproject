function this = mfiltdesignpanel
%MFILTDESIGNPANEL   Construct a MFILTDESIGNPANEL object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

this = fdtbxgui.mfiltdesignpanel;

set(this, 'decimDecimationFactor', 2, ....
    'srcInterpolationFactor', 2, ...
    'srcDecimationFactor', 3);

hs = siggui.selector('', {'current', 'defaultfilter', 'cic', 'hold', 'linear'}, ...
    {'Use current FIR filter', 'Use a default Nyquist FIR filter', 'Cascaded Integrator-Comb (CIC)', ...
    'Hold interpolator (Zero-order)', 'Linear Interpolator (First-order)'});
settag(hs, 'implementation');
set(hs, 'CSHTags', {fullfile('fdatool_mfilt_current', 'dsp'), ...
    fullfile('fdatool_mfilt_default', 'dsp'), ...
    fullfile('fdatool_mfilt_cic', 'dsp'), ...
    fullfile('fdatool_mfilt_hold', 'dsp'), ...
    fullfile('fdatool_mfilt_linear', 'dsp')});
addcomponent(this, hs);

hfs = siggui.fsspecifier;
settag(hfs, 'fs');
addcomponent(this, hfs);

h.interpolation = javax.swing.JSpinner;
h.decimation    = javax.swing.JSpinner;

set(this, 'JavaHandles', h);

updatespinners(this);

set(this, 'Fs', '48000');
set(this, 'FrequencyUnits', 'Hz');

% [EOF]

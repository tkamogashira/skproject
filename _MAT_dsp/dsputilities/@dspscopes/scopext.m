function scopext(ext)
%SCOPEXT  Register scope extensions for DSP System Toolbox.

%   Copyright 2008-2012 The MathWorks, Inc.

uiscopes.addDataHandler(ext, 'Simulink', 'Video', 'scopeextensions.VideoSLHandler');

r = ext.add('Visuals', 'Spectrum', 'scopeextensions.SpectrumVisual', ...
    uiscopes.message('SpectrumDescription'), ...
    uiscopes.message('SpectrumLabel'));
r.Visible = false;

% [EOF]

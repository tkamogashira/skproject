function s = fdaregister
%FDAREGISTER Registers the Filter Design plugin with Filter Design & Analysis Tool (FDATool).

%   Copyright 1999-2010 The MathWorks, Inc.

s.plugin           = {@fdplugin};
s.name             = {'DSP System Toolbox'};
s.version          = {1.0};
if ~isdeployed
    s.licenseavailable = license('test', 'Signal_Blocks');    
end

% [EOF]

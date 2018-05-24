% Create UI to tune simulation parameters of model 
% rlsfiltersystemidentification

% Copyright 2013 The MathWorks, Inc. 

Ts = 1/44.1e3;
L = 1024;

screen = get(0,'ScreenSize');
outerSize = min((screen(4)-40)/2, 512);
param = struct([]);

% Parameter 1 - Filter cutoff frequency
param(1).Name = 'Lowpass Filter Cutoff Frequency (Hz)';
param(1).InitialValue = 5000;
param(1).Limits = 1/(2*Ts) * [1e-4 .9999];
param(1).BlockName = 'RLSFilterSystemIdentification/System Identification/Variable Bandwidth Filter';
param(1).ParameterName = 'CutoffFrequency';

% Parameter 2 - RLS filter forgetting factor
param(2).Name = 'RLS Forgetting Factor';
param(2).InitialValue = 0.99;
param(2).Limits = [.4, 1];
param(2).BlockName = 'RLSFilterSystemIdentification/System Identification/RLS Filter';
param(2).ParameterName = 'lambda';

% Create UI. Clicking reset button calls resetRLSSystemIdentification
hUI = HelperCreateParamTuningUI(param, 'RLS System Identification Example','ResetCallback',@()resetRLSSystemIdentification);
set(hUI,'Position',[outerSize-256, screen(4)-2.2*outerSize, ...
         outerSize+8, outerSize-92]);
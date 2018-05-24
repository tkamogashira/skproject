function dtRows = dspblkGetConstantRampDTRowInfo()
%dspblkGetConstantRampDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Constant Ramp block.

% Copyright 2010 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(1);

dtRows{1}.name               = 'output';
dtRows{1}.defaultUDTStrValue = 'Same as input';
dtRows{1}.builtinTypes       = dspGetUDTBuiltinList('NumBool');
dtRows{1}.inheritInput       = 1;
dtRows{1}.inheritBackProp    = 1;
dtRows{1}.signedSignedness   = 1;
dtRows{1}.unsignedSignedness = 1;
dtRows{1}.bestPrecisionMode  = 1;

% [EOF]

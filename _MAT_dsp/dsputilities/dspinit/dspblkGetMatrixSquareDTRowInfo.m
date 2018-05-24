function dtRows = dspblkGetMatrixSquareDTRowInfo()
%dspblkGetMatrixSquareDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Matrix Square block.

% Copyright 2010 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(1);

dtRows{1}.name                = 'output';
dtRows{1}.defaultUDTStrValue  = 'Inherit via internal rule';
dtRows{1}.builtinTypes        = dspGetUDTBuiltinList('Num');
dtRows{1}.inheritInternalRule = 1;
dtRows{1}.inheritBackProp     = 1;
dtRows{1}.inheritFirstInput   = 1;
dtRows{1}.signedSignedness    = 1;
dtRows{1}.unsignedSignedness  = 1;
dtRows{1}.binaryPointScaling  = 1;
dtRows{1}.hasDesignMin        = 1;
dtRows{1}.hasDesignMax        = 1;

% [EOF]

function dtRows = dspblkGetCorrelationDTRowInfo()
%dspblkGetCorrelationDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Correlation block.

% Copyright 2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(3);

dtRows{1}.name                = 'prodOutput';
dtRows{1}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{1}.inheritFirstInput   = 1;
dtRows{1}.inheritInternalRule = 1;
dtRows{1}.autoSignedness      = 1;
dtRows{1}.signedSignedness    = 0;

dtRows{2}.name                = 'accum';
dtRows{2}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{2}.inheritProdOutput   = 1;
dtRows{2}.inheritFirstInput   = 1;
dtRows{2}.inheritInternalRule = 1;
dtRows{2}.autoSignedness      = 1;
dtRows{2}.signedSignedness    = 0;

dtRows{3}.name                = 'output';
dtRows{3}.defaultUDTStrValue  = 'Inherit: Same as accumulator';
dtRows{3}.inheritAccumulator  = 1;
dtRows{3}.inheritProdOutput   = 1;
dtRows{3}.inheritFirstInput   = 1;
dtRows{3}.autoSignedness      = 1;
dtRows{3}.hasDesignMin        = 1;
dtRows{3}.hasDesignMax        = 1;
dtRows{3}.signedSignedness    = 0;

% [EOF]

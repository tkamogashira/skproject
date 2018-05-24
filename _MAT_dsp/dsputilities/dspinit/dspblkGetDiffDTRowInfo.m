function dtRows = dspblkGetDiffDTRowInfo()
%dspblkGetDiffDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Difference block.

% Copyright 2008-2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(2);

dtRows{1}.name                = 'accum';
dtRows{1}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{1}.inheritInternalRule = 1;
dtRows{1}.inheritInput        = 1;
dtRows{1}.autoSignedness      = 1;
dtRows{1}.signedSignedness    = 0;

dtRows{2}.name                = 'output';
dtRows{2}.defaultUDTStrValue  = 'Inherit: Same as accumulator';
dtRows{2}.inheritAccumulator  = 1;
dtRows{2}.inheritInput        = 1;
dtRows{2}.autoSignedness      = 1;
dtRows{2}.signedSignedness    = 0;
dtRows{2}.hasDesignMin        = 1;
dtRows{2}.hasDesignMax        = 1;

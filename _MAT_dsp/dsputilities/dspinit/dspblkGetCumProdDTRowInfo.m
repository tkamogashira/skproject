function dtRows = dspblkGetCumProdDTRowInfo()
%dspblkGetCumProdDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Cumulative Product block.

% Copyright 2008-2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(4);

dtRows{1}.name               = 'Intermediate product';
dtRows{1}.prefix             = 'interProd';
dtRows{1}.defaultUDTStrValue = 'Inherit: Same as input';
dtRows{1}.inheritInput       = 1;
dtRows{1}.autoSignedness     = 1;
dtRows{1}.signedSignedness   = 0;

dtRows{2}.name               = 'prodOutput';
dtRows{2}.defaultUDTStrValue = 'Inherit: Same as input';
dtRows{2}.inheritInput       = 1;
dtRows{2}.autoSignedness     = 1;
dtRows{2}.signedSignedness   = 0;

dtRows{3}.name               = 'accum';
dtRows{3}.defaultUDTStrValue = 'Inherit: Same as input';
dtRows{3}.inheritProdOutput  = 1;
dtRows{3}.inheritInput       = 1;
dtRows{3}.autoSignedness     = 1;
dtRows{3}.signedSignedness   = 0;

dtRows{4}.name               = 'output';
dtRows{4}.defaultUDTStrValue = 'Inherit: Same as input';
dtRows{4}.inheritProdOutput  = 1;
dtRows{4}.inheritInput       = 1;
dtRows{4}.autoSignedness     = 1;
dtRows{4}.signedSignedness   = 0;
dtRows{4}.hasDesignMin       = 1;
dtRows{4}.hasDesignMax       = 1;

% [EOF]

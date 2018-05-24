function dtRows = dspblkGetArrayVectorAddSubDTRowInfo()
%dspblkGetArrayVectorAddSubDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Array Vector Add and Array Vector Subtract blocks.

% Copyright 2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(3);

dtRows{1}.name                 = 'Vector (V)';
dtRows{1}.prefix               = 'firstCoeff';
dtRows{1}.defaultUDTStrValue   = 'Inherit: Same word length as input';
dtRows{1}.hasDesignMin         = 1;
dtRows{1}.hasDesignMax         = 1;
dtRows{1}.signedSignedness     = 1;
dtRows{1}.inheritSameWLAsInput = 1;
dtRows{1}.hasValBestPrecFLMode = 1;
dtRows{1}.valBestPrecFLMaskPrm = 'V_VectFromMask';

dtRows{2}.name                 = 'accum';
dtRows{2}.defaultUDTStrValue   = 'Inherit: Inherit via internal rule';
dtRows{2}.autoSignedness       = 1;
dtRows{2}.signedSignedness     = 1;
dtRows{2}.inheritInternalRule  = 1;
dtRows{2}.inheritFirstInput    = 1;

dtRows{3}.name                 = 'output';
dtRows{3}.defaultUDTStrValue   = 'Inherit: Same as accumulator';
dtRows{3}.hasDesignMin         = 1;
dtRows{3}.hasDesignMax         = 1;
dtRows{3}.autoSignedness       = 1;
dtRows{3}.signedSignedness     = 1;
dtRows{3}.inheritAccumulator   = 1;
dtRows{3}.inheritFirstInput    = 1;

function dtRows = dspblkGetArrayVectorMpyDTRowInfo()
%dspblkGetArrayVectorMpyDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Array Vector Multiply block.

% Copyright 2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(4);

dtRows{1}.name                 = 'Vector (V)';
dtRows{1}.prefix               = 'firstCoeff';
dtRows{1}.defaultUDTStrValue   = 'Inherit: Same word length as input';
dtRows{1}.hasDesignMin         = 1;
dtRows{1}.hasDesignMax         = 1;
dtRows{1}.signedSignedness     = 1;
dtRows{1}.inheritSameWLAsInput = 1;
dtRows{1}.hasValBestPrecFLMode = 1;
dtRows{1}.valBestPrecFLMaskPrm = 'V_VectFromMask';

dtRows{2}.name                 = 'prodOutput';
dtRows{2}.defaultUDTStrValue   = 'Inherit: Inherit via internal rule';
dtRows{2}.autoSignedness       = 1;
dtRows{2}.signedSignedness     = 1;
dtRows{2}.inheritInternalRule  = 1;
dtRows{2}.inheritFirstInput    = 1;

dtRows{3}.name                 = 'accum';
dtRows{3}.defaultUDTStrValue   = 'Inherit: Inherit via internal rule';
dtRows{3}.autoSignedness       = 1;
dtRows{3}.signedSignedness     = 1;
dtRows{3}.inheritInternalRule  = 1;
dtRows{3}.inheritProdOutput    = 1;
dtRows{3}.inheritFirstInput    = 1;

dtRows{4}.name                 = 'output';
dtRows{4}.defaultUDTStrValue   = 'Inherit: Same as product output';
dtRows{4}.hasDesignMin         = 1;
dtRows{4}.hasDesignMax         = 1;
dtRows{4}.autoSignedness       = 1;
dtRows{4}.signedSignedness     = 1;
dtRows{4}.inheritProdOutput    = 1;
dtRows{4}.inheritFirstInput    = 1;

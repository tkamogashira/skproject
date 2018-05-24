function dtRows = dspblkGetArrayVectorDivDTRowInfo()
%dspblkGetArrayVectorDivDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Array Vector Divide block.

% Copyright 2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(2);

dtRows{1}.name                 = 'Vector (V)';
dtRows{1}.prefix               = 'firstCoeff';
dtRows{1}.defaultUDTStrValue   = 'Inherit: Same word length as input';
dtRows{1}.hasDesignMin         = 1;
dtRows{1}.hasDesignMax         = 1;
dtRows{1}.signedSignedness     = 1;
dtRows{1}.inheritSameWLAsInput = 1;
dtRows{1}.hasValBestPrecFLMode = 1;
dtRows{1}.valBestPrecFLMaskPrm = 'V_VectFromMask';

dtRows{2}.name                = 'output';
dtRows{2}.defaultUDTStrValue  = 'Inherit: Same as first input';
dtRows{2}.hasDesignMin        = 1;
dtRows{2}.hasDesignMax        = 1;
dtRows{2}.autoSignedness      = 1;
dtRows{2}.signedSignedness    = 1;
dtRows{2}.inheritFirstInput   = 1;

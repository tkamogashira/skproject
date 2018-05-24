function dtRows = dspblkGetSQVQDecoderDTRowInfo()
%dspblkGetSQVQDecoderDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Scalar and Vector Quantizer Decoder library blocks.

% Copyright 2010 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(1);

dtRows{1}.name               = 'output';
dtRows{1}.defaultUDTStrValue = 'double';
dtRows{1}.builtinTypes       = dspGetUDTBuiltinList('Float');
dtRows{1}.inheritInput       = 1;
dtRows{1}.inheritBackProp    = 1;
dtRows{1}.signedSignedness   = 1;
dtRows{1}.unsignedSignedness = 1;
dtRows{1}.bestPrecisionMode  = 1;
dtRows{1}.hasDesignMin       = 0; % uses ModelRequiredMin (Codebook Values)
dtRows{1}.hasDesignMax       = 0; % uses ModelRequiredMax (Codebook Values)

% [EOF]

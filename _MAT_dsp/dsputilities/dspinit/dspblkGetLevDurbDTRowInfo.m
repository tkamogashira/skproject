function dtRows = dspblkGetLevDurbDTRowInfo()
%dspblkGetLevDurbDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Levinson-Durbin block.

% Copyright 1995-2012 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(5);

dtRows{1}.name                = 'prodOutput';
dtRows{1}.inheritInput        = 1;
dtRows{1}.signedSignedness    = 1;

dtRows{2}.name                = 'accum';
dtRows{2}.inheritInput        = 1;
dtRows{2}.inheritProdOutput   = 1;
dtRows{2}.signedSignedness    = 1;

dtRows{3}.name                = DAStudio.message('dsp:dspsolvers:polyCoeff_MP');
dtRows{3}.prefix              = 'firstCoeff';
dtRows{3}.signedSignedness    = 1;
dtRows{3}.hasDesignMin        = 1;
dtRows{3}.hasDesignMax        = 1;

dtRows{4}.name                = DAStudio.message('dsp:dspsolvers:reflCoeff_MP');
dtRows{4}.prefix              = 'secondCoeff';
dtRows{4}.signedSignedness    = 1;
dtRows{4}.hasDesignMin        = 1;
dtRows{4}.hasDesignMax        = 1;

dtRows{5}.name                = DAStudio.message('dsp:dspsolvers:predict_MP');
dtRows{5}.prefix              = 'output';
dtRows{5}.inheritInput        = 1;
dtRows{5}.signedSignedness    = 1;
dtRows{5}.hasDesignMin        = 1;
dtRows{5}.hasDesignMax        = 1;

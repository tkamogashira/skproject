function dtRows = dspblkGetFBSubstDTRowInfo()
%dspblkGetFBSubstDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Forward Substitution and Backward Substitution blocks.

% Copyright 1995-2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(3);

dtRows{1}.name                = 'prodOutput';
dtRows{1}.inheritInternalRule = 1;
dtRows{1}.inheritFirstInput   = 1;
dtRows{1}.signedSignedness    = 1;

dtRows{2}.name                = 'accum';
dtRows{2}.inheritInternalRule = 1;
dtRows{2}.inheritFirstInput   = 1;
dtRows{2}.inheritProdOutput   = 1;
dtRows{2}.signedSignedness    = 1;

dtRows{3}.name                = 'output';
dtRows{3}.inheritFirstInput   = 1;
dtRows{3}.signedSignedness    = 1;
dtRows{3}.hasDesignMin        = 1;
dtRows{3}.hasDesignMax        = 1;

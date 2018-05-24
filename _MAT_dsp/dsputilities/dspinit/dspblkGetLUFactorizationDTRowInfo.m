function dtRows = dspblkGetLUFactorizationDTRowInfo()
%dspblkGetLUFactorizationDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the LU Factorization block.

% Copyright 1995-2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(3);

%1=prod; 2= accum; 3=output;
%mdlOrder = [3 2 1];
maskOrder = [1 2 3];
ORDER = maskOrder;%mdlOrder;   %

dtRows{ORDER(1)}.name                = 'prodOutput';
dtRows{ORDER(1)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(1)}.inheritInternalRule = 1;
dtRows{ORDER(1)}.inheritInput        = 1;
dtRows{ORDER(1)}.signedSignedness    = 1;

dtRows{ORDER(2)}.name                = 'accum';
dtRows{ORDER(2)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(2)}.inheritInternalRule = 1;
dtRows{ORDER(2)}.inheritInput        = 1;
dtRows{ORDER(2)}.inheritProdOutput   = 1;
dtRows{ORDER(2)}.signedSignedness    = 1;

dtRows{ORDER(3)}.name                = 'output';
dtRows{ORDER(3)}.defaultUDTStrValue  = 'Inherit: Same as input';
dtRows{ORDER(3)}.inheritInput        = 1;
dtRows{ORDER(3)}.signedSignedness    = 1;
dtRows{ORDER(3)}.hasDesignMin        = 1;
dtRows{ORDER(3)}.hasDesignMax        = 1;

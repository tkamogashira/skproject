function dtRows = dspblkGetLDLFactorizationDTRowInfo()
%dspblkGetLUFactorizationDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the LDL Factorization block.

% Copyright 1995-2009 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(4);

%1=intermediate product; 2=prod; 3= accum; 4=output;
%mdlOrder = [4 3 2 1];
maskOrder = [1 2 3 4];
ORDER = maskOrder;%mdlOrder;   %

dtRows{ORDER(1)}.name                = sprintf('Intermediate\n    product');;
dtRows{ORDER(1)}.prefix              = 'interProd'; 
dtRows{ORDER(1)}.defaultUDTStrValue  = 'Inherit: Same as input';
dtRows{ORDER(1)}.inheritInput        = 1;
dtRows{ORDER(1)}.signedSignedness    = 1;

dtRows{ORDER(2)}.name                = 'prodOutput';
dtRows{ORDER(2)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(2)}.inheritInternalRule = 1;
dtRows{ORDER(2)}.inheritInput        = 1;
dtRows{ORDER(2)}.signedSignedness    = 1;

dtRows{ORDER(3)}.name                = 'accum';
dtRows{ORDER(3)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(3)}.inheritInternalRule = 1;
dtRows{ORDER(3)}.inheritInput        = 1;
dtRows{ORDER(3)}.inheritProdOutput   = 1;
dtRows{ORDER(3)}.signedSignedness    = 1;

dtRows{ORDER(4)}.name                = 'output';
dtRows{ORDER(4)}.defaultUDTStrValue  = 'Inherit: Same as input';
dtRows{ORDER(4)}.inheritInput        = 1;
dtRows{ORDER(4)}.signedSignedness    = 1;
dtRows{ORDER(4)}.hasDesignMin        = 1;
dtRows{ORDER(4)}.hasDesignMax        = 1;

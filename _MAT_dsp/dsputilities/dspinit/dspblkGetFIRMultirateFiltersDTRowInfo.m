function dtRows = dspblkGetFIRMultirateFiltersDTRowInfo()
%dspblkGetFIRMultirateFiltersDTRowInfo
%
%  DSP System Toolbox library block mask helper function used by
%  the FIR Decimation, FIR Interpolation, and FIR Rate Conversion blocks.

% Copyright 1995-2010 The MathWorks, Inc.

dtRows = dspblkGetDefaultDTRowInfo(4);

%1=coeff; 2=prod; 3= accum; 4=output;
%mdlOrder = [1 4 3 2];
maskOrder = [1 2 3 4];
ORDER = maskOrder;%mdlOrder;   %
dtRows{ORDER(1)}.name                 = 'Coefficients';
dtRows{ORDER(1)}.prefix               = 'firstCoeff';
dtRows{ORDER(1)}.defaultUDTStrValue   = 'Inherit: Same word length as input';
dtRows{ORDER(1)}.inheritSameWLAsInput = 1;
dtRows{ORDER(1)}.bestPrecisionMode    = 1;
dtRows{ORDER(1)}.hasValBestPrecFLMode = 1;
dtRows{ORDER(1)}.valBestPrecFLMaskPrm = 'h';
dtRows{ORDER(1)}.hasDesignMin         = 1;
dtRows{ORDER(1)}.hasDesignMax         = 1;
%default value for binaryPointScaling=1, signedSignedness=1;

dtRows{ORDER(2)}.name                = 'prodOutput';
dtRows{ORDER(2)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(2)}.inheritInternalRule = 1;
dtRows{ORDER(2)}.inheritInput        = 1;
%default value for binaryPointScaling=1, signedSignedness=1;

dtRows{ORDER(3)}.name                = 'accum';
dtRows{ORDER(3)}.defaultUDTStrValue  = 'Inherit: Inherit via internal rule';
dtRows{ORDER(3)}.inheritInternalRule = 1;
dtRows{ORDER(3)}.inheritInput        = 1;
dtRows{ORDER(3)}.inheritProdOutput   = 1;
%default value for binaryPointScaling=1, signedSignedness=1;

dtRows{ORDER(4)}.name                = 'output';
dtRows{ORDER(4)}.defaultUDTStrValue  = 'Inherit: Same as accumulator';
dtRows{ORDER(4)}.inheritInput        = 1;
dtRows{ORDER(4)}.inheritProdOutput   = 1;
dtRows{ORDER(4)}.inheritAccumulator  = 1;
dtRows{ORDER(4)}.hasDesignMin        = 1;
dtRows{ORDER(4)}.hasDesignMax        = 1;

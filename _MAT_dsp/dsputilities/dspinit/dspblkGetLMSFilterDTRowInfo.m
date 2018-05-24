function dtInfo = dspblkGetLMSFilterDTRowInfo(blkh)
% dtInfo = dspblkGetLMSFilterDTRowInfo(blkh, ...)
%   Get LMS Filter block fixed-point mask parameter settings
%
%   See also dspGetFixptDataTypeInfo

%  Copyright 2013 The MathWorks, Inc.

obj = get_param(blkh,'object');

% Rounding parameter:
roundingModeStr = {'Ceiling','Convergent','Floor','Nearest','Round','Simplest','Zero'};
dtInfo.roundingMode = strmatch(obj.roundingMode,roundingModeStr); %#ok

% Overflow parameter:
if strcmp(obj.overflowMode, 'off')
    dtInfo.overflowMode = 1; % Wrap
else
    dtInfo.overflowMode = 2; % Saturate
end 

% Fixed-point 'Mode', 'WordLength', 'FracLength' block mask parameters:
dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'firstCoeff');
dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'prodOutput');
dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'accum');
dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'memory');

% -------------------------------------------------------------------------
% Get certain 'Mode' and 'WordLength' settings (these are "same as" others)
% -------------------------------------------------------------------------

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'secondCoeff');
dtInfo.secondCoeffMode       = dtInfo.firstCoeffMode;       % (dependent)
dtInfo.secondCoeffWordLength = dtInfo.firstCoeffWordLength; % (dependent)
dtInfo.secondCoeffFracLength = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'secondCoeffFracLength');

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'prodOutput2');
dtInfo.prodOutput2Mode       = dtInfo.prodOutputMode;       % (dependent)
dtInfo.prodOutput2WordLength = dtInfo.prodOutputWordLength; % (dependent)
dtInfo.prodOutput2FracLength = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'prodOutput2FracLength');

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'prodOutput3');
dtInfo.prodOutput3Mode       = dtInfo.prodOutputMode;       % (dependent)
dtInfo.prodOutput3WordLength = dtInfo.prodOutputWordLength; % (dependent)
dtInfo.prodOutput3FracLength = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'prodOutput3FracLength');

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'prodOutput4');
dtInfo.prodOutput4Mode       = dtInfo.prodOutputMode;       % (dependent)
dtInfo.prodOutput4WordLength = dtInfo.prodOutputWordLength; % (dependent)
dtInfo.prodOutput4FracLength = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'prodOutput4FracLength');

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'quotient');
dtInfo.quotientMode          = dtInfo.prodOutputMode;       % (dependent)
dtInfo.quotientWordLength    = dtInfo.prodOutputWordLength; % (dependent)
dtInfo.quotientFracLength    = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'quotientFracLength');

% dtInfo = dspProcessFixptParamSection(obj, dtInfo, 'accum2');
dtInfo.accum2Mode            = dtInfo.accumMode;            % (dependent)
dtInfo.accum2WordLength      = dtInfo.accumWordLength;      % (dependent)
dtInfo.accum2FracLength      = dspGetEditBoxValFromMaskWSV( ...
    obj.MaskWSVariables, 'accum2FracLength');

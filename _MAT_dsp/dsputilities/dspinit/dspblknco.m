function varargout= dspblknco(AccIncSrc,PhaseOffsetSrc,Formula, ...
                        HasOutputPhaseError,HasPhaseQuantizer)
% DSPBLKNCO DSP System Toolbox NCO block helper function.

% Copyright 1995-2005 The MathWorks, Inc.

% This mask helper function is only used for creating port labels
%

% enum
INPUT_PORT_ENUM = 2;
ON_ENUM         = 1;
SIN_ENUM        = 1;
COS_ENUM        = 2;
EXP_ENUM        = 3;
SINCOS_ENUM     = 4;
SINERR_ENUM     = 5; % sin + phaseError
COSERR_ENUM     = 6; % cos + phaseError
EXPERR_ENUM     = 7; % exp + phaseError
SINCOSERR_ENUM  = 8; % sincos + phaseError

% Input port labels
hasPhaseIncPort    = (AccIncSrc == INPUT_PORT_ENUM);
hasPhaseOffsetPort = (PhaseOffsetSrc == INPUT_PORT_ENUM);

s = '';
if (hasPhaseIncPort && hasPhaseOffsetPort)
    s{1}= 'inc';
    s{2} = 'offset';
elseif (hasPhaseIncPort)
    s{1} = 'inc';
elseif (hasPhaseOffsetPort)
    s{1} = 'offset';
end

% Output port labels
hasQerrPort = (HasOutputPhaseError == ON_ENUM) && ...
              (HasPhaseQuantizer == ON_ENUM);

if (Formula == SIN_ENUM)
    formulaEnumVal = SIN_ENUM;
elseif (Formula == COS_ENUM)
    formulaEnumVal = COS_ENUM;
elseif (Formula == SINCOS_ENUM)
    formulaEnumVal = SINCOS_ENUM;
else
    formulaEnumVal = EXP_ENUM;
end

enumValue = formulaEnumVal + 4*hasQerrPort;

so='';
switch (enumValue)
    case SIN_ENUM
        so{1} = 'sin';
    case COS_ENUM
        so{1} = 'cos';
    case EXP_ENUM
        so{1} = 'exp';
    case SINCOS_ENUM
        so{1} = 'sin';
        so{2} = 'cos';
    case SINERR_ENUM
        so{1} = 'sin';
        so{2} = 'Qerr';
    case COSERR_ENUM
        so{1} = 'cos';
        so{2} = 'Qerr';
    case EXPERR_ENUM
        so{1} = 'exp';
        so{2} = 'Qerr';
    case SINCOSERR_ENUM
        so{1} = 'sin';
        so{2} = 'cos';
        so{3} = 'Qerr';
end

str = ['disp(''NCO'');'];
for i=1:length(s)
str = [str 'port_label(''input'',' num2str(i) ',''' s{i} ''');'];
end
for i=1:length(so)
str = [str 'port_label(''output'',' num2str(i) ',''' so{i} ''');'];
end

varargout = {str};
    
% [EOF] dspblknco.m

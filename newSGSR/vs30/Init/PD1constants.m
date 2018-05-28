function PD1constants;

% PD!constants - initialization of global PD1 struct
% This structure contains the numerical values of
% constants needed for PD1 routing, etc. See PD1 manual.

global PD1;

% delete previous version
PD1 = [];

PD1.DAC = 2048:2051;  % DAC addresses
PD1.ADC = 2064:2067;  % ADC addresses
PD1.IB = 0:31;        % inbound streams
PD1.OB = 0:31;        % outbound streams
PD1.ireg = 480:511;   % isolation registers
PD1.DSPin =   [18920 19432]; % DSP input (mono in, stereo out mode)
PD1.DSPoutL = [18880 19392];
PD1.DSPoutR = [18884 19396];


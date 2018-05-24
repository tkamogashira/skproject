function sysObjMap = hdlsysobjs
% hdlsysobjs

% map from System object to HDL implementation

%   Copyright 2011-2012 The MathWorks, Inc.

sysObjMap = containers.Map;

% DSP Delay
sysObjMap('dsp.Delay') = 'hdldspblks.DSPDelay';

% Min, Max
sysObjMap('dsp.Maximum') = 'hdldefaults.MinMaxTree';
sysObjMap('dsp.Minimum') = 'hdldefaults.MinMaxTree';

% NCO
sysObjMap('dsp.HDLNCO') = 'hdldspblks.HDLNCO';

% end

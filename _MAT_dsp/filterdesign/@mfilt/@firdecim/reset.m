function reset(Hm)
%RESET Reset the filter.


%   Author: P. Pacheco
%   Copyright 1988-2004 The MathWorks, Inc.

Hm.NumSamplesProcessed = 0;
Hm.nchannels = [];

% Call thisreset so subclasses can do their thing
thisreset(Hm);

% Need to reset the TapIndex before the States
Hm.States = [];


function p = sos2_blockparams(this)
%SOS2_BLOCKPARAMS   Get the SOS2 specific block parameters.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = sos_blockparams(this);

s = internalsettings(this);

p.memoryMode       = 'Binary point scaling';
p.memoryWordLength = sprintf('%d', s.StateWordLength);

p.stageInputMode       = 'Binary point scaling';
p.stageInputWordLength = sprintf('%d', s.SectionInputWordLength);
p.stageInputFracLength = sprintf('%d', s.SectionInputFracLength);

p.stageOutputMode       = 'Binary point scaling';
p.stageOutputWordLength = sprintf('%d', s.SectionOutputWordLength);
p.stageOutputFracLength = sprintf('%d', s.SectionOutputFracLength);

% [EOF]

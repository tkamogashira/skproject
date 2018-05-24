function p = blockparams(this, varargin)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

p = sos_blockparams(this);

s = internalsettings(this);

p.stageInputMode        = 'Binary point scaling';
p.StageInputWordLength  = sprintf('%d', s.NumStateWordLength);
p.StageInputFracLength  = sprintf('%d', s.NumStateFracLength);

p.stageOutputMode        = 'Binary point scaling';
p.StageOutputWordLength  = sprintf('%d', s.DenStateWordLength);
p.StageOutputFracLength  = sprintf('%d', s.DenStateFracLength);

function p = blockparams(~, varargin)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

p = [];
return;

% Get the generic fixed point params.
p = abstractfixed_blockparams(this);

s = internalsettings(this);

p.accumMode       = 'Binary point scaling';
p.accumWordLength = sprintf('%d', s.AccumWordLength);
p.accumFracLength = sprintf('%d', min(s.LatticeAccumFracLength, s.LadderAccumFracLength));

p.prodOutputMode       = 'Binary point scaling';
p.prodOutputWordLength = sprintf('%d', s.ProductWordLength);
p.prodOutputFracLength = sprintf('%d', min(s.LatticeProdFracLength, s.LadderProdFracLength));

p.firstCoeffMode       = 'Binary point scaling';
p.firstCoeffWordLength = sprintf('%d', s.CoeffWordLength);
p.firstCoeffFracLength = sprintf('%d', s.LatticeFracLength);

p.secondCoeffFracLength = sprintf('%d', s.LadderFracLength);

p.memoryMode       = 'Binary point scaling';
p.memoryWordLength = sprintf('%d', s.StateWordLength);
p.memoryFracLength = sprintf('%d', s.StateFracLength);

if s.LatticeProdFracLength ~= s.LadderProdFracLength
    warning(message('dsp:quantum:fixedlatticearmafilterq:blockparams:cannotMapMultProdFrLens'));
end

if s.LatticeAccumFracLength ~= s.LadderAccumFracLength
    warning(message('dsp:quantum:fixedlatticearmafilterq:blockparams:cannotMapMultAccFrLens'));
end


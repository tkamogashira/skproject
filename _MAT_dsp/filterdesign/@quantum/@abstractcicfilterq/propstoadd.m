function p = propstoadd(q)
% Quantize coefficients


%   Author(s): R. Losada
%   Copyright 1988-2005 The MathWorks, Inc.

p = fieldnames(q);
p{end+1} = 'SectionWordLengthMode';
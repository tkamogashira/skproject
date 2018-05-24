function prodwl = set_prodwl(q, prodwl)
%SET_PRODWL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'ProductWordLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    q.fimath.ProductWordLength = prodwl;
    thisset_prodwl(q, prodwl);
catch
    error(message('dsp:quantum:fixeddfsymfirfilterq:set_prodwl:MustBePosInteger'));
end
prodwl = [];

% [EOF]

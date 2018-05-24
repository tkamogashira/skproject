function prodfl = set_prodfl(q, prodfl)
%SET_PRODFL   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(q.FilterInternals,'FullPrecision'),
    error(siguddutils('readonlyerror', 'ProductFracLength', 'FilterInternals', 'SpecifyPrecision'));
end

try
    q.fimath.ProductFractionLength = prodfl;
    thisset_prodfl(q, prodfl);    
catch
    error(message('dsp:quantum:fixeddfsymfirfilterq:set_prodfl:MustBeInteger'));
end
prodfl = [];


% [EOF]

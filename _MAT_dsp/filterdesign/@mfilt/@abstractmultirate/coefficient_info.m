function [p, v] = coefficient_info(this)
%COEFFICIENT_INFO   Get the coefficient information for this filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

[p, v] = multirate_info(this);

p = {p{:}, ...
    getString(message('signal:dfilt:info:PolyphaseLength')), ...
    getString(message('signal:dfilt:info:FilterLength'))};

v = {v{:}, ...
    sprintf('%d', size(polyphase(this), 2)), ...
    sprintf('%d', length(this.Numerator))};

% [EOF]

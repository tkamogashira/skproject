function tabcshtags = gettabcshtags(this)
%GETTABCSHTAGS   Get the tabcshtags.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

tabcshtags = {fullfile('fdatool_qtool_coefficients', 'dsp'), ...
    fullfile('fdatool_qtool_io', 'dsp'), ...
    fullfile('fdatool_qtool_internals', 'dsp')};

% [EOF]

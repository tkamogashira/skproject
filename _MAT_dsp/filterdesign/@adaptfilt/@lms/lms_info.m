function [p, v] = lms_info(Ha)
%ABSTRACTFDAF_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = adaptfilt_info(Ha);

p = {p{:}, ...
        getString(message('signal:dfilt:info:StepSize')), ...
     getString(message('signal:dfilt:info:Leakage'))};

v = {v{:}, ...
        num2str(get(Ha, 'StepSize')), num2str(get(Ha, 'Leakage'))};

% [EOF]

function [p, v] = abstractap_info(Ha)
%ABSTRACTAP_INFO

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

[p, v] = adaptfilt_info(Ha);

p = {p{:}, getString(message('signal:dfilt:info:StepSize')), ...
     getString(message('signal:dfilt:info:ProjectionOrder'))};
v = {v{:}, num2str(get(Ha, 'StepSize')), num2str(get(Ha, 'ProjectionOrder'))};

% [EOF]

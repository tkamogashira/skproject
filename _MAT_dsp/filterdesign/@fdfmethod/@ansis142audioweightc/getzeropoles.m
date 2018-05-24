function [z p k] = getzeropoles(~)
%GETZEROPOLES   

%   Copyright 2009 The MathWorks, Inc.

% Zeros, poles and gain according to ANSI S1.42 standard for C-weighting, and
% IEC 61672 standard.
p1 = -20.598997*2*pi;
p2 = -12194.217*2*pi;

z= zeros(2,1);
p = [p1; p1;  p2; p2];

C = 10^(0.0619/20);
k = C*(p(3)^2);

% [EOF]

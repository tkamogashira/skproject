function [z p k] = getzeropoles(~)
%GETZEROPOLES   

%   Copyright 2009 The MathWorks, Inc.

% Zeros, poles and gain according to ANSI S1.42 standard for A-weighting, and
% IEC 61672 standard.
p1 = -20.598997*2*pi; 
p2 = -107.65265*2*pi;
p3 = -737.86223*2*pi;
p4 = -12194.217*2*pi;

z= zeros(4,1);
p = [p1; p1;  p2; p3; p4; p4];

C = 10^(1.9997/20);
k = C*(p(6)^2);

% [EOF]

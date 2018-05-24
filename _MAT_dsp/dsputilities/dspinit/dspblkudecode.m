function [x, y, str] = dspblkudecode
%DSPBLKUDECODE DSP System Toolbox Uniform decoder block helper 
%     function for mask parameters.

% Copyright 1995-2003 The MathWorks, Inc.

% Icon drawing:
str = '010...';
%Stairs:
x1 = [0.0 0.1 0.1 0.2 0.2 0.3 0.3 0.4 NaN]+0.6;
y1 = [0.2 0.2 0.4 0.4 0.6 0.6 0.8 0.8 NaN];
%Arrow:
x2 = [0.4 0.5 NaN 0.4 0.5 NaN 0.48 0.55 0.48]+0.1;
y2 = [0.52 0.52 NaN 0.48 0.48 NaN 0.37 0.5 0.63];

x = [x1 x2];
y = [y1 y2];

% [EOF] dspblkudecode.m

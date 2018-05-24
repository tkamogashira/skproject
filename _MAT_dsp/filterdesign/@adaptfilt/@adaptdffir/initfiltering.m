function [ntr,L,y,e,X,W] = initfiltering(h,Sx)
%INITFILTERING Initialize variables for filtering.
%
%   Inputs:
%       h - handle to adaptive filter object
%      Sx - Size of input signal (two element vector)       


%   Author(s): S.C. Douglas
%   Copyright 1999-2002 The MathWorks, Inc.

ntr = max(Sx);              %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
y = zeros(Sx);              %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L,1);             %  initialize temporary input signal buffer
W = h.privCoefficients;               %  initialize and assign coefficient vector
X(1:L-1)= h.privStates;            %  assign input signal buffer

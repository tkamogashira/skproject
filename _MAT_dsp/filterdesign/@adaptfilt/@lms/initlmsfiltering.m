function [ntr,L,y,e,X,W,mu,lam] = initlmsfiltering(h,Sx)
%INITLMSFILTERING Initialize LMS variables for filtering.
%
%   Inputs:
%       h - handle to adaptive filter object
%      Sx - Size of input signal (two element vector)       

%   Author(s): S.C. Douglas
%   Copyright 1999-2002 The MathWorks, Inc.

[ntr,L,y,e,X,W] = initfiltering(h,Sx); % Common stuff
mu = h.StepSize;               %  assign Step size
lam = h.Leakage;           %  assign Leakage

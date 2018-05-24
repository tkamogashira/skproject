function varargout = dspblkmodcovmeth2(action,varargin)
% DSPBLKMODCOVMETH2 Mask dynamic dialog function for
% Modified Covariance Method power spectrum estimation block

% Copyright 1995-2009 The MathWorks, Inc.

% The mask helper functions for Modified Covariance Method block 
% and Covariance Method block (dspblkcovarmeth2) perform exact
% same tasks. For clarity, two mask helper functions are used -
% one for each block.
[varargout{1:nargout}] = dspblkcovarmeth2(action,varargin{:});

% [EOF] dspblkmodcovmeth2.m

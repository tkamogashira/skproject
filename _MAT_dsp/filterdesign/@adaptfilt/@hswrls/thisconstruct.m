function thisconstruct(h,L,lambda,varargin)
%THISCONSTRUCT Local this construct method.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1, set(h,'FilterLength',L); end
if nargin > 2, set(h,'ForgettingFactor',lambda); end

% Make sure to initialize States and Coefficients
initrls(h,varargin{:});

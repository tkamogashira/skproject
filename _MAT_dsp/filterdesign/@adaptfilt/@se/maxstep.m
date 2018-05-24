function [mumax,mumaxmse] = maxstep(~,~)
%MAXSTEP  Maximum step size for adaptive filter convergence.
%
%   MUMAX = MAXSTEP(H) predicts a bound on the step size to  provide
%   convergence of the mean values of the adaptive filter coefficients.  
%
%   [MUMAX,MUMAXMSE] = MAXSTEP(H) predicts a bound on the adaptive
%   filter step size to provide convergence of the adaptive filter
%   coefficients in mean square.  
%
%   See also MSEPRED, MSESIM, FILTER.

%   Author(s): S.C. Douglas
%   Copyright 1999-2009 The MathWorks, Inc.

mumax = inf;
mumaxmse = inf;


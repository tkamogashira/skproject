function [mumax,mumaxmse] = maxstep(h)
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

error(nargchk(1,1,nargin,'struct'));

%  Compute Step size bound for convergence in the mean
mumax = 2;                         
mumaxmse = 2;                  

if (nargout > 1)
    if (h.Step > mumaxmse/2) || (h.Step <= 0)       %  Test s.Step and warn if outside reasonable limits
        warning(message('dsp:adaptfilt:nlms:maxstep:InvalidStepSize'));
    end
end

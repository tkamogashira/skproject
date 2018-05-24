function [mumax,mumaxmse] = maxstep(h,x)
%MAXSTEP  Maximum step size for adaptive filter convergence.
%
%   See also ADAPTFILT/MSEPRED, ADAPTFILT/MSESIM, ADAPTFILT/FILTER.

%   Copyright 1999-2002 The MathWorks, Inc.

error(message('dsp:adaptfilt:dlms:maxstep:NotSupported'));

function [mse,meanW,W,traceK] = msesim(h,x,d,M);
%MSESIM Measures mean-squared error.
%   MSE = MSESIM(H,X,D) Sequence of mean-square errors.  This column
%   vector contains estimates of the mean-square error of the adaptive
%   filter at each time instant.  The length of MSE is equal to SIZE(X,1).
%   The columns of the matrix X contain individual input signal sequences,
%   and the columns of the matrix D contain corresponding desired response
%   signal sequences. 
% 
%   [MSE,MEANW,W,TRACEK] = MSESIM(H,X,D) calculates three parameters
%   corresponding  to the simulated behavior of the adaptive filter defined
%   by H:
%
%       MEANW     - Sequence of coefficient vector means.  The columns of this 
%                   matrix contain estimates of the mean values of the LMS adaptive
%                   filter coefficients at each time instant.  The dimensions of
%                   MEANW are (SIZE(X,1)) x (H.length).
%       W       -   estimate of the final values of the adaptive filter
%                   coefficients for the algorithm corresponding to H.
%       TRACEK    - Sequence of total coefficient error powers.  This column vector
%                   contains estimates of the total coefficient error power of the
%                   LMS adaptive filter at each time instant.  The length of TRACEK 
%                   is equal to SIZE(X,1).
%
%   [MSE,MEANW,W,TRACEK] = MSESIM(H,X,D,M) specifies an optional
%   decimation factor  for computing MSE, MEANW, and TRACEK.  If M > 1,
%   every Mth predicted value of  each of these sequences is saved.  If
%   omitted, the value of M defaults to one.
%   
%   See also FILTER.

%   Author(s): Scott C. Douglas
%   Copyright 2001-2002 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

error(message('dsp:adaptfilt:abstractfdaf:msesim:NotSupported'));

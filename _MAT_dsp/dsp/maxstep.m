function [mumax,mumaxmse] = maxstep(h,x)
%MAXSTEP  Maximum step size for adaptive filter convergence.
%
%   MUMAX = MAXSTEP(H,X) predicts a bound on the step size to  provide
%   convergence of the mean values of the adaptive filter coefficients.
%
%   The columns of the matrix X contain individual input signal sequences.
%   The signal set is assumed to have zero mean or nearly so.
% 
%   [MUMAX,MUMAXMSE] = MAXSTEP(H,X) predicts a bound on the adaptive filter
%   step size to provide convergence of the adaptive filter coefficients in
%   mean square.
%
%   See also MSEPRED, MSESIM.

%   Copyright 1999-2013 The MathWorks, Inc.

% Validate input arguments
validateObjectHandle(h);         % Validate the object handle

% Stack input sequences into one vector
xt = x(:);                          

% Compute Step size bound for convergence in the mean
L = h.Length;                   % Length of coefficient vector

if isa(h,'dsp.LMSFilter')
    if strcmp(h.Method, 'LMS')
        mumax = 2/(mean(xt.*xt)*L);     % Calculate sufficient Step size bound
        if (nargout > 1)
            [~,~,~,~,~,dLam,kurt] = firwiener(L-1,x,x); % Third input is 'dummy'            
            mumaxmse = 2/(max(dLam)*(kurt+2)+sum(dLam));  %  Compute MSE Step size bound            
        end
    elseif strcmp(h.Method, 'Normalized LMS')
        mumax = 2;
        if (nargout > 1)
            mumaxmse = 2;            
        end
    else
        mumax = inf;
        mumaxmse = inf;
    end
else                                % dsp.BlockLMSFilter
    mumax = 2/(mean(xt.*xt)*L);     %  Calculate sufficient Step size bound    
    if (nargout > 1)
        mumaxmse = mumax/3;         %  Compute MSE Step size bound        
    end        
end
end

function validateObjectHandle(h)
%Validate the System object 'h'
coder.internal.errorIf(~(isobject(h) && (isa(h,'dsp.LMSFilter') || ...
    isa(h,'dsp.BlockLMSFilter'))), ...
    'dsp:system:AdaptiveFilterAnalysis:NotAnLMSFilterOrBlockLMSFilter');

%Validate the Method property of dsp.LMSFilter
if isa(h, 'dsp.LMSFilter')
    methodLocal = h.Method;
    coder.internal.errorIf(~(strcmp(methodLocal, 'LMS') || ...
        strcmp(methodLocal, 'Normalized LMS') || ...
        strcmp(methodLocal, 'Sign-Error LMS')), ...
        'dsp:system:AdaptiveFilterAnalysis:LMSFilterMethodNotSupported');  
end
end

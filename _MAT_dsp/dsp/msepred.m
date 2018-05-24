function [mmse,emse,meanW,mse,traceK] = msepred(h,x,d,M)
%MSEPRED Predicted mean-squared error for dsp.LMSFilter System object.
%
%   [MMSE,EMSE] = MSEPRED(H,X,D) predicts the steady-state values at
%   convergence of the minimum mean-squared error (MMSE) and the excess
%   mean-squared error (EMSE) given the input and desired response signal
%   sequences  in X and D and the quantities in the adaptive filter H.
%
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = MSEPRED(H,X,D) calculates three
%   sequences corresponding to the analytical behavior of the LMS adaptive
%   filter defined by H:
%
%   MEANW   - Sequence of coefficient vector means. The columns of this
%             matrix contain predictions of the mean values of the LMS
%             adaptive filter coefficients at each time instant. The
%             dimensions of MEANW are (SIZE(X,1)) x (H.length).
%   MSE     - Sequence of mean-square errors. This column vector contains
%             predictions of the mean-square error of the LMS adaptive
%             filter at each time instant. The length of MSE is equal to
%             SIZE(X,1).
%   TRACEK  - Sequence of total coefficient error powers. This column
%             vector contains predictions of the total coefficient error
%             power of the LMS adaptive filter at each time instant. The
%             length of TRACEK is equal to SIZE(X,1).
%
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = MSEPRED(H,X,D,M) specifies an optional
%   decimation factor for computing MEANW, MSE, and TRACEK. If M > 1, every
%   Mth predicted value of each of these sequences is saved. If omitted,
%   the value of M defaults to one.
%
%   See also MSESIM, MAXSTEP.

%  References:
%     [1] W.A. Gardner, "Learning characteristics of
%         stochastic-gradient-descent algorithms:  A general study,
%         analysis, and critique,"  Signal Processing, vol. 6, no. 2, pp.
%         113-133, April 1984.
%     [2] D.T.M. Slock, "On the convergence behavior of the LMS and the
%         normalized LMS algorithms," IEEE Trans. Signal Processing, vol.
%         41, no. 9, pp. 2811-2825, September 1993.

%   Copyright 1999-2013 The MathWorks, Inc.

% Validate input arguments
coder.internal.errorIf((nargin < 3 || nargin > 4), ...
    'dsp:system:AdaptiveFilterAnalysis:invalidInputArgumentsMSEPRED');
validateObjectHandle(h);    % Validate the object handle
validateInputs(x,d);        % Validate the input and desired signal matrices
if (nargin < 4)             % Specify the decimation factor if omitted
    M = 1;
end

% Initialization
[ntr,N] = size(x);          % Determine size of input signal matrix
L = h.Length;               % Length of coefficient vector

% Compute optimal coefficients
[Wopt,R,Pt,Q,Lam,dLam,kurt] = firwiener(L-1,x,d);

% Compute steady state minimum MSE and excess MSE values
mu = h.StepSize;            % LMS step size
mmse = 0;                   % Initial minimum MSE value
for k = 1:N;
    mmse = mmse + std(d(:,k)-filter(Wopt,1,x(:,k)))^2;      % Calculate (k)th MMSE value
end
mmse = mmse/N;              % Average MMSE value
A = eye(L) - 2*mu*Lam + mu^2*(Lam^2*(kurt+2)+dLam*dLam');   % MSE analysis transition matrix
Bt = mu^2*mmse*dLam';       % MSE analysis driving term
Kfinal = Bt/(eye(L) - A);   % Final values of transformed coefficient variances
emse = real(Kfinal*dLam);   % Steady-state excess MSE

% Compute coefficient vector means, MSEs, and total coefficient error power sequences
if (nargout > 2)
    ntrM = ntr/M;                   % Number of predicted values to save
    meanW = zeros(ntrM,L);          % Initialize meanW matrix
    mse = zeros(ntrM,1);            % Initialize MSE sequence
    traceK = mse;                   % Initialize traceK sequence
    mW = zeros(1,L);                % Buffer for initial coefficients values
    mW(:) = h.InitialConditions;    % Initial coefficient values
    dK = ((mW-Wopt)*Q).^2;          % Initial diagonal entries of coefficient covariance matrix K
    eyemuR = eye(L)-mu*R;           % Transition matrix for mean coefficient analysis
    muPt = mu*Pt;                   % Driving term for mean coefficient analysis
    diagA = (1 - 2*mu*dLam + mu^2*(kurt+2)*dLam.^2)';  % Portion of A for MSE analysis
    mu2dLamt = mu^2*dLam';          % Driving term for MSE analysis
    for n=1:ntr
        mW = mW*eyemuR + muPt;      % Update mean coefficient values
        MSE = mmse + dK*dLam;       % Compute current MSE
        dK = dK.*diagA + MSE*mu2dLamt;  % Update diagonal entries of coefficient covariance matrix
        if (rem(n,M)==0)            % Save every (M)th value
            meanW(n/M,:) = mW;      % Save mean coefficient values
            mse(n/M) = real(MSE);         % Save MSE
            traceK(n/M) = real(sum(dK));  % Save trace of coefficient covariance matrix
        end
    end
end
end

function validateObjectHandle(h)
% Validate the System object 'h'
coder.internal.errorIf(~(isobject(h) && isa(h,'dsp.LMSFilter')), ...
    'dsp:system:AdaptiveFilterAnalysis:NotAnLMSFilter');
end

function validateInputs(x, d)
% Validating the size of the inputs x and d. Inputs must be
% vectors.
coder.internal.errorIf(~ismatrix(x) || isempty(x), ...
    'MATLAB:system:inputMustBeMatrix','signal');

coder.internal.errorIf(~ismatrix(d) || isempty(d), ...
    'MATLAB:system:inputMustBeMatrix','desired signal');

% Inputs must be of same size
coder.internal.errorIf(~all(size(x)==size(d)), ...
    'MATLAB:system:inputsNotSameSize');

% Validating the data type of the inputs x and d. x and d must
% both be single or double.
coder.internal.errorIf(~(isa(x,'float') && strcmp(class(x), ...
    class(d))), 'dsp:system:AdaptiveFilter:inputsNotFloatingPoint');

% Check to see that input and desired response signal matrices are
% real-valued
coder.internal.errorIf(~(isreal(x) && isreal(d)), ...
    'dsp:system:AdaptiveFilterAnalysis:mustBeRealInputs')
end

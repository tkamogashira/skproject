function [mse,meanW,W,traceK] = msesim(h,x,d,M)
%MSESIM Mean-squared error for adaptive filters.
%   MSE = MSESIM(H,X,D) Sequence of mean-square errors. This column vector
%   contains estimates of the mean-square error of the adaptive filter at
%   each time instant. The length of MSE is equal to SIZE(X,1). The columns
%   of the matrix X contain individual input signal sequences, and the
%   columns of the matrix D contain corresponding desired response signal
%   sequences.
%
%   [MSE,MEANW,W,TRACEK] = MSESIM(H,X,D) calculates three parameters
%   corresponding  to the simulated behavior of the adaptive filter defined
%   by H:
%
%   MEANW   - Sequence of coefficient vector means. The columns of this
%             matrix contain estimates of the mean values of the LMS
%             adaptive filter coefficients at each time instant. The
%             dimensions of MEANW are (SIZE(X,1)) x (H.length).
%   W       - estimate of the final values of the adaptive filter
%             coefficients for the algorithm corresponding to H.
%   TRACEK  - Sequence of total coefficient error powers. This column
%             vector contains estimates of the total coefficient error
%             power of the LMS adaptive filter at each time instant. The
%             length of TRACEK is equal to SIZE(X,1).
%
%   [MSE,MEANW,W,TRACEK] = MSESIM(H,X,D,M) specifies an optional decimation
%   factor  for computing MSE, MEANW, and TRACEK. If M > 1, every Mth
%   predicted value of  each of these sequences is saved. If omitted, the
%   value of M defaults to one.
%
%   % EXAMPLE #1: System identification of an FIR filter
%   ha = fir1(31,0.5);                  
%   sa = dsp.FIRFilter('Numerator',ha); % FIR system to be identified 
%   hb = dsp.IIRFilter('Numerator',sqrt(0.75),...
%       'Denominator',[1 -0.5]);
%   x = step(hb,sign(randn(2000,25))); 
%   n = 0.1*randn(size(x));             % Observation noise signal 
%   d = step(sa,x)+n;                   % Desired signal 
%   l = 32;                             % Filter length 
%   mu = 0.008;                         % LMS Step size. 
%   m  = 5;                             % Decimation factor for analysis
%                                       % and simulation results 
%   ha = dsp.LMSFilter(l,'StepSize',mu); 
%   [simmse,meanWsim,Wsim,traceKsim] = msesim(ha,x,d,m);
%   plot(m*(1:length(simmse)),10*log10(simmse));
%   xlabel('Iteration'); ylabel('MSE (dB)');
%   title('Learning curve for LMS filter used in system identification')
%
%   See also MSEPRED, MAXSTEP

%   Copyright 1999-2013 The MathWorks, Inc.

% Validate input arguments
coder.internal.errorIf((nargin < 3 || nargin > 4), ...
    'dsp:system:AdaptiveFilterAnalysis:invalidInputArgumentsMSESIM');
validateObjectHandle(h);    % Validate the object handle
validateInputs(x,d);        % Validate the input and desired signal matrices
if (nargin < 4)             % Specify the decimation factor if omitted
    if isa(h,'dsp.BlockLMSFilter')
        M = h.BlockSize;
    else
        M = 1;
    end
else
    coder.internal.errorIf(...
        isa(h,'dsp.BlockLMSFilter') && (mod(M,h.BlockSize) ~= 0), ...
        'dsp:system:AdaptiveFilterAnalysis:InvalidDecimationFactor');                   
end

% Clone object so no change is made to the input object

% Initialization
[ntr,N] = size(x);          % Determine size of input signal matrix
L = h.Length;               % Length of coefficient vector
ntrM = floor(ntr/M);        % Number of predicted values to save
W = zeros(1,L);             % Initialize coefficient vector
meanW = zeros(ntrM,L);      % Initialize meanW matrix
mse = zeros(ntrM,1);        % Initialize MSE sequence
traceK = mse;               % Initialize traceK sequence

Wopt = firwiener(L-1,x,d);

% Main Loop
hc = clone(h); % Clone object so no change is made to input object

if isa(hc,'dsp.LMSFilter') || isa(hc,'dsp.BlockLMSFilter')
    % No Coefficients property
    
    coder.internal.errorIf(~h.WeightsOutputPort, ...
        'dsp:system:AdaptiveFilterAnalysis:WeightsOutputPortDisabled');
    
    
    for k=1:N
        reset(hc); % Reset object for each trial
        for m = 1:ntrM              % Iterate over ntrM blocks
            mm = (m-1)*M+1:m*M;     % Index variable used for block iteration
            [~,e,Wt] = step(hc,x(mm,k),d(mm,k));  % Evaluate adaptive filter over block
            meanW(m,:) = meanW(m,:) + Wt.';       % Estimate mean coefficient vector
            mse(m) = mse(m) + real(e(M)*conj(e(M)));    % Estimate mean-squared error
            V = Wt.' - Wopt;          % Compute coefficient error
            traceK(m) = traceK(m) + real(V*V'); % Estimate total coefficient error power
        end
        W = W + Wt.';    % Estimate final coefficient vector
    end
else
    for k=1:N
        reset(hc); % Reset object for each trial
        for m = 1:ntrM              % Iterate over ntrM blocks
            mm = (m-1)*M+1:m*M;     % Index variable used for block iteration
            [~,e] = step(hc,x(mm,k),d(mm,k));  % Evaluate adaptive filter over block
            Wt = hc.Coefficients;   % Coefficient vector at end of block
            meanW(m,:) = meanW(m,:) + Wt;       % Estimate mean coefficient vector
            mse(m) = mse(m) + real(e(M)*conj(e(M)));    % Estimate mean-squared error
            V = Wt - Wopt;          % Compute coefficient error
            traceK(m) = traceK(m) + real(V*V'); % Estimate total coefficient error power
        end
        W = W + hc.Coefficients;    % Estimate final coefficient vector
    end
end

W = W/N;                        % Average value of final coefficient vectors
meanW = meanW/N;                % Average value of mean coefficient vectors
mse = mse/N;                    % Average value of MSE sequences
traceK = traceK/N;              % Average value of total coefficient error powers
end

function validateObjectHandle(h)
% Validate the System object 'h'
coder.internal.errorIf(~(isobject(h) && (isa(h,'dsp.LMSFilter') || ...
    isa(h,'dsp.BlockLMSFilter') || isa(h,'dsp.RLSFilter') || ...
    isa(h,'dsp.AffineProjectionFilter') || ...
    isa(h,'dsp.AdaptiveLatticeFilter') || ...
    isa(h,'dsp.FastTransversalFilter') || ...
    isa(h,'dsp.FilteredXLMSFilter'))), ...
    'dsp:system:AdaptiveFilterAnalysis:invalidObjectInputMSESIM');
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

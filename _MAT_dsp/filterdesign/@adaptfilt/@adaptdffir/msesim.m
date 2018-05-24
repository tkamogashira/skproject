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
%   Copyright 2001-2004 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

[error_msg,warn_msg] = parse_inputs(x,d);

%  Specify decimation factor if omitted
if (nargin < 4)
    M = 1; 
end

%  Initialization

[ntr,N] = size(x);                  %  Determine size of input signal matrix
L = h.FilterLength;                       %  Length of coefficient vector
ntrM = floor(ntr/M);                %  Number of predicted values to save
W = zeros(1,L);                     %  Initialize coefficient vector
meanW = zeros(ntrM,L);              %  Initialize meanW matrix
mse = zeros(ntrM,1);                %  Initialize MSE sequence
traceK = mse;                       %  Initialize traceK sequence
r = zeros(2*L-1,1);                 %  Initial autocorrelation vector
p = r;                              %  Initial cross correlation vector
for k=1:N
    r = r + xcorr(x(:,k),L-1);      %  Calculate (k)th autocorrelation and accumulate
    p = p + xcorr(x(:,k),d(:,k),L-1); %  Calculate (k)th cross correlation and accumulate
end
Wopt = p(L:-1:1)'*inv(toeplitz(r(L:2*L-1)));  %  Optimal coefficient vector

%  Main Loop
hc = copy(h);
for k=1:N
	reset(hc); % Reset object for each trial
    for m = 1:ntrM                  %  Iterate over ntrM blocks
		hc.PersistentMemory = true; % Make sure object doesn't reset here
        mm = (m-1)*M+1:m*M;         %  Index variable used for block iteration
        [y,e] = filter(hc,x(mm,k),d(mm,k));  %  Evaluate adaptive filter over block
        Wt = hc.Coefficients;              %  Coefficient vector at end of block
        meanW(m,:) = meanW(m,:) + Wt;  %  Estimate mean coefficient vector
        mse(m) = mse(m) + real(e(M)*conj(e(M)));   %  Estimate mean-squared error
        V = Wt - Wopt;              %  Compute coefficient error
        traceK(m) = traceK(m) + real(V*V');  %  Estimate total coefficient error power
    end
    W = W + hc.Coefficients;               %  Estimate final coefficient vector
end
W = W/N;                            %  Average value of final coefficient vectors
meanW = meanW/N;                    %  Average value of mean coefficient vectors
mse = mse/N;                        %  Average value of MSE sequences
traceK = traceK/N;                  %  Average value of total coefficient error powers

%--------------------------------------------------------------------------
function [error_msg,warn_msg] = parse_inputs(x,d)

% Assign default error and warning messages.
error_msg = ''; warn_msg = ''; 

% Check to see that input and desired response signal matrices are the same size.
if ~isequal(size(x,1),size(d,1)) | ~isequal(size(x,2),size(d,2))
    error_msg = 'Input and desired response signal matrices should be the same size.';
    return;
end

% Check to see that input and desired response signal matrices are real-valued.
if ~isreal(x(:)) | ~isreal(d(:))
    error_msg = 'Input and desired response signal matrices must be real-valued.';
    return;
end

%  END OF PROGRAMS



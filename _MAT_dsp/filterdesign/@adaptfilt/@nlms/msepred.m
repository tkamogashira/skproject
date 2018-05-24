function [mmse,emse,meanW,mse,traceK] = msepred(h,x,d,M);
%MSEPRED Predicted mean-squared error for NLMS filter.
%   [MMSE,EMSE] = MSEPRED(H,X,D) predicts the steady-state values at
%   convergence of the minimum mean-squared error (MMSE) and the excess 
%   mean-squared error (EMSE) given the input and desired response signal
%   sequences  in X and D and the quantities in the adaptive filter H.  
%  
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = MSEPRED(H,X,D) calculates three
%   sequences corresponding to the analytical behavior of the LMS adaptive 
%   filter defined by H:
%
%       MEANW     - Sequence of coefficient vector means.  The columns of this 
%                   matrix contain predictions of the mean values of the LMS adaptive
%                   filter coefficients at each time instant.  The dimensions of
%                   MEANW are (SIZE(X,1)) x H.length.
%       MSE       - Sequence of mean-square errors.  This column vector contains
%                   predictions of the mean-square error of the LMS adaptive filter
%                   at each time instant.  The length of MSE is equal to SIZE(X,1).
%       TRACEK    - Sequence of total coefficient error powers.  This column vector
%                   contains predictions of the total coefficient error power of the
%                   LMS adaptive filter at each time instant.  The length of TRACEK 
%                   is equal to SIZE(X,1).
%
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = ANALYSIS(H,X,D,M) specifies
%   an optional decimation factor for computing MEANW, MSE, and TRACEK.  If M > 1,
%   every Mth predicted value of each of these sequences is saved.  If omitted,
%   the value of M defaults to one.
%
%   EXAMPLE: 
%       %Analysis and simulation of a 32-coefficient adaptive filter 
%       %(2000 iterations over 25 trials).
%       x = zeros(2000,25); d = x;          % Initialize variables
%       b = fir1(31,0.5);                  % FIR system to be identified
%       x = filter(sqrt(0.75),[1 -0.5],sign(randn(size(x)))); 
%       n = 0.1*randn(size(x));             % observation noise signal
%       d = filter(b,1,x)+n;                % desired signal
%       L = 32;                             % Filter length
%       mu = 0.2;                           % NLMS Step size
%       Offset = 0.5;                       % NLMS Offset value
%       Leakage = 1;                        % no Leakage
%       M  = 5;                             % Decimation factor for analysis and simulation results
%       h = adaptfilt.nlms(L,mu,Leakage,Offset);
%       [mmse,emse,meanW,mse,traceK] = msepred(h,x,d,M);
%       [simmse,meanWsim,Wsim,traceKsim] = msesim(h,x,d,M);
%       nn = M:M:size(x,1);   
%       subplot(2,1,1);
%       plot(nn,meanWsim(:,12),'b',nn,meanW(:,12),'r',nn,meanWsim(:,13:15),'b',nn,meanW(:,13:15),'r');
%       title('Average Coefficient Trajectories for W(12), W(13), W(14) and W(15)');
%       legend('Simulation','Theory');
%       xlabel('time index'); ylabel('coefficient value');
%       subplot(2,2,3);
%       semilogy(nn,simmse,[0 size(x,1)],[(emse+mmse) (emse+mmse)],nn,mse,[0 size(x,1)],[mmse mmse]);
%       title('Mean-Square Error Performance'); axis([0 size(x,1) 0.001 10]);
%       legend('MSE (Sim.)','Final MSE','MSE','Min. MSE');
%       xlabel('time index'); ylabel('squared error value');
%       subplot(2,2,4);
%       semilogy(nn,traceKsim,nn,traceK,'r');
%       title('Sum-of-Squared Coefficient Errors'); axis([0 size(x,1) 0.0001 1]);
%       legend('Simulation','Theory');
%       xlabel('time index'); ylabel('squared error value');
%
%   See also MSESIM, MAXSTEP, FILTER.

%  References:  
%     [1] N.J. Bershad, "Behavior of the epsilon-normalized LMS algorithm with
%         Gaussian inputs,"  IEEE Trans. Acoustics, Speech, and Signal Processing,
%         vol. 35, no. 5, pp. 636-644, May 1987.
%     [2] S.C. Douglas and T.H.-Y. Meng, "Normalized data nonlinearities for 
%         LMS adaptation," IEEE Trans. Signal Processing, vol. 42, no. 6, pp.
%         1352-1365, June 1994.             

%   Author(s): Scott C. Douglas
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

parse_inputs(x,d);

L = h.FilterLength;
[ntr,N] = size(x);

%  Specify decimation factor if omitted
if (nargin < 4)
    M = 1; 
end

% Compute optimal coefficients
[Wopt,R,Pt,Q,Lam,dLam] = firwiener(L-1,x,d);

%  Compute steady state minimum MSE and excess MSE values
A = zeros(L);                   %  Initialize transition matrix
Bt = zeros(1,L);                %  Initialize driving vector
Rn = zeros(L);                  %  Initialize normalized covariance matrix
Ptn = zeros(1,L);               %  Initialize normalized cross-correlation vector
mmse = 0;                       %  Initial minimum MSE value
X = zeros(L,1);                 %  Initialize temporary input signal buffer
mu = h.Step;                   %  NLMS Step size
bet = h.Offset;                %  NLMS Offset value
nn = 1:L-1;                     %  index variable used for input signal buffer
nnp1 = nn + 1;                  %  index variable used for input signal buffer
for k=1:N
    for n=1:ntr
        X(nnp1) = X(nn);        %  shift temporary input signal buffer down
        X(1) = x(n,k);          %  assign current input signal sample
        invden = 1/(bet + X'*X);%  compute normalization factor
        Xt = Q'*X;              %  compute rotated input signal vector
        Xt2 = Xt.^2;            %  compute instantaneous powers of rotated input signal vector
        Xt2invden2t = invden^2*Xt2';    %  term appearing in transition matrix
        A = A + diag(Xt2)*2*invden - mu*Xt2*Xt2invden2t;  %  estimate transition matrix
        Bt = Bt + Xt2invden2t;  %  estimate driving term
        Rn = Rn + invden*X*X';  %  estimate normalized covariance matrix
        Ptn = Ptn + invden*d(n,k)*X';  %  estimate normalized cross-correlation vector
    end
    mmse = mmse + std(d(:,k)-filter(Wopt,1,x(:,k)))^2;  %  Calculate (k)th MMSE value
end
mmse = mmse/N;                  %  Average MMSE value
A = eye(L) - mu*A/(ntr*N);      %  MSE analysis transition matrix
Bt = mu^2*mmse*Bt/(ntr*N);      %  MSE analysis driving term
Rn = Rn/(ntr*N);                %  Average normalized covariance matrix
Ptn = Ptn/(ntr*N);              %  Average normalized cross-correlation vector
Kfinal = Bt*inv(eye(L) - A);    %  Final values of transformed coefficient variances
emse = Kfinal*dLam;             %  Steady-state excess MSE

%  Compute coefficient vector means, MSEs, and total coefficient error power sequences

if (nargout > 2)
   ntrM = size(x,1)/M;             %  Number of predicted values to save
    meanW = zeros(ntrM,L);          %  Initialize meanW matrix
    mse = zeros(ntrM,1);            %  Initialize MSE sequence
    traceK = mse;                   %  Initialize traceK sequence
    mW = h.Coefficients;                 %  Initial coefficient values
    dK = ((mW-Wopt)*Q).^2;          %  Initial diagonal entries of coefficient covariance matrix K
    eyemuR = eye(L)-mu*Rn;          %  Transition matrix for mean coefficient analysis
    muPt = mu*Ptn;                  %  Driving term for mean coefficient analysis
    for n=1:ntr
        mW = mW*eyemuR + muPt;      %  Update mean coefficient values
        MSE = mmse + dK*dLam;       %  Compute current MSE
        dK = dK*A + Bt;             %  Update diagonal entries of coefficient covariance matrix
        if (rem(n,M)==0)            %  Save every (M)th value
            meanW(n/M,:) = mW;      %  Save mean coefficient values
            mse(n/M) = MSE;         %  Save MSE
            traceK(n/M) = sum(dK);  %  Save trace of coefficient covariance matrix
        end
    end
end

%--------------------------------------------------------------------------
function parse_inputs(x,d)


% Check to see that input and desired response signal matrices are the same size.
if ~isequal(size(x,1),size(d,1)) | ~isequal(size(x,2),size(d,2))
    error(message('dsp:adaptfilt:lms:msepred:InvalidParam1'));
    return;
end

% Check to see that input and desired response signal matrices are real-valued.
if ~isreal(x(:)) | ~isreal(d(:))
    error(message('dsp:adaptfilt:lms:msepred:InvalidParam2'));
    return;
end


%  END OF PROGRAMS







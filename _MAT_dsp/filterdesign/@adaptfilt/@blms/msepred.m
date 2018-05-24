function [mmse,emse,meanW,mse,traceK] = msepred(h,x,d);
%MSEPRED Predicted mean-squared error for BLMS filter.
%   [MMSE,EMSE] = MSEPRED(H,X,D) predicts the steady-state values at
%   convergence of the minimum mean-squared error (MMSE) and the excess 
%   mean-squared error (EMSE) given the input and desired response signal
%   sequences in X and D and the quantities in the adaptive filter H.  
%  
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = MSEPRED(H,X,D) calculates three
%   sequences corresponding to the analytical behavior of the LMS adaptive 
%   filter defined by H:
%
%   MEANW   - Sequence of coefficient vector means.  The columns of this
%             matrix contain predictions of the mean values of the LMS
%             adaptive filter coefficients at each time instant.  The
%             dimensions of MEANW are SIZE(X,1) x H.LENGTH.
%   
%   MSE     - Sequence of mean-square errors. This column vector contains
%             predictions of the mean-square error of the LMS adaptive
%             filter at each time instant. The length of MSE is equal to
%             SIZE(X,1).
%   
%   TRACEK  - Sequence of total coefficient error powers.  This column
%             vector contains predictions of the total coefficient error
%             power of the LMS adaptive filter at each time instant. The
%             length of TRACEK is equal to SIZE(X,1).
%
%   EXAMPLE: 
%       %Analysis and simulation of a 32-coefficient FIR filter 
%       %(2000 iterations over 25 trials).
%       x = zeros(2000,25); d = x;          % Initialize variables
%       b = fir1(31,0.5);                  % FIR system to be identified
%       x = filter(sqrt(0.75),[1 -0.5],sign(randn(size(x)))); 
%       n = 0.1*randn(size(x));             % observation noise signal
%       d = filter(b,1,x)+n;                % desired signal
%       N = 32;                             % Filter length
%       mu = 0.007;                         % Block LMS Step size
%       L  = 8;                             % Block length
%       M = L;                              % Decimation factor 
%       Leakage = 1;                        % no Leakage
%       h = adaptfilt.blms(N,mu,Leakage,L);
%       [mmse,emse,meanW,mse,traceK] = msepred(h,x,d);
%       [Msesim,meanWsim,Wsim,traceKsim] = msesim(h,x,d,M);
%       nn = M:M:size(x,1);   
%       subplot(2,1,1);
%       plot(nn,meanWsim(:,12),'b',nn,meanW(:,12),'r',nn,meanWsim(:,13:15),'b',nn,meanW(:,13:15),'r');
%       title('Average Coefficient Trajectories for W(12), W(13), W(14) and W(15)');
%       legend('Simulation','Theory');
%       xlabel('time index'); ylabel('coefficient value');
%       subplot(2,2,3);
%       semilogy(nn,Msesim,[0 size(x,1)],[(emse+mmse) (emse+mmse)],nn,mse,[0 size(x,1)],[mmse mmse]);
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

%   Reference: 
%     [1] S.C. Douglas, "Analysis of the multiple-error and block least-mean-square
%         adaptive algorithms,"  IEEE Trans. Circuits and Systems II: Analog and 
%         Digital Signal Processing, vol. 42, no. 2, pp. 92-101, February 1995. 
              
%   Author(s): Scott C. Douglas
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

parse_inputs(x,d);

L = h.FilterLength;
[ntr,N] = size(x);

%  Set the decimation factor equal to the block length
M = h.BlockLength;

B = h.BlockLength;                    %  Block length
% Compute optimal coefficients
[Wopt,R,Pt,RR] = lclwienerfilt(L,x,d,B);


%  Compute steady state minimum MSE and excess MSE values
mu = h.Step;                    %  Block LMS Step size
mmse = 0;                       %  Initial minimum MSE value
for k = 1:N;
    mmse = mmse + std(d(:,k)-filter(Wopt,1,x(:,k)))^2;  %  Calculate (k)th MMSE value
end
mmse = mmse/N;                  %  Average MMSE value

%  Compute coefficient vector means, MSEs, and total coefficient error power sequences

if (nargout > 1)

    ZL = zeros(L);                  %  (L x L) zero matrix
    ntrM = size(x,1)/M;             %  Number of predicted values to save
    meanW = zeros(ntrM,L);          %  Initialize meanW matrix
    mse = zeros(ntrM,1);            %  Initialize MSE sequence
    traceK = mse;                   %  Initialize traceK sequence
    mW = h.Coefficients;                 %  Initial coefficient values
    K = (mW-Wopt)'*(mW-Wopt);       %  Initial coefficient covariance matrix K
    [Q,Lam] = eig(R);               %  Find eigenvalue decomposition of R
    dLam = diag(Lam);               %  Specify eigenvalue vector
    A = eye(L) - 2*mu*Lam + mu^2*(Lam^2*(1+1/B)+dLam/B*dLam');  
                                    %  Transition matrix for Kfinal iteration
    Bt = mu^2*mmse*dLam';           %  Driving term for Kfinal iteration
    dKfinal = Bt*inv(eye(L) - A);   %  Calculate initial conditions for Kfinal iteration
    Kfinal = Q*diag(dKfinal)*Q';    %  Calculate initial conditions for Kfinal iteration
    eyemuR = eye(L)-mu*R;           %  Transition matrix for mean coefficient analysis
    muPt = mu*Pt;                   %  Driving term for mean coefficient analysis
    for n=1:ntrM
        mW = mW*eyemuR + muPt;      %  Update mean coefficient values
        MSE = mmse + trace(K*R/B);  %  Compute current MSE
        K = updateblmscov(K,RR,R,ZL,mu,mmse,B);  %  Update K 
        Kfinal = updateblmscov(Kfinal,RR,R,ZL,mu,mmse,B); %  Update Kfinal
        meanW(n,:) = mW;            %  Save mean coefficient values
        mse(n) = MSE;               %  Save MSE
        traceK(n) = trace(K);       %  Save trace of coefficient covariance matrix
    end
    emse = trace(Kfinal*R/B);       %  Compute final excess MSE
end

%--------------------------------------------------------------------------
function [Wopt,R,Pt,RR] = lclwienerfilt(L,x,d,B)
% Local Wiener filter computation.
% Don't use wienerfilt because of different scaling of R and also 
% because of extra output RR and extra input B

[ntr,N] = size(x);              %  Determine size of input signal matrix
r = zeros(2*L+2*B-1,1);         %  Initial autocorrelation vector
p = zeros(2*L-1,1);             %  Initial cross correlation vector
for k=1:N;
    r = r + xcorr(x(:,k),B+L-1);  %  Calculate (k)th autocorrelation and accumulate
    p = p + xcorr(d(:,k),x(:,k),L-1);  %  Calculate (k)th cross correlation and accumulate
end
for k=1:B;
    RR(:,:,k) = sqrt((B+1-k)/(1 + (k==1)))*toeplitz(r(L+B+k-1:-1:B+k),r(L+B+k-1:2*L+B+k-2))/(N*ntr);
    %  (L x L) scaled autocorrelation matrices for fourth moment term
end
R = sqrt(2*B)*RR(:,:,1);        %  (L x L) input autocorrelation matrix
Pt = B*p(L:2*L-1)'/(N*ntr);     %  (1 x L) cross correlation vector
Wopt = Pt/R;               %  Optimal coefficient vector

%--------------------------------------------------------------------------
function [Knew] = updateblmscov(K,RR,R,ZL,mu,mmse,B);
%  Update coefficient covariance matrix 

TT = ZL;                            %  Initialize fourth moment term
for k=1:B;
    RRK = RR(:,:,k)*K;
    TT = TT + RRK*RR(:,:,k) + RR(:,:,k)*trace(RRK);  %  Accumulate fourth moment term
end
RK = R*K;                           %  Calculate R*K
K = K - mu*(RK + RK') + mu^2*RK*R + mu^2*(TT + TT') + mu^2*mmse*R;  %  Update K
Knew = (K+K')/2;                    %  Make K symmetric (enhances numerical stability)

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







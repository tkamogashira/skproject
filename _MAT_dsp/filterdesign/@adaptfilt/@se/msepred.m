function [mmse,emse,meanW,mse,traceK] = msepred(h,x,d,M);
%MSEPRED Predicted mean-squared error for sign-error adaptive filter.
%   [MMSE,EMSE] = MSEPRED(Ha,X,D) predicts the steady-state values at
%   convergence of the minimum mean-squared error (MMSE) and the excess 
%   mean-squared error (EMSE) given the input and desired response signal
%   sequences  in X and D and the quantities in the adaptive filter Ha.  
%  
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = MSEPRED(Ha,X,D) calculates three
%   sequences corresponding to the analytical behavior of the LMS adaptive 
%   filter defined by Ha:
%
%       MEANW     - Sequence of coefficient vector means.  The columns of this 
%                   matrix contain predictions of the mean values of the LMS adaptive
%                   filter coefficients at each time instant.  The dimensions of
%                   MEANW are (SIZE(X,1)) x (LENGTH(Ha.Coefficients)).
%       MSE       - Sequence of mean-square errors.  This column vector contains
%                   predictions of the mean-square error of the LMS adaptive filter
%                   at each time instant.  The length of MSE is equal to SIZE(X,1).
%       TRACEK    - Sequence of total coefficient error powers.  This column vector
%                   contains predictions of the total coefficient error power of the
%                   LMS adaptive filter at each time instant.  The length of TRACEK 
%                   is equal to SIZE(X,1).
%
%   [MMSE,EMSE,MEANW,MSE,TRACEK] = ANALYSIS(Ha,X,D,M) specifies
%   an optional decimation factor for computing MEANW, MSE, and TRACEK.  If M > 1,
%   every Mth predicted value of each of these sequences is saved.  If omitted,
%   the value of M defaults to one.
%
%   EXAMPLE: 
%       %Analysis and simulation of a 32-coefficient FIR filter 
%       %(2000 iterations over 25 trials).
%       x = zeros(2000,25); d = x;          % Initialize variables
%       h = fir1(31,0.5);                  % FIR system to be identified
%       x = filter(sqrt(0.75),[1 -0.5],sign(randn(size(x)))); 
%       n = 0.1*randn(size(x));             % observation noise signal
%       d = filter(h,1,x)+n;                % desired signal
%       M  = 5;                             % Decimation factor for analysis and simulation results
%       L = 32;                             % Filter length
%       mu = 0.008;                         % LMS Step size.
%       M  = 5;                             % Decimation factor for analysis and simulation results
%       h = adaptfilt.se(L,mu);
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
%   See also MSESIM, FILTER.

%  Reference:
%     [1] V.J. Mathews and S.H. Cho, "Improved convergence analysis of stochastic 
%         gradient adaptive filters using the sign algorithm,"  IEEE Trans. Acoust., 
%         Speech, Signal Processing, vol. ASSP-35, no. 4, pp. 450-455, April 1987.
              

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
mu = h.Step;                    %  sign error Step size
mmse = 0;                       %  Initial minimum MSE value
for k = 1:N;
    mmse = mmse + std(d(:,k)-filter(Wopt,1,x(:,k)))^2;  %  Calculate (k)th MMSE value
end
mmse = mmse/N;                  %  Average MMSE value
c = (mu*R(1,1)*L)^2*pi/8;       %  Intermediate term used to calculate EMSE
emse = c/2 + sqrt(c^2/4 + c*mmse);  %  Final EMSE of sign error algorithm

%  Compute coefficient vector means, MSEs, and total coefficient error power sequences

if (nargout > 2)
    ntrM = size(x,1)/M;             %  Number of predicted values to save
    meanW = zeros(ntrM,L);          %  Initialize meanW matrix
    mse = zeros(ntrM,1);            %  Initialize MSE sequence
    traceK = mse;                   %  Initialize traceK sequence
    mW = h.Coefficients;                  %  Initial coefficient values
    dK = ((mW-Wopt)*Q).^2;          %  Initial diagonal entries of coefficient covariance matrix K
    musqrt2opi = mu*sqrt(2/pi);     %  Step size constant for analysis
    mu2dLamt = mu^2*dLam';          %  Driving term for MSE analysis
    for n=1:ntr
        MSE = mmse + dK*dLam;         %  Compute current MSE
        mufac = musqrt2opi/sqrt(MSE); %  Compute Step size factor
        mW = mW + mufac*(Pt - mW*R);  %  Update mean coefficient values
        diagA = 1 - (2*mufac)*dLam';  %  Compute diagonal entries of MSE transition matrix
        dK = dK.*diagA + mu2dLamt;    %  Update diagonal entries of coefficient covariance matrix
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







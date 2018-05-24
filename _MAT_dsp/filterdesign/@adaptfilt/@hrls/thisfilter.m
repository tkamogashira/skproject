function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute Household RLS adaptive filter.
%   Y = FILTER(H,X,D) applies an HRLS adaptive filter H to the input signal
%   in the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
%   
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      G0 = sqrt(10)*eye(32); % Initial sqrt correlation matrix inverse
%      lam = 0.99;            % RLS forgetting factor
%      h = adaptfilt.hrls(32,lam,G0);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also MSESIM, RESET. 

%   References: 
%     [1] A.A. Rontogiannis and S. Theodoridis, "Inverse factorization
%         adaptive least-squares algorithms," Signal Processing, vol. 52,
%         no. 1, pp. 35-47, July 1996.
%     [2] S.C. Douglas, "Numerically-robust O(N^2) RLS algorithms using
%         least-squares prewhitening,"  Proc. IEEE Int. Conf. on Acoustics,
%         Speech, and Signal Processing, Istanbul, Turkey, vol. I, pp. 412-415,
%         June 2000.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
[ntr,L,y,e,X,W] = initfiltering(h,[Mx,Nx]); % Common stuff
lam = h.ForgettingFactor;  %  assign forgetting factor
G = h.SqrtInvCov;          %  assign square root covariance matrix
sinvlam = 1/sqrt(lam);     %  assign square root inverse forgetting factor


%  Main loop 
for n=1:ntr,
    
    %  Update input signal buffer
    
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Square root covariance matrix update 
    
    V = G*X;                %  compute whitened input signal vector
    U = G'*V;
    gam = lam + V'*V;
    zeta = 1/(gam + sqrt(lam*gam));
    K = 1/gam*U;                  %  compute Kalman gain vector
    G = sinvlam*(G - zeta*V*U');  %  update square root covariance matrix
    
    %  Compute output signal, error signal, and coefficient updates
    
    y(n) = W*X;             %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = W + e(n)*K';        %  update filter coefficient vector
end

%  Save States
h.SqrtInvCov = G;           %  save final sqrt inverse covariance matrix
h.KalmanGain = K;           %  save final Kalman gain vector
savestates(h,W,X,ntr,L);    %  save common stuff

%  END OF PROGRAM

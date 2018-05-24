function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute RLS adaptive filter.
%   Y = FILTER(H,X,D) applies an RLS adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
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
%      P0 = 10*eye(32);       % Initial sqrt correlation matrix inverse
%      lam = 0.99;            % RLS forgetting factor
%      h = adaptfilt.rls(32,lam,P0);
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
%     [1] M. Hayes, Statistical Digital Signal Processing and Modeling
%         (New York:  Wiley, 1996). 
%     [2] S. Haykin, Adaptive Filter Theory, 4th Ed.  (Upper Saddle 
%         River, NJ:  Prentice Hall, 2002).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);


%  Variable initialization
[ntr,L,y,e,X,W] = initfiltering(h,[Mx,Nx]); % Common stuff
lam = h.ForgettingFactor;  %  assign forgetting factor
P   = h.InvCov;            %  initialize and assign covariance matrix
invlam = 1/lam;            %  assign inverse forgetting factor

%  Main loop 
for n=1:ntr,
    
    %  Update input signal buffer
    
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Covariance matrix update 
    
    XP = X'*P;
    PX = P*X;
    invden = 1/(lam + XP*X);
    K = invden*PX;          %  compute Kalman gain vector
    P = invlam*(P - K*XP);  %  update covariance matrix
    
    %  Compute output signal, error signal, and coefficient updates
    
    y(n) = W*X;             %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = W + e(n)*K';        %  update filter coefficient vector
end

%  Save States
h.InvCov = P;               %  save final covariance matrix
h.KalmanGain = K;           %  save final Kalman gain vector
savestates(h,W,X,ntr,L);    %  save common stuff

%  END OF PROGRAM

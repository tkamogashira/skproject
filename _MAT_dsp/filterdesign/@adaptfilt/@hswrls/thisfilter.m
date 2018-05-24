function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute Household sliding-window RLS adaptive filter.
%   Y = FILTER(H,X,D) applies an HSWRLS adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
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
%      N  = 64;               % block length
%      h = adaptfilt.hswrls(32,lam,G0,N);
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

%   Reference: 
%     [1] S.C. Douglas, "Numerically-robust O(N^2) RLS algorithms using
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
ntr = length(x);            %  temporary number of NumSamplesProcessed
L = h.FilterLength;         %  number of coefficients
N = h.SwBlockLength;          %  block length 
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N-1,1);         %  initialize temporary input signal buffer
D = zeros(N,1);             %  initialize temporary desired signal buffer
W = h.Coefficients;         %  initialize and assign coefficient vector
X(1:L+N-2)= h.States;       %  assign input signal buffer
D(1:N-1)= h.DesiredSignalStates; %  assign desired signal buffer
lam = h.ForgettingFactor;   %  assign forgetting factor
G = h.sqrtinvcov;           %  initialize and assign square root covariance matrix
sinvlam = 1/sqrt(lam);      %  assign square root inverse forgetting factor
invlamNm1 = lam^(1-N);      %  assign (N-1)th power of square root inverse forgetting factor



%  Main Loop

for n=1:ntr,
    
    %  Update input and desired signal buffers
    
    X(2:L+N-1) = X(1:L+N-2); %  shift temporary input signal buffer down
    X(1) = x(n);             %  assign current input signal sample
    D(2:N) = D(1:N-1);       %  shift temporary desired signal buffer down
    D(1) = d(n);             %  assign current desired signal sample
    
    %  Square root covariance matrix update 
    
    XL = X(1:L);
    V = G*XL;                %  compute whitened input signal vector
    U = G'*V;
    gam = lam + V'*V;
    zeta = 1/(gam + sqrt(lam*gam));
    K = 1/gam*U;                  %  compute Kalman gain vector
    G = sinvlam*(G - zeta*V*U');  %  update square root covariance matrix
    
    %  Compute output signal, error signal, and first part of coefficient updates
    
    y(n) = W*XL;            %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = W + e(n)*K';        %  update filter coefficient vector
    
    %  Covariance matrix "down-date"
    
    XL = X((1:L)+N-1);  
    V = G*XL;
    U = G'*V;
    gam = invlamNm1 - V'*V;
    zeta = 1/(gam + sqrt(invlamNm1*gam));
    KN = -1/gam*U;          %  compute Kalman gain vector
    G = G + zeta*V*U';      %  "down-date" square root covariance matrix
    
    %  Compute last part of coefficient updates
    
    E = D(N) - W*XL;        %  compute trailing error signal sample
    W = W + E*KN';          %  "down-date" filter coefficient vector
    
end


%  Save States
h.sqrtInvcov = G;           %  save final sqrt inverse covariance matrix
h.KalmanGain = K;           %  save final Kalman gain vector
h.DesiredSignalStates = D(1:N-1); %  save final desired signal States
savestates(h,W,X,ntr,L+N-1);   %  save common stuff

%  END OF PROGRAM

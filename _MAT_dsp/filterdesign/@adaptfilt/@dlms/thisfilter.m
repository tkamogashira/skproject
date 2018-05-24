function [y,e] = thisfilter(h,x,d)
%FILTER  Execute delayed LMS adaptive filter.
%   Y = FILTER(H,X,D) applies a delayed LMS adaptive filter H to the input
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
%      mu = 0.008;            % LMS Step size.
%      delay = 1;             % Update delay
%      h = adaptfilt.dlms(32,mu,1,delay);
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
%     [1] B. Widrow and M.E. Hoff, Jr., "Adaptive switching circuits,"
%         IRE Wescon Conv. Rec., pt. 4, pp. 96-104, 1960.
%     [2] S. Haykin, Adaptive Filter Theory, 4th Ed.  (Upper Saddle 
%         River, NJ:  Prentice Hall, 2002).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;         %  number of coefficients
delay = h.Delay;            %  update delay
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+delay,1);       %  initialize temporary input signal buffer
E = zeros(delay+1,1);       %  initialize temporary error signal buffer
W = h.Coefficients;         %  initialize and assign coefficient vector
nnD = 1:delay;              %  index variable used for error signal buffer
nnDp1 = nnD + 1;            %  index variable used for error signal buffer
nD = delay + 1;             %  index variable used for coefficient update
X(1:L+delay-1)= h.States;   %  assign input signal buffer
E(1:delay)= h.ErrorStates;  %  assign input signal buffer
mu = h.StepSize;            %  assign step size
lam = h.Leakage;            %  assign leakage

%  Main loop 

for n=1:ntr,
    X(2:L+delay) = X(1:L+delay-1); %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    y(n) = W*X(1:L);        %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    E(nnDp1) = E(nnD);      %  shift temporary error signal buffer down
    E(1) = e(n);            %  assign current error signal sample            
    W = lam*W + mu*E(nD)*X(1+delay:L+delay)'; %  update filter coefficient vector
end

%  Save States
h.ErrorStates = E(1:delay);       %  save final error States
savestates(h,W,X,ntr,L+delay);

% [EOF]

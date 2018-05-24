function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute LMS adaptive filter.
%   Y = THISFILTER(H,X,D) applies an LMS adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      mu = 0.008;            % LMS Step size.
%      h = adaptfilt.lms(32,mu);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also MSESIM, MSEPRED, RESET, MAXSTEP. 

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
[ntr,L,y,e,X,W,mu,lam] = initlmsfiltering(h,[Mx,Nx]);

%  Main loop 

for n=1:ntr,
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    y(n) = W*X;             %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = lam*W + mu*e(n)*X'; %  update filter coefficient vector
end

%  Save States
savestates(h,W,X,ntr,L);

%  END OF PROGRAM

function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute sign-data adaptive filter.
%   Y = THISFILTER(H,X,D) applies a sign-data adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %Adaptive line enhancement using a 32-coefficient FIR filter 
%      %(5000 iterations).
%      D  = 1;                              % Number of samples of delay
%      ntr= 5000;                           % Number of iterations
%      v  = sin(2*pi*0.05*[1:ntr+D]);       % Sinusoidal signal
%      n  = randn(1,ntr+D);                 % Noise signal
%      x  = v(1:ntr)+n(1:ntr);              % Input signal (delayed desired signal)
%      d  = v(1+D:ntr+D)+n(1+D:ntr+D);      % Desired signal
%      mu = 0.0001;                         % Sign-data Step size.
%      h = adaptfilt.sd(32,mu);
%      [y,e] = filter(h,x,d); 
%      subplot(2,1,1); plot(1:ntr,[d;y;v(1+D:ntr+D)]);
%      axis([ntr-100 ntr -3 3]);
%      title('Adaptive line enhancement of a noisy sinusoidal signal');
%      legend('Observed','Enhanced','Original');
%      xlabel('time index'); ylabel('signal value');
%      [Pxx,om] = pwelch(x(ntr-1000:ntr));
%      Pyy = pwelch(y(ntr-1000:ntr));  
%      subplot(2,1,2); plot(om/pi,10*log10([Pxx/max(Pxx),Pyy/max(Pyy)]));
%      axis([0 1 -60 20]);
%      legend('Observed','Enhanced'); 
%      xlabel('Normalized Frequency (\times \pi rad/sample)');
%      ylabel('Power Spectral Density'); grid on;
%
%   See also 

%   References: 
%     [1] J.L. Moschner, "Adaptive filter with clipped input data,"  Ph.D. 
%         thesis, Stanford Univ., Stanford, CA, June 1970.
%     [2] M. Hayes, Statistical Digital Signal Processing and Modeling
%         (New York:  Wiley, 1996).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));
[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
[ntr,L,y,e,X,W,mu,lam] = initlmsfiltering(h,[Mx,Nx]);
sX = X;                     %  initialize temporary signed input signal buffer
sX(1:L-1) = sign(h.States); %  assign signed input signal buffer

%  Main loop 

for n=1:ntr,
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    sX(2:L) = sX(1:L-1);    %  shift temporary signed input signal buffer down
    sX(1) = sign(x(n));     %  assign current signed input signal sample
    y(n) = W*X;             %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    W = lam*W + mu*e(n)*sX';%  update filter coefficient vector
end

%  Save States
savestates(h,W,X,ntr,L);

%  END OF PROGRAM

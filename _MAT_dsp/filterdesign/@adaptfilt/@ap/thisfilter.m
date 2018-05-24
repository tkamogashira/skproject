function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the Affine projection FIR adaptive filter.
%   Y = THISFILTER(H,X,D) applies an AP adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E] = THISFILTER(H,X,D) also returns the prediction error E.
%
%
%   EXAMPLE: 
%      %QPSK adaptive equalization using a 32-coefficient FIR filter 
%      %(1000 iterations).
%      D  = 16;                             % Number of samples of delay
%      b  = exp(j*pi/4)*[-0.7 1];           % Numerator coefficients of channel
%      a  = [1 -0.7];                       % Denominator coefficients of channel
%      ntr= 1000;                           % Number of iterations
%      s  = sign(randn(1,ntr+D)) + j*sign(randn(1,ntr+D));  % Baseband QPSK signal
%      n  = 0.1*(randn(1,ntr+D) + j*randn(1,ntr+D));        % Noise signal
%      r  = filter(b,a,s)+n;                % Received signal
%      x  = r(1+D:ntr+D);                   % Input signal (received signal)
%      d  = s(1:ntr);                       % Desired signal (delayed QPSK signal)
%      mu = 0.1;                            % Step size
%      po = 4;                              % Projection order
%      Offset = 0.05;                       % Offset for covariance matrix
%      h = adaptfilt.ap(32,mu,po,Offset);
%      [y,e] = filter(h,x,d);
%      subplot(2,2,1); plot(1:ntr,real([d;y;e]));
%      title('In-Phase Components');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,2,2); plot(1:ntr,imag([d;y;e]));
%      title('Quadrature Components');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,2,3); plot(x(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%      title('Received Signal Scatter Plot'); axis('square'); 
%      xlabel('Real[x]'); ylabel('Imag[x]'); grid on;
%      subplot(2,2,4); plot(y(ntr-100:ntr),'.'); axis([-3 3 -3 3]);
%      title('Equalized Signal Scatter Plot'); axis('square');
%      xlabel('Real[y]'); ylabel('Imag[y]'); grid on;
%
%   See also MSESIM

%   References: 
%     [1] K. Ozeki and T. Umeda, "An adaptive filtering algorithm using
%         an orthogonal projection to an affine subspace and its
%         properties,"  Electronics and Communications in Japan, vol.
%         67-A, no. 5, pp. 19-27, May 1984.
%     [2] Y. Maruyama, "A fast method of projection algorithm,"  Proc.
%         1990 IEICE Spring Conf., B-744.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization

ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
[N,tmp] = size(h.offsetcov);   %  projection order
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N-1,1);         %  initialize temporary input signal buffer
E = zeros(N,1);             %  initialize temporary error signal buffer
Eps = zeros(N,1);           %  initialize temporary epsilon signal buffer
nL = 1:L;                   %  index variable used for input signal buffer
nLpNm1 = nL + N - 1;        %  index variable used for input signal buffer
nN = 1:N;                   %  index variable used for input signal buffer
nNpLm1 = nN + L - 1;        %  index variable used for input signal buffer
nnN = 1:N-1;                %  index variable used for error signal buffer
nnNp1 = nnN + 1;            %  index variable used for error signal buffer
W = h.Coefficients;               %  initialize and assign alternative coefficient vector
X(1:L+N-2)= h.States;       %  assign input signal buffer
E(nnN)= h.ErrorStates;        %  assign error signal buffer
Eps(nnN) = h.EpsilonStates;     %  assign epsilon signal buffer
mu = h.StepSize;                %  assign Step size
R = h.offsetcov;               %  initialize Offset input covariance matrix
ommu = 1-mu;                %  compute (1-mu) constant

%  Main loop 

for n=1:ntr
    
    %  Update input signal buffer
    
    X(2:L+N-1) = X(1:L+N-2);%  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Update input covariance matrix
    
    XN = X(nN);             %  select most-recent N input signal samples
    R = R + XN*XN';         %  update current Offset input covariance matrix
    
    %  Compute output and error signals
    
    XL = X(nL);             %  select most-recent L input signal samples
    y(n) = W*XL + R(1,nnNp1)*Eps(nnN); %  compute current output signal sample
    e(n) = d(n) - y(n);     %  compute current error signal sample
    
    %  Update error and epsilon signal buffers
    
    E(nnNp1) = ommu*E(nnN); %  compute and shift temporary error signal buffer down
    E(1) = mu*e(n);         %  assign current error signal sample    
    Eps = [0;Eps(nnN)] + R\E;  %  compute temporary epsilon signal buffer
    
    %  Compute alternative coefficient updates
    
    W = W + Eps(N)*X(nLpNm1)';  %  update alternative coefficient vector
    
    %  "Down-date" input covariance matrix
    
    XN = X(nNpLm1);         %  select oldest N input signal samples
    R = R - XN*XN';         %  update current Offset input covariance matrix
    
end

%  Save States

h.Coefficients = W;               %  save final alternative coefficient vector
h.offsetcov = R;               %  save final Offset input covariance matrix
h.States = X(1:L+N-2);      %  save final filter States
h.ErrorStates = E(nnN);       %  save final error signal States
h.EpsilonStates = Eps(nnN);     %  save final epsilon signal States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;      %  update and save total number of iterations

%  END OF PROGRAM

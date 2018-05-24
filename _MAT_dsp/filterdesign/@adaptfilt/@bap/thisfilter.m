function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the Block affine projection FIR adaptive filter.
%   Y = THISFILTER(H,X,D) applies an BAP adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E] = THISFILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      % QPSK adaptive equalization using a 32-coefficient FIR filter 
%      % (1000 iterations).
%      D  = 16;                             % Number of samples of delay
%      b  = exp(j*pi/4)*[-0.7 1];           % Numerator coefficients of channel
%      a  = [1 -0.7];                       % Denominator coefficients of channel
%      ntr= 1000;                           % Number of iterations
%      s  = sign(randn(1,ntr+D)) + j*sign(randn(1,ntr+D));  % Baseband QPSK signal
%      n  = 0.1*(randn(1,ntr+D) + j*randn(1,ntr+D));        % Noise signal
%      r  = filter(b,a,s)+n;                % Received signal
%      x  = r(1+D:ntr+D);                   % Input signal (received signal)
%      d  = s(1:ntr);                       % Desired signal (delayed QPSK signal)
%      mu = 0.5;                            % Step size
%      po = 4;                              % Projection order
%      Offset = 1;                          % Offset for covariance matrix
%      h = adaptfilt.bap(32,mu,po,Offset);
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
%   See also 

%   References: 
%     [1] K. Ozeki and T. Umeda, "An adaptive filtering algorithm using
%         an orthogonal projection to an affine subspace and its
%         properties,"  Electronics and Communications in Japan, vol.
%         67-A, no. 5, pp. 19-27, May 1984.
%     [2] M. Montazeri and P. Duhamel, "A set of algorithms linking NLMS 
%         and block RLS algorithms," IEEE Trans. Signal Processing, vol.
%         43, no. 2, pp. 444-453, February 1995.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Check to see if input signal length is an integer number of blocks
if (rem(length(x),h.ProjectionOrder)~=0),
    error(message('dsp:adaptfilt:bap:thisfilter:InvalidDimensions'));
end

%  Variable initialization

ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
N = h.ProjectionOrder;           %  projection order
ntrB = floor(length(x)/N);  %  temporary number of block iterations
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N,1);           %  initialize temporary input signal buffer
E = zeros(N,1);             %  initialize temporary error signal buffer
nnL = 1:L;                  %  index variable used for input signal buffer
nnLpN = N+1:N+L;            %  index variable used for input signal buffer
nnN = 1:N;                  %  index variable used for input signal buffer
nnNpN = N+1:2*N;            %  index variable used for input signal buffer
nnNpL = L+1:L+N;            %  index variable used for input signal buffer
nnNp1r = N+1:-1:2;          %  index variable used for input signal buffer
nnNpLmNp1r = L+1:-1:L-N+2;  %  index variable used for input signal buffer
nnr = L+N:-1:2;             %  index variable used for input signal buffer
nnLpNr = L+N:-1:N+1;        %  index variable used for coefficient updates
rN = N:-1:1;                %  index variable used for coefficient updates
W = h.Coefficients;              %  initialize and assign coefficient vector
X(nnr) = h.States;         %  assign input signal buffer
mu = h.Step;               %  assign Step size
R = h.OffsetCov;               %  initialize Offset input covariance matrix

%  Main loop 

for n=1:ntrB,
    XR = toeplitz(X(nnNpN),X(nnNp1r));  % form last input data matrix
    R = R - XR'*XR;         %  "down"-date input signal covariance matrix
    nn = ((n-1)*N+1):(n*N); %  index for current signal blocks
    X(nnL) = X(nnLpN);      %  shift temporary input signal buffer up
    X(nnNpL) = x(nn);       %  assign current input signal block
    Y = filter(W,1,X);      %  compute current output signal block
    y(nn) = Y(nnNpL);       %  assign current output signal block
    e(nn) = d(nn) - y(nn);  %  compute and assign current error signal block
    E(nnN) = mu*e(nn(rN));  %  assign Step-size-weighted error vector
    XR = toeplitz(X(nnNpL),X(nnNpLmNp1r));  % form first input data matrix
    R = R + XR'*XR;         %  update input signal covariance matrix
    invRE = R\E;            %  compute projected error vector
    G = filter(invRE,1,X'); %  compute gradient for current block
    W = W + G(nnLpNr);      %  update filter coefficient vector
end


%  Save States

h.Coefficients = W;                %  save final coefficient vector
h.OffsetCov = R;                 %  save final Offset covariance matrix
h.States = X(nnr);           %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntrB;      %  update and save total number of iterations

%  END OF PROGRAM

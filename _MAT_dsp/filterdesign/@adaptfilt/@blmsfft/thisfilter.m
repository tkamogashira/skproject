function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute FFT-based Block LMS adaptive filter.
%   Y = THISFILTER(H,X,D) applies a block LMS adaptive filter H to the
%   input signal in  the vector X and the desired signal in the vector D.
%   The estimate of the desired response signal is returned in Y.  X and D
%   must be of the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,512);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,512); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      mu = 0.008;            % BLMS Step size
%      N  = 16;               % block length
%      h = adaptfilt.blmsfft(32,mu,1,N);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d(1:500);y(1:500);e(1:500)]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also 

%     [1] J.J. Shynk, "Frequency-domain and multirate adaptive 
%         filtering,"  IEEE Signal Processing Magazine, vol. 9,
%         no. 1, pp. 14-37, Jan. 1992.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Check to see if input signal length is an integer number of blocks
if (rem(length(x),h.BlockLength)~=0),
        error(message('dsp:adaptfilt:blmsfft:thisfilter:InvalidBlockLength'));
end

%  Variable initialization

ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
N = h.BlockLength;             %  block length
ntrB = floor(length(x)/N);  %  temporary number of block iterations
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N,1);           %  initialize temporary input signal buffer
E = zeros(L+N,1);           %  initialize temporary error signal buffer
W = zeros(L+N,1);           %  initialize temporary coefficient buffer
W(1:L) = h.Coefficients;          %  initialize and assign coefficient vector
X((L:-1:1)+N) = h.States;   %  assign input signal buffer
mu = h.Step;                %  assign Step size
lam = h.Leakage;            %  assign Leakage

%  Main loop 

for n=1:ntrB,
    nn = ((n-1)*N+1):(n*N); %  index for current signal blocks
    X(1:L) = X((1:L)+N);    %  shift temporary input signal buffer up
    X((1:N)+L) = x(nn);     %  assign current input signal vector
    FFTW = fft(W);          %  compute FFT of coefficient vector
    FFTX = fft(X);          %  compute FFT of input signal vector
    Y = ifft(FFTW.*FFTX);   %  compute current output signal vector
    y(nn) = Y((1:N)+L);     %  assign current output signal block
    e(nn) = d(nn) - y(nn);  %  assign current error signal block
    E((1:N)+L) = mu*e(nn);  %  assign current error signal vector
    FFTE = fft(E);          %  compute FFT of error signal vector
    G = ifft(FFTE.*conj(FFTX));    %  compute gradient vector
    W(1:L) = lam*W(1:L) + G(1:L);  %  update filter coefficient vector
end

%  Save States
h.Coefficients = W(1:L).';       %  save final coefficient vector
h.States = X((L:-1:1)+N);  %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntrB;    %  update and save total number of iterations

%  Check to see if input and desired signals are real-valued; if so,
%  make sure that S.Coefficients, output signals, and error signals are real-valued.

if all([isreal(x) isreal(d)]),
    y = real(y);            %  constrain output signal to be real-valued
    e = real(e);            %  constrain error signal to be real-valued
    h.Coefficients = real(h.Coefficients);  %  constrain Coefficients to be real-valued
end

%  END OF PROGRAM

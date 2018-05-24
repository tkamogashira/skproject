function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the frequency-domain FIR adaptive filter.
%   Y = THISFILTER(H,X,D) applies an FDAF adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D.
%   The estimate of the desired response signal is returned in Y.
%   X and D must be of the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
%
%
%   EXAMPLE: 
%      %QPSK adaptive equalization using a 32-coefficient FIR filter 
%      %(1024 iterations).
%      D  = 16;                             % Number of samples of delay
%      b  = exp(j*pi/4)*[-0.7 1];           % Numerator coefficients of channel
%      a  = [1 -0.7];                       % Denominator coefficients of channel
%      ntr= 1024;                           % Number of iterations
%      s  = sign(randn(1,ntr+D)) + j*sign(randn(1,ntr+D));  % Baseband QPSK signal
%      n  = 0.1*(randn(1,ntr+D) + j*randn(1,ntr+D));        % Noise signal
%      r  = filter(b,a,s)+n;                % Received signal
%      x  = r(1+D:ntr+D);                   % Input signal (received signal)
%      d  = s(1:ntr);                       % Desired signal (delayed QPSK signal)
%      del = 1;                             % Initial FFT input powers
%      mu  = 0.1;                           % Step size
%      lam = 0.9;                           % Averaging factor
%      h = adaptfilt.fdaf(32,mu,1,del,lam);
%      [y,e] = filter(h,x,d); 
%      subplot(2,2,1); plot(1:1000,real([d(1:1000);y(1:1000);e(1:1000)]));
%      title('In-Phase Components');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,2,2); plot(1:1000,imag([d(1:1000);y(1:1000);e(1:1000)]));
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

%   Reference: 
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
    error(message('dsp:adaptfilt:fdaf:thisfilter:InvalidBlockLength'));
end

%  Variable initialization

ntr = length(x);            %  temporary number of iterations 
N = h.BlockLength;          %  block length
L = h.FilterLength;         %  number of coefficients
ntrB = floor(length(x)/N);  %  temporary number of block iterations
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N,1);           %  initialize temporary input signal buffer
E = zeros(L+N,1);           %  initialize temporary error signal buffer
Ef = zeros(L+N,1);          %  initialize temporary error signal buffer
nnL = 1:L;                  %  index variable used for input signal buffer
nnLpN = N+1:N+L;            %  index variable used for input signal buffer
nnNpL = L+1:L+N;            %  index variable used for input signal buffer
nnLpNr = L+N:-1:N+1;        %  index variable used for coefficient updates
FFTW = h.FFTCoefficients.'; %  initialize and assign frequency domain Coefficients
normFFTX = h.Power;         %  initialize and assign FFT input signal powers
X(nnLpNr) = h.FFTStates;    %  assign input signal buffer
mu = h.StepSize;            %  assign step size
bet = h.AvgFactor;          %  assign averaging factor
ombet = 1 - bet;            %  compute (1 - h.AvgFactor)
lam = h.Leakage;            %  assign Leakage
Offset = h.Offset;          %  assign Offset
ZN = zeros(N,1);            %  assign N-dimensional zero vector

%  Main loop 

for n=1:ntrB,
    nn = ((n-1)*N+1):(n*N); %  index for current signal blocks
    X(nnL) = X(nnLpN);      %  shift temporary input signal buffer up
    X(nnNpL) = x(nn);       %  assign current input signal vector
    FFTX = fft(X);          %  compute FFT of input signal vector
    Y = ifft(FFTW.*FFTX);   %  compute current output signal vector
    y(nn) = Y(nnNpL);       %  assign current output signal block
    e(nn) = d(nn) - y(nn);  %  assign current error signal block
    E(nnNpL) = mu*e(nn);    %  assign current error signal vector
    FFTE = fft(E);          %  compute FFT of error signal vector
    normFFTX = bet*normFFTX + ombet*real(FFTX.*conj(FFTX));  
                            %  update FFT input signal powers
    G = ifft(FFTE.*conj(FFTX)./(normFFTX + Offset));  
                            %  compute gradient vector
    G(nnNpL) = ZN;          %  impose gradient constraint
    FFTW = lam*FFTW + fft(G);  %  update frequency domain coefficients
end

%  Save FFTStates

h.FFTCoefficients = FFTW.';   %  save final frequency domain coefficients
h.Power = normFFTX;           %  save final FFT input signal powers
h.FFTStates = X(nnLpNr);       %  save final filter FFTStates
h.NumSamplesProcessed = h.NumSamplesProcessed + ntrB;     %  update and save total number of iterations

%  Check to see if input and desired signals are real-valued; if so,
%  make sure that output signals and error signals are real-valued.

if isreal(x) && isreal(d),
    y = real(y);            %  constrain output signal to be real-valued
    e = real(e);            %  constrain error signal to be real-valued
end


%  END OF PROGRAM

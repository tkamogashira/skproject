function [y,e] = thisfilter(h,x,d)
%THISFILTER  
%  Execute the partitioned block frequency-domain FIR adaptive filter.
%   
%   Y = THISFILTER(H,X,D) applies an PBFDAF adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D.
%   The estimate of the desired response signal is returned in Y.
%   X and D must be of the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
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
%      del = 1;                             % Initial FFT input powers
%      mu  = 0.1;                           % Step size
%      lam = 0.9;                           % Averaging factor
%      N   = 8;                             % Block size
%      h = adaptfilt.pbfdaf(32,mu,1,del,lam,N);
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
%     [1] J.S. So and K.K. Pang, "Multidelay block frequency domain 
%         adaptive filter,"  IEEE Trans. Acoustics, Speech, and 
%         Signal Processing, vol. 38, no. 2, pp. 373-376, February
%         1990.
%     [2] J.M. Paez Borrallo and and M.G. Otero, "On the implementation 
%         of a partitioned block frequency domain adaptive filter 
%         (PBFDAF) for long acoustic echo cancellation,"  Signal 
%         Processing, vol. 27, no. 3, pp. 301-315, June 1992.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Check to see if input signal length is an integer number of blocks
if (rem(length(x),h.BlockLength)~=0),
    error(message('dsp:adaptfilt:pbfdaf:thisfilter:InvalidBlockLength'));
end

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
[M,TN] = size(h.FFTCoefficients); %  find number of filter blocks M
N = TN/2;                   %  block length
ntrB = floor(length(x)/N);  %  temporary number of block iterations
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
FFTX = zeros(TN,M);         %  initialize temporary FFT input signal buffer
E = zeros(TN,1);            %  initialize temporary error signal buffer
nnM = 1:M-1;                %  index variable used for FFT input signal buffer
nnMp1 = nnM + 1;            %  index variable used for FFT input signal buffer
nnN = 1:N;                  %  index variable used for input signal buffer
nnNpN = N+1:TN;             %  index variable used for input signal buffer
nnf = ntrB*N+1:ntr;         %  index variable used for final block
Nf = length(nnf);           %  length of final block
FFTW = h.FFTCoefficients.'; %  initialize and assign frequency domain Coefficients
normFFTX = h.Power;         %  initialize and assign FFT input signal powers
FFTX(:,nnM) = h.FFTStates;  %  initialize and assign FFT input signal States
mu = h.StepSize;            %  assign step size
bet = h.AvgFactor;          %  assign averaging factor
ombet = 1 - bet;            %  compute (1 - h.AvgFactor)
lam = h.Leakage;            %  assign Leakage
Offset = h.Offset;          %  assign Offset
ZNM = zeros(N,M);           %  assign (N x M) zero matrix-dimensional zero vector
OMt = ones(1,M);            %  assign M-dimensional zero vector

%  Initialize temporary input signal buffer

if isreal(x),
    X = real(ifft(FFTX(:,1)));
else
    X = ifft(FFTX(:,1));
end;

%  Main loop 

for n=1:ntrB,
    nn = ((n-1)*N+1):(n*N); %  index for current signal blocks
    FFTX(:,nnMp1) = FFTX(:,nnM);  %  shift temporary FFT input signal buffers over
    X(nnN) = X(nnNpN);      %  shift temporary input signal buffer up
    X(nnNpN) = x(nn);       %  assign current input signal block
    FFTX(:,1) = fft(X);     %  compute FFT of input signal vector
    Y = ifft(sum(FFTW.*FFTX,2));  %  compute current output signal vector
    y(nn) = Y(nnNpN);       %  assign current output signal block
    e(nn) = d(nn) - y(nn);  %  assign current error signal block
    E(nnNpN) = mu*e(nn);    %  assign current error signal vector
    normFFTX = bet*normFFTX + ombet*real(FFTX(:,1).*conj(FFTX(:,1)));  
                            %  update FFT input signal powers
    FFTEinvnormFFTX = (fft(E)./(normFFTX + Offset))*OMt;          
                            %  compute power-normalized FFT of error signal matrix 
    G = ifft(FFTEinvnormFFTX.*conj(FFTX)); 
                            %  compute gradient matrix
    G(nnNpN,:) = ZNM;       %  impose gradient constraint
    FFTW = lam*FFTW + fft(G);  %  update frequency domain coefficient matrix
end

h.FFTCoefficients = FFTW.';       %  save final frequency domain coefficients
h.Power = normFFTX;           %  save final FFT input signal powers
h.FFTStates = FFTX(:,nnM);  %  save final FFT input signal States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntrB;      %  update and save total number of iterations

%  Check to see if input and desired signals are real-valued; if so,
%  make sure that output signals and error signals are real-valued.

if isreal(x) && isreal(d),
    y = real(y);            %  constrain output signal to be real-valued
    e = real(e);            %  constrain error signal to be real-valued
end

%  END OF PROGRAM

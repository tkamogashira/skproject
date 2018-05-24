function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the Transform-domain adaptive filter using 
%        discrete Fourier transform.
%   
%   Y = THISFILTER(H,X,D) applies a TDAFDFT adaptive filter H to the input
%   signal in the vector X and the desired signal in the vector D.
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
%      L  = 32;                             % filter length
%      mu = 0.01;                           % Step size
%      h = adaptfilt.tdafdft(L,mu);
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
%     [1] S. Haykin, "Adaptive Filter Theory", 3rd Edition,
%         Prentice Hall, N.J., 1996.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;         %  number of coefficients
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L,1);             %  initialize temporary input signal buffer
nnLm1 = [0:L-1]';           %  index variable used for sliding DFT Coefficients
IDFTW = ifft(h.Coefficients);  %  initialize and assign IDFT(coefficient vector)
normDFTX = h.Power;         %  initialize and assign sliding DFT powers
X(1:L-1)= h.States;         %  assign input signal buffer
mu = h.StepSize;            %  assign step size
bet = h.AvgFactor;          %  assign averaging factor
ombet = 1 - bet;            %  compute (1 - h.AvgFactor)
lam = h.Leakage;            %  assign Leakage
Offset = h.Offset;          %  assign Offset
A = exp(-j*2*pi*nnLm1/L);   %  compute sliding DFT Coefficients

%  First iteration

X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
X(1) = x(1);            %  assign current input signal sample
   
DFTX     = fft(X);      %  compute current DFT
normDFTX = bet*normDFTX + ombet*real(DFTX.*conj(DFTX)); %  Update DFT powers
   
y(1) = IDFTW*DFTX;      %  compute and assign current output signal sample
e(1) = d(1) - y(1);     %  compute and assign current error signal sample
IDFTW = lam*IDFTW + mu*e(1)*(DFTX./(normDFTX + Offset))';  %  update IDFT(W)

%  Main Loop 

for n=2:ntr
    
    %  Update input signal buffer and sliding DFT quantities
    
    DFTX = A.*DFTX - X(L);  %  start computing current DFT
    
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    DFTX = DFTX + X(1);     %  finish computing current DFT
    normDFTX = bet*normDFTX + ombet*real(DFTX.*conj(DFTX)); %  Update DFT powers
    
    %  Compute output signal, error signal, and coefficient updates
       
    y(n) = IDFTW*DFTX;      %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    IDFTW = lam*IDFTW + mu*e(n)*(DFTX./(normDFTX + Offset))';  %  update IDFT(W)
    
end

%  Save States

h.Coefficients = fft(IDFTW); %  save final coefficient vector
h.Power = normDFTX;          %  save final sliding DFT powers
h.States = X(1:L-1);         %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;      %  update and save total number of iterations

%  Check to see if input and desired signals are real-valued; if so,
%  make sure that S.Coefficients, output signals, and error signals are real-valued.

if isreal(x) && isreal(d),
    y = real(y);            %  constrain output signal to be real-valued
    e = real(e);            %  constrain error signal to be real-valued
    h.Coefficients = real(h.Coefficients);  %  constrain Coefficients to be real-valued
end

%  END OF PROGRAM

function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the Transform-domain adaptive filter using 
%        discrete cosine transform.
%   
%   Y = THISFILTER(H,X,D) applies a TDAFDCT adaptive filter H to the input
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
%      h = adaptfilt.tdafdct(L,mu);
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

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;         %  number of coefficients
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+2,1);           %  initialize temporary input signal buffer
B = zeros(L,1);             %  initialize diff signal buffer
TX = zeros(L,3);            %  initialize scaled DCT buffer
nnL = 1:L;                  %  index variable used for input signal buffer
nnLm1 = [nnL - 1]';         %  index variable used for input signal buffer
nnLs = 1:2:L-1;             %  index variable used for diff signal buffer
nnLsp1 = nnLs + 1;          %  index variable used for diff signal buffer
nL = L+1;                   %  index variable used for diff signal buffer
nLp1 = nL + 1;              %  index variable used for diff signal buffer
nn2 = 1:2;                  %  index variable used for scaled DCT buffer
nn2p1 = nn2 + 1;            %  index variable used for scaled DCT buffer
IDCTW = idct(h.Coefficients); %  initialize and assign IDCT(coefficient vector)
normDCTX = h.Power;         %  initialize and assign forward prediction error powers
X(1:L-1)= h.States;         %  assign input signal buffer
mu = h.StepSize;            %  assign step size
bet = h.AvgFactor;          %  assign averaging factor
ombet = 1 - bet;            %  compute (1 - h.AvgFactor)
lam = h.Leakage;            %  assign Leakage
Offset = h.Offset;          %  assign Offset
on = ones(ceil(L/2),1);     %  assign ones vector
A = 2*cos(nnLm1*pi/L);      %  compute sliding DCT Coefficients
C = sqrt(2/L)*cos(nnLm1*pi/(2*L));  %  compute sliding DCT Coefficients
C(1) = 1/sqrt(L);           %  compute sliding DCT Coefficients

%  First two iterations

for n=1:min([2 ntr])
    
    %  Update input signal buffer
    
    X(2:L+2) = X(1:L+1);    %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Update sliding DCT quantities
    
    TX(:,nn2p1) = TX(:,nn2);   %  shift temporary scaled DCT buffer across
    TX(:,1) = dct(X(nnL))./C;  %  compute current scaled DCT
    DCTX = TX(:,1).*C;         %  compute current DCT
    normDCTX = bet*normDCTX + ombet*real(DCTX.*conj(DCTX)); %  Update DCT powers
    
    %  Compute output signal, error signal, and coefficient updates
    
    y(n) = IDCTW*DCTX;      %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    IDCTW = lam*IDCTW + mu*e(n)*(DCTX./(normDCTX + Offset))';  %  update IDCT(W)
    
end

%  Main Loop 

for n=3:ntr
    
    %  Update input signal buffer
    
    X(2:L+2) = X(1:L+1);    %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Update sliding DCT quantities
    
    B(nnLs)   = X(1) - X(2) - X(nL) + X(nLp1);  %  compute temporary diff signal
    B(nnLsp1) = X(1) - X(2) + X(nL) - X(nLp1);  %  compute temporary diff signal
    TX(:,nn2p1) = TX(:,nn2);%  shift temporary scaled DCT buffer across
    TX(:,1) = A.*TX(:,2) - TX(:,3) + B; %  compute current scaled DCT
    DCTX = TX(:,1).*C;      %  compute current DCT
    normDCTX = bet*normDCTX + ombet*real(DCTX.*conj(DCTX)); %  Update DCT powers
    
    %  Compute output signal, error signal, and coefficient updates
    
    y(n) = IDCTW*DCTX;      %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    IDCTW = lam*IDCTW + mu*e(n)*(DCTX./(normDCTX + Offset))';  %  update IDCT(W)
    
end

%  Save States

h.Coefficients = dct(IDCTW); %  save final coefficient vector
h.Power = normDCTX;          %  save final sliding DCT powers
h.States = X(1:L-1);         %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr; %  update and save total number of iterations

%  END OF PROGRAM

function [y,e] = thisfilter(h,x,d)
%FILTER  Execute the Gradient adaptive lattice FIR filter.
%   Y = FILTER(H,X,D) applies an GAL adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
%   
%
%   EXAMPLE: 
%      %QPSK adaptive equalization using a 32-coefficient adaptive filter 
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
%      L = 32;                              % filter length
%      mu = 0.007;                          % Step size
%      h = adaptfilt.gal(L,mu);
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
%     [1] L.J. Griffiths, "A continuously adaptive filter implemented as a 
%         lattice structure,"  Proc. IEEE Int. Conf. on Acoustics, Speech, 
%         and Signal Processing, Hartford, CT, pp. 683-686, 1977.
%     [2] S. Haykin, Adaptive Filter Theory, 3rd Ed.  (Upper Saddle 
%         River, NJ:  Prentice Hall, 1996).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;         %  number of joint process coefficients
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
F = zeros(L,1);             %  initialize temporary forward prediction error buffer
B = zeros(L,1);             %  initialize temporary backward prediction error buffer
H = h.Coefficients;         %  initialize and assign joint process coefficient vector
Rho = h.ReflectionCoeffs;   %  initialize and assign reflection coefficient vector
normF = h.FwdPredErrorPower; %  initialize and assign forward prediction error powers
normB = h.BkwdPredErrorPower;%  initialize and assign backward prediction error powers
B(1:L-1)= h.States;         %  assign backward prediction error buffer
muH = h.StepSize;           %  assign joint process Step size
muR = h.ReflectionCoeffsStep; %  assign reflection Step size
bet = h.AvgFactor;          %  assign averaging factor
ombet = 1 - bet;            %  compute (1 - h.lambda)
lam = h.Leakage;            %  assign leakage
Offset = h.Offset;          %  assign fffset

%  Main loop 

for n=1:ntr,
    
    %  Forward and backward prediction error calculations
    
    F(1) = x(n);                    %  Assign current forward prediction error
    for i=1:L-1;
        F(i+1) = F(i) - Rho(i)*B(i);%  Compute new forward prediction errors
    end; 
    
    Bnew = B(1:L-1) - Rho.'.*F(1:L-1); %  Compute new backward prediction errors
    normF = bet*normF + ombet*real(F.*conj(F));  
                                       %  Update forward prediction error powers
    Rho = Rho + muR*real((F(2:L).*conj(B(1:L-1)) + Bnew.*conj(F(1:L-1)))./(normF(1:L-1) + normB(1:L-1)+Offset)).';
                                    %  Update reflection coefficients
    B(2:L) = Bnew;                  %  Update backward prediction errors
    B(1) = x(n);                    %  Assign current backward prediction error
    normB = bet*normB + ombet*real(B.*conj(B));
                                    %  Update forward prediction error powers
    
    %  Joint process estimation
                                    
    y(n) = H*B;                     %  compute current output signal sample
    e(n) = d(n) - y(n);             %  compute current error signal sample
    H = H + muH*e(n)*(B./(normB+Offset))'; 
                                    %  update joint process coefficient vector
end

%  Save states

h.Coefficients = H;          %  save final joint process coefficients
h.ReflectionCoeffs  = Rho;   %  save final reflection coefficients
h.FwdPredErrorPower = normF; %  save final forward prediction error powers
h.BkwdPredErrorPower= normB; %  save final backward prediction error powers
h.States = B(1:L-1);         %  save final backward prediction error states
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr; 

% [EOF]

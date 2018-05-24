function [y,e] = thisfilter(h,x,d)
%FILTER  Execute the Least-squares lattice adaptive filter.
%   Y = FILTER(H,X,D) applies an LSL adaptive filter H to the input signal
%   in  the vector X and the desired signal in the vector D. The estimate
%   of the desired response signal is returned in Y.  X and D must be of
%   the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
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
%      lam = 0.995;                         % Forgetting factor
%      del = 1;                             % Soft-constrained initialization factor
%      h = adaptfilt.lsl(32,lam,del);
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
%     [1] S. Haykin, Adaptive Filter Theory, 2nd Ed.  (Englewood, 
%         Cliffs, NJ:  Prentice Hall, 1991).

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
Phi = zeros(L,1);           %  initialize temporary forward prediction error buffer
Gam = zeros(L,1);           %  initialize temporary conversion factor buffer
E = zeros(L+1,1);           %  initialize temporary joint process error buffer
Betnew = zeros(L,1);        %  initialize temporary backward least-squares error buffer
Lm1 = L-1;                  %  index variable used for signal buffers
Lp1 = L+1;                  %  index variable used for signal buffers
nnL = 1:L;                  %  index variable used for signal buffers
nnLp1 = nnL + 1;            %  index variable used for signal buffers
H    = h.Coefficients;      %  assign joint process coefficient vector
RhoF = h.FwdPrediction.Coeffs;  %  assign forward reflection coefficient vector
Alph = h.FwdPrediction.Error; %  assign forward least-squares error powers
RhoB = h.BkwdPrediction.Coeffs; %  assign backward reflection coefficient vector
Bet  = h.BkwdPrediction.Error;%  assign backward least-squares error powers
Psi  = h.States;            %  assign backward prediction errors
Psi2 = real(Psi.*conj(Psi));%  compute squares of backward prediction errors
lam  = h.ForgettingFactor;  %  assign forgetting factor

%  First iteration of forward/backward prediction updates

Phi(1) = x(1);                                  % assign current input sample
Gam(1) = 1;                                     % initialize conversion factor
Psi2 = real(Psi.*conj(Psi));                    % compute square of backward errors

for i=1:Lm1                                     % order-recursive updates
    Bet(i) = lam*Bet(i) + Gam(i)*Psi2(i);       % update backward least-squares errors
    Phi(i+1) = Phi(i) + Psi(i)*conj(RhoF(i));   % compute forward prediction errors
    Gam(i+1) = Gam(i) - Gam(i)^2*Psi2(i)/Bet(i);% compute conversion factors
end;

Bet(L) = lam*Bet(L) + Gam(L)*Psi2(L);           % update last backward least-squares error
Alph = real(lam*Alph + Gam(nnL).*Phi.*conj(Phi));  % update forward least-squares errors
RhoF = RhoF - (Gam(1:Lm1).*Psi(1:Lm1).*conj(Phi(2:L))./Bet(1:Lm1)).';  
                                                % update forward reflection coefficients
Psi(2:L) = Psi(1:Lm1) + Phi(1:Lm1).*RhoB';      % compute backward prediction errors
Psi(1) = x(1);                                  % assign current input sample
RhoB = RhoB - (Gam(1:Lm1).*Phi(1:Lm1).*conj(Psi(2:L))./Alph(1:Lm1)).'; 
                                                % update backward reflection coefficients

%  Main Loop

for n=1:ntr-1,
    
    Phi(1) = x(n+1);                            % assign future input sample
    E(1) = d(n);                                % assign current desired signal
    Gam(1) = 1;                                 % initialize conversion factor
    Psi2 = real(Psi.*conj(Psi));                % compute square of backward errors

    for i=1:Lm1                                   % order-recursive updates
        Bet(i) = lam*Bet(i) + Gam(i)*Psi2(i);     % update backward least-squares errors
        Phi(i+1) = Phi(i) + Psi(i)*conj(RhoF(i)); % compute forward prediction errors
        Gam(i+1) = Gam(i) - Gam(i)^2*Psi2(i)/Bet(i); % compute conversion factors
        E(i+1) = E(i) - Psi(i)*conj(H(i));        % compute joint process errors
    end;
    
    Bet(L) = lam*Bet(L) + Gam(L)*Psi2(L);       % update last backward least-squares error
    E(Lp1) = E(L) - Psi(L)*conj(H(L));          % compute last joint process error
    H = H + (Gam.*Psi.*conj(E(nnLp1))./Bet).';  % update joint process coefficients
    Alph = real(lam*Alph + Gam(nnL).*Phi.*conj(Phi));  % update forward least-squares errors
    RhoF = RhoF - (Gam(1:Lm1).*Psi(1:Lm1).*conj(Phi(2:L))./Bet(1:Lm1)).';  
                                                % update forward reflection coefficients
    Psi(2:L) = Psi(1:Lm1) + Phi(1:Lm1).*RhoB';  % compute backward prediction errors
    Psi(1) = x(n+1);                            % assign future input sample
    RhoB = RhoB - (Gam(1:Lm1).*Phi(1:Lm1).*conj(Psi(2:L))./Alph(1:Lm1)).'; 
                                                % update backward reflection coefficients
    e(n) = E(Lp1);                              % assign current error sample
    y(n) = d(n) - e(n);                         % compute current output sample

end;

%  Last iteration of joint process estimation updates

E(1) = d(ntr);                                  % assign current desired signal
Gam(1) = 1;                                     % initialize conversion factor
Psi2 = real(Psi.*conj(Psi));                    % compute square of backward errors

for i=1:Lm1                                     % order-recursive updates
    Betnew(i) = lam*Bet(i) + Gam(i)*Psi2(i);    % compute new backward least-squares errors
    Gam(i+1) = Gam(i) - Gam(i)^2*Psi2(i)/Betnew(i); % compute conversion factors
    E(i+1) = E(i) - Psi(i)*conj(H(i));          % compute joint process errors
end;

Betnew(L) = lam*Bet(L) + Gam(L)*Psi2(L);       % update last new backward least-squares error
E(Lp1) = E(L) - Psi(L)*conj(H(L));             % compute last joint process error
H = H + (Gam.*Psi.*conj(E(nnLp1))./Betnew).';  % update joint process coefficients
e(ntr) = E(Lp1);                               % assign last error sample
y(ntr) = d(ntr) - e(ntr);                      % compute last output sample

%  Save states

h.Coefficients = H;          %  save final joint process coefficients
fwd.Coeffs = RhoF;           %  save final forward reflection coefficients
bwd.Coeffs = RhoB;           %  save final backward reflection coefficients
fwd.Error = Alph;          %  save final forward least-squares error powers
bwd.Error = Bet;           %  save final backward least-squares error powers
h.FwdPrediction = fwd;
h.BkwdPrediction = bwd;
h.States = Psi;             %  save final backward prediction error states
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr; %  update and save total number of iterations

% [EOF]

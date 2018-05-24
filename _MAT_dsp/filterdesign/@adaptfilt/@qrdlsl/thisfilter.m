function [y,e] = thisfilter(h,x,d)
%FILTER  Execute the QR-decomposition-based least-squares lattice adaptive filter.
%   
%   Y = FILTER(H,X,D) applies an QRDLSL adaptive filter H to the input signal
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
%      lam = 0.995;                         % RLS forgetting factor
%      del = 1;                             % Soft-constrained initialization factor
%      h = adaptfilt.qrdlsl(32,lam,del);
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
%   See also ADAPTFILT.LSL

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
EpsF = zeros(L,1);          %  initialize temporary forward prediction error buffer
EpsH = zeros(L+1,1);        %  initialize temporary joint process error buffer
Lm1 = L-1;                  %  index variable used for signal buffers
Lp1 = L+1;                  %  index variable used for signal buffers
nn = 1:Lm1;                 %  index variable used for signal buffers
nnp1 = nn + 1;              %  index variable used for signal buffers
nnL = 1:L;                  %  index variable used for signal buffers
nnLp1 = nnL + 1;            %  index variable used for signal buffers
PiH  = h.Coefficients;      %  assign joint process coefficient vector
PiF  = h.FwdPrediction.Coeffs;  %  assign forward auxiliary coefficient vector
Alph = h.FwdPrediction.Error; %  assign forward least-squares error powers
PiB  = h.BkwdPrediction.Coeffs; %  assign backward auxiliary coefficient vector
Bet  = h.BkwdPrediction.Error;%  assign backward least-squares error powers
EpsB = h.States;            %  assign backward prediction errors
lam  = h.ForgettingFactor;  %  assign forgetting factor
slam  = sqrt(lam);          %  assign square root of forgetting factor

%  First iteration of forward/backward prediction updates

EpsF(1) = x(1);                                 % assign current input sample
Betold = Bet;                                   % save backward least-squares errors
Bet = lam*Bet + real(EpsB.*conj(EpsB));         % update backward least-squares errors
C = slam*sqrt(Betold./Bet);                     % compute Givens rotation factors C_b
S = conj(EpsB)./sqrt(Bet);                      % compute Givens rotation factors S_b

for i=1:Lm1                                     % order-recursive updates
    EpsF(i+1) = C(i)*EpsF(i) - conj(S(i))*slam*conj(PiF(i)); % forward prediction errors
end;

PiF = (slam*C.*PiF' + S.*EpsF)';                % update forward auxiliary parameters
Alphold = Alph(nn);                             % save forward least-squares errors
Alph = lam*Alph + real(EpsF.*conj(EpsF));       % update forward least-squares errors
C = slam*sqrt(Alphold./Alph(nn));               % compute Givens rotation factors C_f
S = conj(EpsF(nn))./sqrt(Alph(nn));             % compute Givens rotation factors S_f
EpsBold = EpsB(nn);                             % save backward prediction errors
EpsB(nnp1) = C.*EpsBold - slam*conj(S).*PiB';   % compute backward predictions errors
EpsB(1) = x(1);                                 % assign current input sample
PiB = (slam*C.*PiB' + S.*EpsBold)';             % update backward auxiliary parameters
    
%  Main Loop

for n=1:ntr-1,
    
    EpsF(1) = x(n+1);                           % assign future input sample
    EpsH(1) = d(n);                             % assign current desired response sample
    Betold = Bet;                               % save backward least-squares errors
    Bet = lam*Bet + real(EpsB.*conj(EpsB));     % update backward least-squares errors
    C = slam*sqrt(Betold./Bet);                 % compute Givens rotation factors C_b
    S = conj(EpsB)./sqrt(Bet);                  % compute Givens rotation factors S_b
    
    for i=1:Lm1                                 % order-recursive updates
        EpsF(i+1) = C(i)*EpsF(i) - conj(S(i))*slam*conj(PiF(i)); % forward prediction errors
        EpsH(i+1) = C(i)*EpsH(i) - conj(S(i))*slam*conj(PiH(i)); % joint process errors
    end;
    sGam = prod(C);                             % final conversion factor
    EpsH(Lp1) = C(L)*EpsH(L) - conj(S(L))*slam*conj(PiH(L)); % final joint process error
    
    PiF = (slam*C.*PiF' + S.*EpsF)';            % update forward auxiliary parameters
    PiH = (slam*C.*PiH' + S.*EpsH(nnL))';       % joint process auxiliary parameters
    Alphold = Alph(nn);                         % save forward least-squares errors
    Alph = lam*Alph + real(EpsF.*conj(EpsF));   % update forward least-squares errors
    C = slam*sqrt(Alphold./Alph(nn));           % compute Givens rotation factors C_b
    S = conj(EpsF(nn))./sqrt(Alph(nn));         % compute Givens rotation factors S_b
    EpsBold = EpsB(nn);                         % save backward prediction errors
    EpsB(nnp1) = C.*EpsBold - slam*conj(S).*PiB'; % compute backward predictions errors
    EpsB(1) = x(n+1);                           % assign future input sample
    PiB = (slam*C.*PiB' + S.*EpsBold)';         % update backward auxiliary parameters
    
    e(n) = EpsH(Lp1)/sGam;                      % compute current error sample
    y(n) = d(n) - e(n);                         % compute current output sample

end;

%  Last iteration of joint process estimation updates

EpsH(1) = d(ntr);                               % assign current desired signal
Betold = Bet;                                   % save backward least-squares errors
Betnew = lam*Betold + real(EpsB.*conj(EpsB));   % update backward least-squares errors
C = slam*sqrt(Betold./Betnew);                  % compute Givens rotation factors C_b
S = conj(EpsB)./sqrt(Betnew);                   % compute Givens rotation factors S_b

for i=1:Lm1                                     % order-recursive updates
    EpsH(i+1) = C(i)*EpsH(i) - conj(S(i))*slam*conj(PiH(i)); % joint process errors
end;
sGam = prod(C);                                 % final conversion factor
EpsH(Lp1) = C(L)*EpsH(L) - conj(S(L))*slam*conj(PiH(L)); % final joint process error

PiH = (slam*C.*PiH' + S.*EpsH(nnL))';           % joint process auxiliary parameters

e(ntr) = EpsH(Lp1)/sGam;                        % compute last error sample
y(ntr) = d(ntr) - e(ntr);                       % compute last output sample

%  Save states

h.Coefficients = PiH;         %  save final joint process coefficient vector
FwdPrediction.Coeffs  = PiF;  %  save final forward auxiliary coefficient vector
BkwdPrediction.Coeffs = PiB;  %  save final backward auxiliary coefficient vector
FwdPrediction.Error = Alph; %  save final forward least-squares error powers
BkwdPrediction.Error= Bet;  %  save final backward least-squares error powers
h.FwdPrediction = FwdPrediction;
h.BkwdPrediction = BkwdPrediction;
h.States = EpsB;              %  save final backward prediction error states
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr; %  update and save total number of iterations

% [EOF]

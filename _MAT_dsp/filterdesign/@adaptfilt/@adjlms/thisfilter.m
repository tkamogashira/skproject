function [y,e] = thisfilter(h,x,d)
%FILTER  Execute adjoint LMS adaptive filter.
%   Y = FILTER(H,X,D) applies a adjoint LMS adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %Active noise control of a random noise signal 
%      %(1000 iterations).
%      x  = randn(1,1000);    % Noise source
%      g  = fir1(47,0.4);     % FIR primary path system model
%      n  = 0.1*randn(1,1000);% Observation noise signal
%      d  = filter(g,1,x)+n;  % Signal to be cancelled (desired)
%      b  = fir1(31,0.5);     % FIR secondary path system model 
%      mu = 0.008;            % Adjoint LMS step size
%      h = adaptfilt.adjlms(32,mu,1,b);
%      [y,e] = filter(h,x,d);
%      plot(1:1000,d,'b',1:1000,e,'r');
%      title('Active Noise Control of a Random Noise Signal');
%      legend('Original','Attenuated');
%      xlabel('time index'); ylabel('signal value');  grid on;
%
%   See also MSESIM, RESET. 

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;         %  number of coefficients
M = h.pathord + 1;          %  number of secondary path coefficients
N = h.pathestord + 1;       %  number of secondary path estimate coefficients
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N-1,1);         %  initialize temporary input signal buffer
Y = zeros(M,1);             %  initialize temporary output signal buffer
E = zeros(N,1);             %  initialize temporary filtered input signal buffer
nnL = 1:L;                  %  index variable used for input signal buffer
nnLpNm1 = nnL + N - 1;      %  index variable used for input signal buffer
nnM = 1:M-1;                %  index variable used for output signal buffer
nnMp1 = nnM + 1;            %  index variable used for output signal buffer
nnN = 1:N-1;                %  index variable used for error signal buffer
nnNp1 = nnN + 1;            %  index variable used for error signal buffer
W = h.Coefficients;         %  initialize and assign coefficient vector
H = h.SecondaryPathCoeffs;  %  initialize and assign secondary path model
Hhatr = h.SecondaryPathEstimate(N:-1:1);  %  initialize and assign reversed secondary path model estimate
X(1:L+N-2)= h.States;       %  assign input signal buffer
Y(nnM)= h.SecondaryPathStates; %  assign output signal buffer
E(nnN)= h.ErrorStates;      %  assign error signal buffer
mu = h.StepSize;            %  assign step size
lam = h.Leakage;            %  assign leakage

%  Main loop 

for n=1:ntr,
    X(2:L+N-1) = X(1:L+N-2);%  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    Y(nnMp1) = Y(nnM);      %  shift temporary output signal buffer down
    Y(1) = W*X(nnL);        %  compute current output signal sample
    y(n) = Y(1);            %  assign current output signal sample
    E(nnNp1) = E(nnN);      %  shift temporary error signal buffer down
    E(1) = d(n) + H*Y;      %  compute current error signal sample
    e(n) = E(1);            %  assign current error signal sample
    W = lam*W - mu*(Hhatr*E)*X(nnLpNm1)'; %  update filter coefficient vector
end

%  Save states
h.SecondaryPathStates = Y(nnM); %  save final output signal states
h.ErrorStates = E(nnN);         %  save final error signal states
savestates(h,W,X,ntr,L+N-1);

% [EOF]

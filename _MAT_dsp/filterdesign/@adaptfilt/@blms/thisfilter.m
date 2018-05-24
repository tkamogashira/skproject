function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute Block LMS adaptive filter.
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
%      x  = randn(1,500);             % Input to the filter
%      b  = fir1(31,0.5);             % FIR system to be identified
%      n  = 0.1*randn(1,500);         % Observation noise signal
%      d  = filter(b,1,x)+n;          % Desired signal
%      mu = 0.008;                    % BLMS Step size
%      N  = 5;                        % block length
%      h = adaptfilt.blms(32,mu,1,N);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also MSESIM, MSEPRED, MAXSTEP, RESET.

%   Reference: 
%     [1] J.J. Shynk, "Frequency-domain and multirate adaptive 
%         filtering,"  IEEE Signal Processing Magazine, vol. 9,
%         no. 1, pp. 14-37, Jan. 1992.

%   Author(s): S.C. Douglas and R. Losada
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Check to see if input signal length is an integer number of blocks
if (rem(length(x),h.BlockLength) ~= 0),
    error(message('dsp:adaptfilt:blms:thisfilter:InvalidBlockLength'));
end

%  Variable initialization

ntr = length(x);            %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
N = h.BlockLength;             %  block length
ntrB = length(x)/N;         %  temporary number of block iterations
y = zeros(size(x));         %  initialize output signal vector
e = y;                      %  initialize error signal vector
X = zeros(L+N,1);           %  initialize temporary input signal buffer
ntrB = floor(length(x)/N);  %  number of block iterations
nnL = 1:L;                  %  index variable used for input signal buffer
nnLpN = N+1:N+L;            %  index variable used for input signal buffer
nnNpL = L+1:L+N;            %  index variable used for input signal buffer
nnLpNr = L+N:-1:N+1;        %  index variable used for coefficient updates
rN = N:-1:1;                %  index variable used for coefficient updates
W = h.Coefficients;               %  initialize and assign coefficient vector
X(nnLpNr) = h.States;       %  assign input signal buffer
mu = h.Step;                %  assign Step size
lam = h.Leakage;            %  assign Leakage

%  Main loop 

for n=1:ntrB
    nn = ((n-1)*N+1):(n*N); %  index for current signal blocks
    X(nnL) = X(nnLpN);      %  shift temporary input signal buffer up
    X(nnNpL) = x(nn);       %  assign current input signal block
    Y = filter(W,1,X);      %  compute current output signal block
    y(nn) = Y(nnNpL);       %  assign current output signal block
    e(nn) = d(nn) - y(nn);  %  compute and assign current error signal block
    G = filter(mu*e(nn(rN)),1,X');  % compute gradient for current block
    W = lam*W + G(nnLpNr);  %  update filter coefficient vector
end;

%  Save States

h.Coefficients = W;               %  save final coefficient vector
h.States = X(nnLpNr);       %  save final filter States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;      %  update and save total number of iterations
%  END OF PROGRAM

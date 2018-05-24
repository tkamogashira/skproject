function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute the fast transversal least-squares adaptive filter.
%   Y = THISFILTER(H,X,D) applies an FTF adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E]   = FILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      N  = 31;               % Adaptive filter order
%      lam = 0.99;            % RLS forgetting factor
%      del = 0.1;             % Soft-constrained initialization factor
%      h = adaptfilt.ftf(32,lam,del);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also 

%   Reference: 
%     [1] D.T.M. Slock and T. Kailath, "Numerically stable fast transversal
%         filters for recursive least squares adaptive filtering,"  IEEE
%         Trans. Signal Processing, vol. 38, no. 1, pp. 92-114, Jan. 1991.

%   Author(s): S.C. Douglas
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);                  %  temporary number of iterations 
L = h.FilterLength;               %  number of coefficients
y = zeros(size(x));               %  initialize output signal vector
e = y;                            %  initialize error signal vector
Xo = zeros(L,1);                  %  initialize temporary input signal buffer
nnL = 1:L;                        %  index variable used for input signal buffer
nLp1 = L + 1;                     %  index variable used for Kalman gain updates
W = h.Coefficients;               %  initialize and assign coefficient vector
Xo(1:L-1) = h.States;             %  assign input signal buffer
X = h.KalmanGainStates;           %  assign input signal buffer
A = h.FwdPrediction.Coeffs;       %  initialize and assign forward coefficient vector
invalph = 1/h.FwdPrediction.Error;            %  initialize forward least-squares error inverse
G = h.BkwdPrediction.Coeffs;      %  initialize and assign backward coefficient vector
bet = h.BkwdPrediction.Error;  %  initialize backward least-squares error 
gam = h.ConversionFactor;         %  initialize conversion factor
Kt = h.KalmanGain/gam;            %  initialize and assign unnormalized Kalman gain vector
lam = h.ForgettingFactor;         %  assign forgetting factor
olam = 1/lam;                     %  assign inverse forgetting factor
lamL = lam^L;                     %  assign (L)th power of forgetting factor
numrescues = 0;                   %  initialize number of rescues
ZL = zeros(1,L);                  %  assign L-element zero vector for rescues
Ki1 = 1.5;                        %  error feedback constant for stabilized FTF update
Ki2 = 2.5;                        %  error feedback constant for stabilized FTF update
Ki4 = 0.3;                        %  error feedback constant for stabilized FTF update

%  Other "hard-wired" error feedback constants:  Ki3 = 0, Ki5 = 1, Ki6 = 1

%  Main Loop

for n=1:ntr,
    
    %  Compute a priori forward prediction error 
    
    phi = x(n) - A*X;
    
    %  Update augmented Kalman gain vector quantities 
    
    rf = olam*invalph*phi;
    KtLp1 = [rf; Kt-rf*A'];
    invgamLp1 = 1/gam + real(conj(rf)*phi);
    
    %  Update forward prediction filter coefficients and least-squares error inverse
    
    f = phi*gam;            %  a posteriori forward prediction error
    A = A + Kt'*f;          %  forward prediction filter coefficients 
    invalph = olam*invalph - real(conj(rf)*rf)/invgamLp1;  
                            %  forward prediction least-squares error inverse
    
    %  Update input signal buffer for Kalman gain updates
    
    xold = X(L);            %  save last input signal sample in buffer
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    
    %  Compute a priori backward prediction error samples for stabilized updates
    
    rbs = KtLp1(nLp1);
    psis = lam*bet*rbs;     %  a priori backward prediction error (state)
    psif = xold - G*X;      %  a priori backward prediction error (filter)
    psierror = psif-psis;   %  numerical difference in backward prediction errors
    psi1 = Ki1*psierror + psis; %  a priori backward prediction error (1)
    psi2 = Ki2*psierror + psis; %  a priori backward prediction error (2)
    
    %  Update Kalman gain vector quantities 
    
    rb = rbs + Ki4*(psif/(lam*bet) - rbs);
    Kt = KtLp1(nnL) + rb*G';
    gams = 1/(invgamLp1 - real(conj(rbs)*psif));
    
    %  Update backward prediction filter coefficients and least-squares error
    
    b1 = psi1*gams;         %  a posteriori backward prediction error (1)
    b2 = psi2*gams;         %  a posteriori backward prediction error (1)
    G = G + b1*Kt';         %  backward prediction filter coefficients
    bet = lam*bet + real(conj(psi2)*b2);  %  backward prediction least-squares error
    
    %  Compute current conversion factor
    
    gam = lamL*bet*invalph;
    
    %  Check range of conversion factor and perform Kalman gain rescue if out of range
    
    if (gam > 1) || (gam < 0)    %  Conversion factor must satisfy 0 <= gamma <= 1
        
        %  Display rescue information
        
        msg = ['Kalman gain rescue at iteration ' num2str(n) '.  Conversion factor = ' num2str(gam) '.'];
        disp(msg);
        
        %  Reset Kalman gain updates
        
        A = ZL;             %  initialize forward coefficient vector
        invalph = lam/(lamL*h.InitFactor); %  initialize forward least-squares error inverse
        G = ZL;             %  initialize backward coefficient vector
        bet = h.InitFactor; %  initialize backward least-squares error 
        gam = 1;            %  initialize conversion factor
        Kt = ZL';           %  initialize unnormalized Kalman gain vector
        X = ZL.';            %  initialize input signal buffer
        
        %  Increment number of rescues
        
        numrescues = numrescues + 1;
        
        %  Stop function call if number of rescues is excessive 
        
        if (numrescues > 4)&&(n/numrescues < 4*L)
            error(message('dsp:adaptfilt:ftf:thisfilter:ExcessiveRescues', inputname( 1 )));
        end
    end
        
    %  Update input signal buffer for output and error calculations 
    
    Xo(2:L) = Xo(1:L-1);    %  shift temporary input signal buffer down
    Xo(1) = x(n);           %  assign current input signal sample
    
    %  Compute output signal, error signal, and coefficient updates
    
    y(n) = W*Xo;            %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    ep = e(n)*gam;          %  compute current a posteriori error signal sample
    W = W + ep*Kt';         %  update filter coefficient vector
    
end

%  Save States

h.Coefficients = W;        %  save final coefficient vector
h.KalmanGain = Kt*gam;     %  save final Kalman gain vector
h.ConversionFactor = gam;  %  save final conversion factor
fwd.Coeffs = A;      %  save final forward prediction coefficients
fwd.Error = 1/invalph;       %  save final forward prediction least-squares error
h.FwdPrediction = fwd;
bwd.Coeffs = G;      %  save final backward prediction coefficients
bwd.Error = bet;             %  save final backward prediction least-squares error
h.BkwdPrediction = bwd;
h.States = Xo(1:L-1);      %  save final filter States
h.KalmanGainStates = X;    %  save final Kalman gain filter States

% update and save total number of iterations
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;  


%  END OF PROGRAM

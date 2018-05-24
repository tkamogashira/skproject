function [y,e] = thisfilter(h,x,d)
%THISFILTER
% Execute the sliding-window fast transversal least-squares adaptive filter.
%   
%   Y = THISFILTER(H,X,D) applies an SWFTF adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E]   = THISFILTER(H,X,D) also returns the prediction error E.
%
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      L  = 32;               % Adaptive filter length
%      del = 0.1;             % Soft-constrained initialization factor
%      N  = 64;               % block length
%      h = adaptfilt.swftf(L,del,N);
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

%   References: 
%     [1] D.T.M. Slock and T. Kailath, "A modular prewindowing framework
%         for covariance FTF RLS algorithms," Signal Processing, vol. 28,
%         pp. 47-61, 1992.
%     [2] D.T.M. Slock and T. Kailath, "A modular multichannel multi-
%         experiment fast transversal filter RLS algorithm," Signal
%         Processing, vol. 28, pp. 25-45, 1992.

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
ntr = length(x);                 %  temporary number of iterations 
L = h.FilterLength;              %  number of coefficients
N = h.BlockLength;               %  block length 
y = zeros(size(x));              %  initialize output signal vector
e = y;                           %  initialize error signal vector
X = zeros(L+N,1);                %  initialize temporary input signal buffer
Xo = zeros(L+N-1,1);             %  initialize temporary input signal buffer
D = zeros(N,1);                  %  initialize temporary desired signal buffer
nno = 1:L+N-2;                   %  index variable used for input signal buffer
nnop1 = nno + 1;                 %  index variable used for input signal buffer
nnL = 1:L;                       %  index variable used for input signal buffer
nnLp1 = nnL + 1;                 %  index variable used for input signal buffer
nnLpNm1 = nnL + N - 1;           %  index variable used for input signal buffer
nnLpN = nnL + N;                 %  index variable used for input signal buffer
nnN = 1:N-1;                     %  index variable used for desired signal buffer
nnNp1 = nnN + 1;                 %  index variable used for desired signal buffer
Lp1 = L + 1;                     %  index variable used for Kalman gain updates
LpN = L + N;                     %  index variable used for Kalman gain updates
W = h.Coefficients;              %  initialize and assign coefficient vector
Xo(nno) = h.States;              %  assign input signal buffer
X(1:L+N-1) = h.KalmanGainStates; %  assign input signal buffer
D(nnN) = h.DesiredSignalStates;  %  assign desired signal buffer
A = h.FwdPrediction.Coeffs;      %  initialize and assign forward coefficient vector
invalph = 1/h.FwdPrediction.Error; %  initialize forward least-squares error inverse
G = h.BkwdPrediction.Coeffs;     %  initialize and assign backward coefficient vector
bet = h.BkwdPrediction.Error;  %  initialize backward least-squares error 
gam = h.ConversionFactor;        %  initialize conversion factors
Kt(:,1) = h.KalmanGain(:,1)/gam(1);  %  Assign leading Kalman gain vector
Kt(:,2) = h.KalmanGain(:,2)/gam(2);  %  Assign trailing Kalman gain vector
                            %  initialize and assign unnormalized Kalman gain vectors
numrescues = 0;             %  initialize number of rescues
ZL = zeros(1,L);            %  assign L-element zero vector for rescues

%  Main Loop

for n=1:ntr,
    
    %  Update input and desired signal buffers
    
    D(nnNp1) = D(nnN);      %  shift temporary desired signal buffer down
    D(1) = d(n);            %  assign current desired signal sample
    X(2:L+N) = X(1:L+N-1);  %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal sample
    Xo(nnop1) = Xo(nno);    %  shift temporary input signal buffer down
    Xo(1) = x(n);           %  assign current input signal sample
    
    %  Fast update for leading Kalman gain vector
    
    [A,invalph,KtLp1,invgamLp1] = fwdupdate(A,invalph,Kt(:,1),gam(1),X(nnLp1),X(1));
    [G,bet,Kt(:,1),gam(1)] = bwdupdate(G,bet,KtLp1(nnL),KtLp1(Lp1),invgamLp1,X(nnL),X(Lp1));
    
    %  Fast "down-date" for trailing Kalman gain vector
    
    [A,invalph,KtLp1,invgamLp1] = fwdupdate(A,invalph,Kt(:,2),gam(2),X(nnLpN),X(N));
    [G,bet,Kt(:,2),gam(2)] = bwdupdate(G,bet,KtLp1(nnL),KtLp1(Lp1),invgamLp1,X(nnLpNm1),X(LpN));
    
    %  Compute conversion factor for stabilized Kalman updates
    
    if (rem(n,2)==0);
        gam(1) = -bet*invalph/gam(2);
    else
        gam(2) = -bet*invalph/gam(1);
    end
    
    %  Check range of conversion factor and perform Kalman gain rescue if out of range
    
    if (gam(1) > 1) | (gam(1) <= 0)     %  Conversion factor must satisfy 0 <= gamma <= 1
        
        %  Display rescue information
        
        msg = ['Kalman gain rescue at iteration ' num2str(n) '.  Conversion factor = ' num2str(gam(1)) '.'];
        disp(msg);
        
        %  Reset Kalman gain updates
        
        A = ZL;             %  initialize forward coefficient vector
        invalph = 1/(h.InitFactor); %  initialize forward least-squares error inverse
        G = ZL;             %  initialize backward coefficient vector
        bet = h.InitFactor;      %  initialize backward least-squares error 
        gam = [1 -1];       %  initialize conversion factors
        Kt = [ZL' ZL'];     %  initialize unnormalized Kalman gain vector
        X = zeros(L+N,1);   %  initialize input signal States
        
        %  Increment number of rescues
        
        numrescues = numrescues + 1;
        
        %  Stop function call if number of rescues is excessive 
        
        if (numrescues > 4)*(n/numrescues < 4*L)
            error(message('dsp:adaptfilt:swftf:thisfilter:FilterErr'));
        end
        
    end
    
    %  Update and "down-date" adaptive filter coefficient vector
    
    [W,y(n),e(n)] = jpupdate(W,Kt(:,1),gam(1),Xo(nnL),D(1));
    W             = jpupdate(W,Kt(:,2),gam(2),Xo(nnLpNm1),D(N));
    
end

%  Save States

h.Coefficients = W;        %  save final coefficient vector
Kt(:,1) = Kt(:,1)*gam(1);  %  save final leading Kalman gain vector
Kt(:,2) = Kt(:,2)*gam(2);  %  save final trailing Kalman gain vector
h.KalmanGain = Kt;
h.ConversionFactor = gam;  %  save final conversion factor
fwd.Coeffs = A;            %  save final forward prediction coefficients
fwd.Error = 1/invalph;   %  save final forward prediction least-squares error
h.FwdPrediction = fwd;
bwd.Coeffs = G;            %  save final backward prediction coefficients
bwd.Error = bet;         %  save final backward prediction least-squares error
h.BkwdPrediction = bwd;
h.States = Xo(nno);        %  save final filter States
h.DesiredSignalStates = D(nnN);   %  save final desired signal States
h.KalmanGainStates = X(1:L+N-1);  %  save final Kalman gain States
h.NumSamplesProcessed = h.NumSamplesProcessed + ntr;     %  update and save total number of iterations

%--------------------------------------------------------------------------
function [Anew,invalphnew,KtLp1,invgamLp1] = fwdupdate(A,invalph,Kt,gam,X,xnew);

phi = xnew - A*X;           %  Compute a priori forward prediction error 
rf = invalph*phi;           %  Update augmented Kalman gain vector quantities 
KtLp1 = [rf; Kt-rf*A'];
invgamLp1 = 1/gam + real(conj(rf)*phi);
f = phi*gam;                %  a posteriori forward prediction error
Anew = A + Kt'*f;           %  forward prediction filter coefficients 
invalphnew = invalph - real(conj(rf)*rf)/invgamLp1;  %  least-squares error inverse

%--------------------------------------------------------------------------
function [Gnew,betnew,Kt,gam] = bwdupdate(G,bet,KtLp1L,rbs,invgamLp1,X,xold);

Ki1 = 0.75*sign(invgamLp1);   %  error feedback constant
Ki2 = 0.75*sign(invgamLp1)+1; %  error feedback constant
psis = bet*rbs;             %  a priori backward prediction error (state)
psif = xold - G*X;          %  a priori backward prediction error (filter)
psierror = psif-psis;       %  numerical difference in backward prediction errors
psi1 = Ki1*psierror + psis; %  a priori backward prediction error (1)
psi2 = Ki2*psierror + psis; %  a priori backward prediction error (2)
Kt = KtLp1L + rbs*G';       %  Kalman gain vector 
gam = 1/(invgamLp1 - real(conj(rbs)*psif));
b1 = psi1*gam;              %  a posteriori backward prediction error (1)
b2 = psi2*gam;              %  a posteriori backward prediction error (2)
Gnew = G + b1*Kt';          %  backward prediction filter coefficients
betnew = bet + real(conj(psi2)*b2);  %  backward prediction least-squares error

%--------------------------------------------------------------------------
function [Wnew,yn,en] = jpupdate(W,Kt,gam,X,dn);

yn = W*X;                   %  compute and assign current output signal sample
en = dn - yn;               %  compute and assign current error signal sample
ep = en*gam;                %  compute current a posteriori error signal sample
Wnew = W + ep*Kt';          %  update filter coefficient vector



%  END OF PROGRAM

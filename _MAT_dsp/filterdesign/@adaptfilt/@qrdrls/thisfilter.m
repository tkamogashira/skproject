function [y,e] = thisfilter(h,x,d)
%THISFILTER  Execute QR-decomposition-based RLS adaptive filter.
%   Y = FILTER(H,X,D) applies an QRDRLS adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D. The
%   estimate of the desired response signal is returned in Y.  X and D must
%   be of the same length.
%
%   [Y,E] = FILTER(H,X,D) also returns the prediction error E.
%
%   EXAMPLE: 
%      %System Identification of a 32-coefficient FIR filter 
%      %(500 iterations).
%      x  = randn(1,500);     % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to be identified
%      n  = 0.1*randn(1,500); % Observation noise signal
%      d  = filter(b,1,x)+n;  % Desired signal
%      G0 = sqrt(.1)*eye(32); % Initial sqrt correlation matrix 
%      lam = 0.99;            % RLS forgetting factor
%      h = adaptfilt.qrdrls(32,lam,G0);
%      [y,e] = filter(h,x,d);
%      subplot(2,1,1); plot(1:500,[d;y;e]);
%      title('System Identification of an FIR filter');
%      legend('Desired','Output','Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([b.',h.Coefficients.']);
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value'); grid on;
%
%   See also MSESIM,RESET.

%   References: 
%     [1] M. Hayes, Statistical Digital Signal Processing and Modeling
%         (New York:  Wiley, 1996). 
%     [2] S. Haykin, Adaptive Filter Theory, 3rd Ed.  (Upper Saddle 
%         River, NJ:  Prentice Hall, 1996).

%   Author(s): S.C. Douglas
%   Copyright 1999-2008 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

[Mx,Nx] = size(x);
[Md,Nd] = size(d);
checkfilterinputs(h,[Mx,Nx],[Md,Nd]);

%  Variable initialization
[ntr,L,y,e,X,W] = initfiltering(h,[Mx,Nx]); % Common stuff
R = h.SqrtCov;              %  assign Cholesky factor of input covariance matrix
P = R*W';                   %  assign P vector
slam = sqrt(h.ForgettingFactor); %  assign square root of forgetting factor
    
%  Main Loop

for n=1:ntr,
    
    %  Update input signal buffer
    
    X(2:L) = X(1:L-1);      %  shift temporary input signal buffer down
    X(1) = x(n);            %  assign current input signal 
    
    %  Compute current output and error signals
    
    y(n) = W*X;             %  compute and assign current output signal sample
    e(n) = d(n) - y(n);     %  compute and assign current error signal sample
    
    %  Update Cholesky factor and P vector via Givens rotations
    
    R = slam*R;             %  Multiply Cholesky factor by sqrt(lambda)
    P = slam*P;             %  Multiply P vector by sqrt(lambda)
    Xi = conj(X);           %  Initialize Xi vector
    E = conj(d(n));         %  Initialize error signal
    
    for i=1:L               %  Main loop of weight update
        
        nniL = i:L;         %  Index used in weight update to avoid add'l FOR loop
        
        ri = real(R(i,i));  
        xi = conj(Xi(i));
        invden = 1/sqrt(real(ri*conj(ri) + xi*conj(xi)));
        ci = ri*invden;     %  compute cos() for Givens rotation
        si = xi*invden;     %  compute sin() for Givens rotation
        
        Ri = R(i,nniL);     %  Select (i)th row of Cholesky factor
        pi = P(i);          %  Select (i)th element of P vector
        R(i,nniL) = ci*Ri + si*Xi(nniL).';  %  Givens rotations on Cholesky factor
        Xi(nniL)  = -conj(si)*Ri.' + ci*Xi(nniL);  %  Givens rotations on input vector
        P(i) = ci*pi + si*E;%  Givens rotation on (i)th element of P vector
        E = -conj(si)*pi + ci*E;  %  Givens rotations on error signal
        
    end
    
    %  Backsubstitution Step for coefficient calculation
    
    W(L) = conj(P(i)/R(i,i));  %  Calculate (L)th coefficient
    for i=L-1:-1:1;
        nnip1L = i+1:L;
        W(i) = conj((P(i) - R(i,nnip1L)*W(nnip1L)')/R(i,i));  %  Calculate (i)th coeff
    end;
    
end

%  Save States
h.SqrtCov  = R;             %  save final covariance matrix
savestates(h,W,X,ntr,L);    %  save common stuff

%  END OF PROGRAM

function den = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


if rem(specs.FilterOrder,4),
    error(message('dsp:fdfmethod:iirhalfbandeqripfpass:actualdesign:wrongOrder'));
end

n = specs.FilterOrder/2;

Fp = 0.5-(specs.TransitionWidth)/2;



m = n - 1;
Fst = 1 - Fp;

% -----------------------Initialization------------------------------------
% Initialize extremal frequencies
[wpass,wstop,w] = initialize_ex(m,n,Fp,Fst);

% Compute initial denominator
den = init_den(m,n,wpass,wstop,w);

% Setup frequency grid
[fgridpass,fgridstop,fgrid] = grid(n,Fp,Fst);

% Compute desired phase on grid
desiredph = [m*fgridpass*pi;m*fgridstop*pi+pi];

% Determine new extremals frequencies
[wpass,wstop,w,deltamax,exin,err] = new_extremals(den,fgrid,desiredph,n);

% Determine median error
delta = median(abs(err(exin)));

% ----------------------End of initialization------------------------------

% -----------------------Iteration-----------------------------------------

count = 0;
maxCount = 20;
while norm(abs(delta)-deltamax) > 1e-6 && count < maxCount,
    [den,delta] = new_den(den,delta,wpass,wstop,w,m,n);
    [wpass,wstop,w,deltamax,exin,err] = new_extremals(den,fgrid,desiredph,n);
    count = count + 1;
end

if count == maxCount,
    warning(message('dsp:fdfmethod:iirhalfbandeqripfpass:actualdesign:iterationLimit'));
end    

%--------------------------------------------------------------------------
function [wpass,wstop,w] = initialize_ex(m,n,Fp,Fst)

% Set initial frequencies
wpass = linspace(Fp/(n/2),Fp,n/2)';
wstop = linspace(Fst,1-Fp/(n/2),n/2)';
w = [wpass;wstop];

%--------------------------------------------------------------------------
function den = init_den(m,n,wpass,wstop,w)

% Compute prescribed phase at extremal frequencies
preph_pass = m*wpass*pi;
preph_stop = m*wstop*pi + pi;
preph = [preph_pass;preph_stop];

% Form matrix for system of equations
v = 0:2:n;
X = pi*w*v;
gamma = 0.5*(preph+n*w*pi);
A = sin(X-repmat(gamma,1,n/2+1));

% We know that one of the coefficients is equal to 1. Use that to rewrite
% the equations
Ar = A(:,1:end-1);
b = -A(:,end);

% Compute coefficients
denr = Ar\b; 

% Form denominator by appending leading 1. Note the flip due to ordering of
% eqs.
den = [1,flipud(upsample(denr,2))'];

%--------------------------------------------------------------------------
function [fgridpass,fgridstop,fgrid] = grid(n,Fp,Fst)

% Setup a grid
df = 16; % Density factor
fgridpass = linspace(0,Fp,df*n/2)';
fgridstop = linspace(Fst,1,df*n/2)';
fgrid     = [fgridpass;fgridstop];

%--------------------------------------------------------------------------
function [wpass,wstop,w,deltamax,exin,err] = new_extremals(den,fgrid,desiredph,n)

lgrid = length(fgrid);
% Compute the actual phase of the filter on grid
actualph = phasez(fliplr(den),den,fgrid*pi);

% Compute error on grid
err = -actualph - desiredph;

% Determine extremal indices include band-edges
exin = [local_max(err);local_max(-err)];
[a,indx] = sort(abs(err(exin)),'descend');
exin = sort(exin(indx(1:n+1))); % Keep n extremals corresponding to largest error

% Determine extremals
wpass = fgrid(exin(exin<=lgrid/2));
wstop = fgrid(exin(exin>lgrid/2));
w     = fgrid(exin);

% Determine peak error
deltamax = norm(err(exin),inf);

%--------------------------------------------------------------------------
function [den,delta] = new_den(den,delta,wpass,wstop,w,m,n)
% Compute new iteration for denominator using Newton's method (see e.g.
% Burden and Faires Numerical Analysis book page 614)

% Compute prescribed phase at extremal frequencies
preph_pass = m*wpass*pi;
preph_stop = m*wstop*pi + pi;
preph = [preph_pass;preph_stop];

v = 0:n;
X = pi*w*v;
T = preph+n*w*pi;
alpha = -.5*(-1).^(1:n+1)';

y = 1;
tol = 1e-10;
count = 0;
maxCount = 10;
while norm(y,inf) > tol && count < maxCount,
    x = [flipud(den(2:end)');delta];
    gamma = .5*(delta*(-1).^(1:n+1)'+T);
    F = sin(X-gamma*ones(1,n+1))*flipud(den');
    J = [sin(X(:,1:end-1)-gamma*ones(1,n)),alpha.*(cos(X-gamma*ones(1,n+1))*flipud(den'))];
    y = J\-F;
    x = x + y; 
    den = [1, flipud(x(1:n))'];
    delta = x(n+1);
    count = count + 1;
end

if count == maxCount,
    error(message('dsp:fdfmethod:iirhalfbandeqripfpass:actualdesign:notConverging'));
end    



% [EOF]

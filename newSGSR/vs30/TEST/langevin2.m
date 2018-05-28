function y = langevin(y0, Nt, Upot, gamma, RMSnoise, EFparam);
% langevin2 - langevin equation for anharmonic oscillator
%   y = langevin(y0, Nt, Upot, gamma, RMSnoise, EFparam);
%   Upot = [B w]


% dq = 1/gamma * (F(q) + N(t))   
%    where F(q) is oscillator force
%    N(t) is random force
%    gamma is dissipation constant
% Upot is derived from potential 0.25*q^4 + B*exp(-0.5*q^.2/w.^2)
%    So -F(q) = q.^3 - B*q/w^2.*exp(..)

% thus:
% q(ii+1) = q(ii) + F(q(ii))/gamma + N(t)/gamma
%

B = Upot(1); 
w = Upot(2);
% q = linspace(-2,2); xq = B*exp(-0.5*q.^2/w^2); plot(q, 0.25*q.^4+xq); pause

% gaussian random force
RF = RMSnoise*randn(Nt,1);

% external force: EFparam = [DC ampl freq]
DC = EFparam(1);
Ampl = EFparam(2);
freq = EFparam(3);
EF = DC + Ampl*sin(2*pi*freq*(1:Nt)).';

% total force
EF = (EF + RF)/gamma;
% initialize
y = zeros(size(RF));

%   -F(q) = q.^3 - B*q/w^2.*exp(..)
Bq = B/w^2; Bm2 = -0.5/w^2; % aux variables
y = y0;
for ii=1:Nt-1,
   q = y(ii); % current y value
   y(ii+1) = q + (-0.25*q^3 + Bq*q*exp(q^2*Bm2))/gamma + EF(ii);
end











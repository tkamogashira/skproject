function y = langevin(y0, Nt, Upot, gamma, RMSnoise, EFparam);
% langevin - langevin equation for anharmonic oscillator


% dq = 1/gamma * (F(q) + N(t))   
%    where F(q) is oscillator force
%    N(t) is randin force
%    gamma is dissipation constant
% thus:
% q(ii+1) = q(ii) + F(q(ii))/gamma + N(t)/gamma
%    For computational ease, we contract the first two terms
%    into a single polynomial:
% q(ii+1) = Feff(q(ii)) + N(t)/gamma
%    The coefficients of this "Effective force" are stored in
%    variable Peff below. N(t)/gamma is called RF below.

% determine polynomial of force from potential energy
ord = length(Upot)-1; % order of Upot polynomial
Pforce = -(ord:-1:1).*Upot(1:end-1); % force = minus polynomial derivative of Upot
% x = linspace(-2,2); plot(x, polyval(Pforce, x)); pause
Peff = Pforce/gamma; 
Peff(end-1) = Peff(end-1)+1; % first order coeff now includes self term

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

y = y0;
for ii=1:Nt-1,
   y(ii+1) = polyval(Peff, y(ii)) + EF(ii);
end











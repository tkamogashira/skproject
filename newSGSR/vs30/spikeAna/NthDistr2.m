function [t,p, Mean, Variance]=NthDistr(Pos, Ninput, Sigma, maxX, Nx);

if nargin<3,
   Sigma = 1;
end
if nargin<4,
   maxX = 5*Sigma;
end
if nargin<5,
   Nx = 5e3;
end

[Pos, Ninput] = equalizeSize(Pos,Ninput);
NNinput = length(Ninput);
if NNinput>1, % recursive call
   p = zeros(NNinput,Nx);
   Mean = zeros(NNinput,1);
   Variance = zeros(NNinput,1);
   for ii=1:NNinput,
      [t, pii, Mean(ii), Variance(ii)] = NthDistr(Pos(ii),Ninput(ii), Sigma, maxX, Nx);
      p(ii,:) = pii;
   end
   return;
end

% from here, only single distributions are computed
Sigma = Sigma*2^0.5;
t = linspace(-abs(maxX),abs(maxX),Nx); % time axis
dt = t(2)-t(1);
Nbefore = Pos -1;
Nafter = Ninput - 1 - Nbefore;
p = Ninput*(0.5*erfc(t/Sigma)).^Nafter...
   .*(1-0.5*erfc(t/Sigma)).^Nbefore...
   .*exp(-(t/Sigma).^2)*(pi)^(-0.5)/Sigma;
% normalization is screwed up - do it by hand
Norm = sum(dt*p);
p = p/Norm;
if nargout>3,
   Mean = dt*sum(p.*t);
   Variance = dt*sum(p.*(t-Mean).^2);
end







function Fricoch(Tau, x, plotArg); % tau in ms

if nargin<2, x=1; end; 
if nargin<3, plotArg='b'; figure; end; % new plot
if length(Tau)>1, % recursive call
   for ii=1:length(Tau),
      Fricoch(Tau(ii),x, ploco(ii));
   end
   return;
end

N = 1e4;
tau = Tau*1e-3; % ms->s
freq = linspace(1e-1,20,N); % freq in kHz
omega = 2e3*pi*freq; % angular freq in rad/s

otau = tau*omega; % omega*tau in cycles
%so1 = sqrt(1+otau.^2); % aux var
%Rek = omega./so1.*sqrt(so1+1);
%Imk = omega./so1.*sqrt(so1-1);

k = omega./sqrt(1-i*otau);
Rek = real(k);
Imk = imag(k);

[dum ii] = min(abs(otau-1));
Fc = freq(ii)

%AA = exp(-Imk*x);
%PP = -Rek*x;
v = k.*exp(i*k*x);
AA = abs(v);
%qqq=max(abs(diff(angle(v))))/2/pi
PP = -unwrap(angle(v));

subplot(2,1,1);
hold on;
xplot(freq, a2db(AA), plotArg);
xplot(freq(ii), a2db(AA(ii)), ['x' plotArg]);
set(gca,'xscale','log');
hold off;
subplot(2,1,2);
xplot(freq, PP/2/pi, plotArg);
xplot(freq(ii), PP(ii)/2/pi, ['x' plotArg]);

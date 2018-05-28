function [dy, Y] = duffing(t,y, freq, A, mRk0x0)
% DUFFING - duffing oscillator
%   See van Dijk and Manley, Hear. Res. 153, 14-22.

if nargin<4, A=[]; end
if nargin<5, mRk0x0=[]; end

persistent m R k0 x0 A1 A2 A3 om1 om2 om3 y0

if isempty(A),
   A = [1 1 0.01];
end
if isempty(mRk0x0),
   mRk0x0= [1 2e3 (2*pi*3e3).^2 7e-8];
end


if isequal('init', t),
   m = mRk0x0(1); R = mRk0x0(2);
   k0 = mRk0x0(3); x0 = mRk0x0(4);
   A1 = A(1); A2 = A(2); A3 = A(3);
   om1 = 2*pi*freq(1); om2 = 2*pi*freq(2); 
   om3 = 2*om1-om2+2*pi*freq(3);
   %keyboard
elseif isequal('run', t),
   tspan = y;
   T = max(tspan)-min(tspan);
   [dy, Y] = ode23(mfilename, tspan,[0;0]);
   Y = Y(:,1);
   S = hann(length(Y)).*fft(Y);
   S = a2db(abs(S));
   S = S-max(S);
   freq = (0:length(S)-1)/T;
   plot(freq, S); xlim([0 5e3]); ylim([-60 0])
else, % the differential function of the duffing osc
   F = A1*sin(om1*t)+A2*sin(om2*t)+A3*sin(om3*t); % driving force
   k = k0*(1+(y(1)/x0).^2); % nonlin stiffness
   dy = [y(2); (F-R*y(2)-k*y(1))/m];
end

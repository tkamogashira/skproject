function psi = Gabor_1d(omega,sigma,mtime,dt,shift)

%
% ガボールウェーブレット psi の生成
%  p.38  式 (2.17) (2.18)参照
%
%
%  Copyright 2001 Hiroki NAKANO
%


	t = -mtime/2:dt:mtime/2-dt;
   gauss=exp((-(t-shift).^2)/(4*sigma^2))/(2*sqrt(pi*sigma));
   psi=gauss.*exp(i*omega*(t-shift));
   
% end of file

function DY = DYQMtrans(T,Y, om1, om2, dom, k);
% DYQMtrans - differential for QMtrans
persistent OM1 OM2 DOM K

if isnan(T), % initialize
   OM1 = om1;
   OM2 = om2;
   DOM = dom;
   K = sqrt(om1*om2)*k;
   return;
end
YC = conj(Y);
alfa = K*YC(2)*Y(1);
beta = K*YC(4)*Y(3);
H = [OM1 beta 0 0; beta' OM2 0 0; 0 0 OM1+DOM alfa; 0 0 alfa' OM2+DOM];
%H = [OM1 i*real(beta) 0 0; -i*real(beta) OM2 0 0; 0 0 OM1+DOM -i*real(alfa); 0 0 i*real(alfa) OM2+DOM];
DY = -i*H*Y;
% if rand<0.01, display(H); end






%	Fp2toFr1
%	   derives fr1 from the given fp2
%
%	function [fr1,fp1] = Fp2toFr1(n,b1,c1,b2,c2,frat,fp2)
%
%	Author:  Masashi Unoki
%	Created:  3 July 2002
%	Updated: 15 July 2002
%	Revised:  9 Oct. 2003 (checked & renamed variables)
%	Copyright (c) 2002, AIS-Lab. JAIST
%
function [fr1,fp1] = Fp2toFr1(n,b1,c1,b2,c2,frat,fp2)
if nargin < 1; help Fp2toFr1; end;

SR=24000;
Nfft=1024*2;

%%%%%%% Coefficients: ERB(fr1)=alp1*fr1+alp0 %%%%%%%
alp1=24.7*4.37/1000;
alp0=24.7;

%%%%%%% Coefficients: fr2=bet1*fr2+bet0 %%%%%%%
bet1=frat*(1+c1*b1*alp1/n);
bet0=frat*c1*b1*alp0/n;

%%%%%%% Coefficients: ERB(fr2)=zet1*fr1+zet0 %%%%%%%
zet1=alp1*bet1;
zet0=alp1*bet0+alp0;

%%%%%%%	D1*fr1^3 + D2*fr1^2 + D3*fr1 + D4 = 0 %%%%%%%

D1=((b2^2*zet1^2+bet1^2)*(c1*b1*alp1+n) + (c2*b2*zet1)*(b1^2*alp1^2+1));
D2=((b2^2*zet1^2+bet1^2)*(c1*b1*alp0-n*fp2) ...
    + (2*b2^2*zet1*zet0-2*bet1*(fp2-bet0))*(c1*b1*alp1+n) ...
    + (c2*b2*zet1)*(2*b1^2*alp1*alp0-2*fp2) + (c2*b2*zet0)*(b1^2*alp1^2+1));
D3=((2*b2^2*zet1*zet0-2*bet1*(fp2-bet0))*(c1*b1*alp0-n*fp2) ...
    + (b2^2*zet0^2+(fp2-bet0)^2)*(c1*b1*alp1+n)...
    +(c2*b2*zet1)*(b1^2*alp0^2+fp2^2) + (c2*b2*zet0)*(2*b1^2*alp1*alp0-2*fp2) );
D4=(b2^2*zet0^2+(fp2-bet0)^2)*(c1*b1*alp0-n*fp2) ...
    + (c2*b2*zet0)*(b1^2*alp0^2+fp2^2);

q=roots([D1 D2 D3 D4]);
candFr1=q(imag(q)==0);

LenFr1=length(candFr1);
if (LenFr1 > 1)		% finding the maximum peak of |Gcc(f)|
   GccAtFp2=zeros(1,LenFr1);
   for m=1:LenFr1
      fr1m=candFr1(m);
      fr2m=bet1*fr1m+bet0;
      [GcFrsp1, freq1]=GammaChirpFrsp(fr1m,SR,n,b1,c1,0,Nfft);
      [dummy ERBw2] = Freq2ERB(fr2m);
      AsymFuncFrsp = exp(c2*atan2((freq1 - fr2m),(b2*ERBw2)));
      GcFrsp = GcFrsp1.*AsymFuncFrsp;
      GcFrsp = GcFrsp/max(GcFrsp);
      [dummy,pos]=min(abs(freq1-fp2));
      GccAtFp2(m)=GcFrsp(pos);
   end
   [dummy,pos]=max(GccAtFp2);
   fr1=candFr1(pos);
else
   fr1=candFr1;
end

fp1=fr1+c1*b1*(alp1*fr1+alp0)/n;

return

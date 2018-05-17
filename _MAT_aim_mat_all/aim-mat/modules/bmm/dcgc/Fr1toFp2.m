%	Fr1toFp2
%	   derives fp2 from the given fr1
%
%	function [fp2,fr2] = Fr1toFp2(n,b1,c1,b2,c2,frat,fr1,SR,Nfft)
%
%	Author:  Masashi Unoki
%	Created: 11 July 2002
%	Updated: 12 July 2002
%	Updated: 15 July 2002
%	Revised:  9 Oct. 2003 (checked & renamed variables)
%	Copyright (c) 2002, AIS-Lab. JAIST
%
function [fp2,fr2] = Fr1toFp2(n,b1,c1,b2,c2,frat,fr1,SR,Nfft)
if nargin < 1; help Fr1toFp2; end;
if nargin < 8; SR=24000; end;
if nargin < 9; Nfft=1024*2; end;

%%%%%%% Coefficients: ERB(fr1)=alp1*fr1+alp0 %%%%%%%
alp1=24.7*4.37/1000;
alp0=24.7;

ERBw1=alp1*fr1+alp0;
fp1=(1+c1*b1*alp1/n)*fr1+(c1*b1*alp0/n);
fr2=frat*fp1;
ERBw2=alp1*fr2+alp0;

%%% B1=b1*ERBw1;	% delete
%%% B2=b2*ERBw2;	% delete

%%%%%%%	E1*fp2^3 + E2*fp2^2 + E3*fp2 + E4 = 0 %%%%%%%

E1=-n;
E2=c1*b1*ERBw1+c2*b2*ERBw2+n*fr1+2*n*fr2;
E3=-2*fr2*(c1*b1*ERBw1+n*fr1)-n*((b2*ERBw2)^2+fr2^2)-2*c2*b2*ERBw2*fr1;
E4=c2*b2*ERBw2*((b1*ERBw1)^2+fr1^2)+(c1*b1*ERBw1+n*fr1)*((b2*ERBw2)^2+fr2^2);
p=roots([E1 E2 E3 E4]);
candFp2=p(imag(p)==0);

LenFp2=length(candFp2);
if (LenFp2 > 1)		% finding the maximum peak of |Gcc(f)|
   GccAtFp2=zeros(1,LenFp2);
   for m=1:LenFp2
      fp2m=candFp2(m);
      [GcFrsp1, freq1]=GammaChirpFrsp(fr1,SR,n,b1,c1,0,Nfft);
      [dummy ERBw2] = Freq2ERB(fr2);
      AsymFuncFrsp = exp(c2*atan2((freq1 - fr2),(b2*ERBw2)));
      GcFrsp = GcFrsp1.*AsymFuncFrsp;
      [dummy,pos]=min(abs(freq1-fp2m));
      GccAtFp2(m)=GcFrsp(pos);
   end
   [dummy,pos]=max(GccAtFp2);
   fp2=candFp2(pos);
else
   fp2=candFp2;
end


return

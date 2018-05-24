function Ha = design(h,hs)
%DESIGN   

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

wp = hs.Wpass;
ws = hs.Wstop;
rp = hs.Apass;
rs = hs.Astop;
[s,g] = ellipalpmin(h,wp,ws,rp,rs,h.MatchExactly);
Ha = afilt.sos(s,g);
%------------------------------------------------------------------
function [sos,g] = ellipalpmin(h,Wp,Ws,Apass,Astop,matchexact)
%ELLIPALP   


% Compute cutoff
Wc=sqrt(Wp*Ws);

% Design prototype
[sos,g,Apass,Astop] = ellipapminord(h,Wp/Wc,Apass,Astop,matchexact);

% Make transformation s -> s/Wc
sos(:,[1,4])=sos(:,[1,4])/Wc^2;

sos(:,5)=sos(:,5)/Wc;

%--------------------------------------------------------------------------
function [sos,g,Apass,Astop] = ellipapminord(h,Wp,Apass,Astop,matchexact)
% Min order ellip analog prototype.


% Determine min order
[q,k] = computeq(h,Wp);
D = (10^(0.1*Astop) - 1)/(10^(0.1*Apass) - 1);
N = ceil(log10(16*D)/log10(1/q));

switch matchexact,
    case 'passband',
        % Stopband attenuation can be found from
        Astop = 10*log10((10^(.1*Apass) - 1)/(16*q^N) + 1);
    case 'stopband',
        Apass = 10*log10(16*(q^N)*(10^(.1*Astop)-1)+1);
end

[sos,g,Astop] = apspecord(h,N,Wp,Apass,k,q);

% [EOF]

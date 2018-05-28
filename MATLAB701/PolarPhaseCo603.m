% 4HzPolarPhaseCo 603points
function LCRnumber=PolarPhaseCo603(M)
% Polar ZeroPhase vs SineAmp L/C/R
subplot(2,1,1);
h=polar([-pi pi],[0 10]);delete(h);hold on;
for d=1:size(M,2)
    if M(2,d)==1
        polar(M(6,d),M(8,d),'b.'),hold on;
    elseif M(2,d)==2
        polar(M(6,d),M(8,d),'r.'),hold on;
    else
        polar(M(6,d),M(8,d),'k.'),hold on;
    end;
end;
% Polar ZeroPhase vs Coherence graph L/C/R
subplot(2,1,2);
h2=polar([-pi pi],[0 1]);delete(h2);hold on;
for f=1:size(M,2)
    if M(2,f)==1
        polar(M(6,f),M(9,f),'b.'),hold on;
    elseif M(2,f)==2
        polar(M(6,f),M(9,f),'r.'),hold on;
    else
        polar(M(6,f),M(9,f),'k.'),hold on;
    end;
end;
LCRnumber=[nnz(M(2,:)==1);nnz(M(2,:)==0);nnz(M(2,:)==2)];
end




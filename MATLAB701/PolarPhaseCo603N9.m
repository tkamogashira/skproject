% 4HzPolarPhaseCo 603points N9
function PolarPhaseCo603N9(M1,M2,M3,M4,M5,M6,M7,M8,M9)
% Polar ZeroPhase vs SineAmp L/C/R
subplot(2,1,1);
h=polar([-pi pi],[0 10]);delete(h);hold on;
for d1=1:size(M1,2)
    if M1(2,d1)==1
        polar(M1(6,d1),M1(8,d1),'b.'),hold on;
    elseif M1(2,d1)==2
        polar(M1(6,d1),M1(8,d1),'r.'),hold on;
    else
        polar(M1(6,d1),M1(8,d1),'k.'),hold on;
    end;
end;
hold on;
for d2=1:size(M2,2)
    if M2(2,d2)==1
        polar(M2(6,d2),M2(8,d2),'b.'),hold on;
    elseif M2(2,d2)==2
        polar(M2(6,d2),M2(8,d2),'r.'),hold on;
    else
        polar(M2(6,d2),M2(8,d2),'k.'),hold on;
    end;
end;
hold on;
for d3=1:size(M3,2)
    if M3(2,d3)==1
        polar(M3(6,d3),M3(8,d3),'b.'),hold on;
    elseif M3(2,d3)==2
        polar(M3(6,d3),M3(8,d3),'r.'),hold on;
    else
        polar(M3(6,d3),M3(8,d3),'k.'),hold on;
    end;
end;
hold on;
for d4=1:size(M4,2)
    if M4(2,d4)==1
        polar(M4(6,d4),M4(8,d4),'b.'),hold on;
    elseif M4(2,d4)==2
        polar(M4(6,d4),M4(8,d4),'r.'),hold on;
    else
        polar(M4(6,d4),M4(8,d4),'k.'),hold on;
    end;
end;
hold on;



% Polar ZeroPhase vs Coherence graph L/C/R
subplot(2,1,2);
h2=polar([-pi pi],[0 1]);delete(h2);hold on;
for f1=1:size(M1,2)
    if M1(2,f1)==1
        polar(M1(6,f1),M1(9,f1),'b.'),hold on;
    elseif M1(2,f1)==2
        polar(M1(6,f1),M1(9,f1),'r.'),hold on;
    else
        polar(M1(6,f1),M1(9,f1),'k.'),hold on;
    end;
end;
hold on;
for f2=1:size(M2,2)
    if M2(2,f2)==1
        polar(M2(6,f2),M2(9,f2),'b.'),hold on;
    elseif M2(2,f2)==2
        polar(M2(6,f2),M2(9,f2),'r.'),hold on;
    else
        polar(M2(6,f2),M2(9,f2),'k.'),hold on;
    end;
end;
end




% PtoMap
function SigChN=PtoMap(P,N)
for C=1:202
    if P(N,C)<0.01
        plot(P(126,C),P(127,C),'k*'),hold on;
    end;
end;
plot(P(126,find(P(125,(1:202))>0)),P(127,find(P(125,(1:202))>0)),'ko'),hold on;
plot(P(126,find(P(125,(1:202))==0)),P(127,find(P(125,(1:202))==0)),'k.'),hold on;
end




% EvCh202forFn
function EvCh=EvCh202forFn(Ev,Fs,Fn)
EvCh=[Fs;Ev(Fn,:)];
for l=1:202
    if EvCh(2,l)>0
        plot(EvCh(3,l),EvCh(4,l),'ko'),hold on
    else
        plot(EvCh(3,l),EvCh(4,l),'k.'),hold on
    end
end
for m=1:202
    if EvCh(5,m)>0
        plot(EvCh(3,m),EvCh(4,m),'k*'),hold on
    end
end
end  
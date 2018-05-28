% M Chs Phase
function ChsPhase(M)
for n=1:size(M,2)
    if M(7,n)==1
        plot(M(3,n),M(4,n),'ob'),grid,hold on;
    elseif M(7,n)==2
        plot(M(3,n),M(4,n),'or'),grid,hold on;
    else
        plot(M(3,n),M(4,n),'ok'),grid,hold on;
    end;
    axis([-pi pi 0 10]);set(gca,'xtick',[-pi -pi/2 0 pi/2 pi]);
end;
end
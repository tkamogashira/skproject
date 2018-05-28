% M Chs Phase N9 5zones
function ChsPhaseN9_5(M)
for n=1:size(M,2)
    if M(10,n)==1
        plot(M(3,n),M(4,n),'Marker','<', 'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10),grid,hold on;
    elseif M(10,n)==2
        plot(M(3,n),M(4,n),'Marker','>', 'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',10),grid,hold on;
    elseif M(10,n)==3
        plot(M(3,n),M(4,n),'Marker','^', 'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12),grid,hold on;
    elseif M(10,n)==4
        plot(M(3,n),M(4,n),'Marker','o', 'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',10),grid,hold on;        
    else
        plot(M(3,n),M(4,n),'Marker','o', 'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10),grid,hold on;
    end;
    axis([-pi pi 0 6]);set(gca,'xtick',[-pi -pi/2 0 pi/2 pi]);
end;
end
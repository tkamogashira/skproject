for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).CD+CFcombiselectALL(n).CPr*1000/CFcombiselectALL(n).BF;
    y=CFcombiselectALL(n).BestITD;
    plot(x,y,'o');hold on;grid on;
    xlabel('CD+CPr*1000/DF ...DF from Composite Curve');ylabel('BestITD ...from Composite Curve');
    title('Best ITD = CD + CPr*1000/DF');
end;



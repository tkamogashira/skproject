for n=1:length(BBICselectWithCF) 
    x=BBICselectWithCF(n).CD+BBICselectWithCF(n).CPr*1000/BBICselectWithCF(n).DomF;
    y=BBICselectWithCF(n).BestITD;
    if (y>=-2)&(y<=2)
        plot(x,y,'o');hold on;grid on;
        xlabel('CD+CPr*1000/DF ...DF from Difcor');ylabel('BestITD ...from Difcor');
        title('ICdata   Best ITD = CD + CPr*1000/DF')
    end;
end;



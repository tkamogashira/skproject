function pairtest(MM,a,b)

for n=a:b
    x=MM(n).IPCx;y=MM(n).IPCy;X=MM(n).ISRx;Y=MM(n).ISRy;
    if (MM(n).CP < -0.5)|(MM(n).CP >= 0.5)
        %MM(n).CPr=MM(n).CP-round(MM(n).CP);
        y=y+(MM(n).CPr-MM(n).CP);
    %else
        %MM(n).CPr=MM(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %MM(n).BPr=MM(n).CPr+(MM(n).CD/1000)*MM(n).BF;
    xb=MM(n).BF;yb=MM(n).BPr;
    %MM(n).CF1p=MM(n).CPr+(MM(n).CD/1000)*MM(n).CF1;
    x1=MM(n).CF1;y1=MM(n).CF1p;
    %MM(n).CF2p=MM(n).CPr+(MM(n).CD/1000)*MM(n).CF2;
    x2=MM(n).CF2;y2=MM(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',10);%CFc
    plot(x2,y2,'>','MarkerSize',10,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=MM(n).CPr+(MM(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(MM(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    xlim([0 4000]);%axis([0 4000 -3 3]);
end;
hold off;
xlabel('Tone frequency (Hz)');
ylabel('Interaural phase (cycles)')






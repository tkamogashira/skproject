CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

subplot(1,3,1);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    plot(x(xind),(y(xind))*1000./x(xind));hold on
    line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(1,3,2);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    plot(x(xind),(y(xind))*1000./x(xind));hold on
    %line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(1,3,3);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    %plot(x(xind),(y(xind))*1000./x(xind));hold on
    line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

figure
subplot(2,3,1);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-1.0 & CFcombiselectALL(n).CD<-0.6
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

subplot(2,3,2);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-0.6 & CFcombiselectALL(n).CD<-0.2
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

subplot(2,3,3);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-0.2 & CFcombiselectALL(n).CD<0.2
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

subplot(2,3,4);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=0.2 & CFcombiselectALL(n).CD<0.6
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

subplot(2,3,5);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=0.6 & CFcombiselectALL(n).CD<1.0
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

subplot(2,3,6);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=1.0 & CFcombiselectALL(n).CD<1.4
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(-0.5)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',6,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -6 6]);
hold off;

CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

structplot(CFcombiselectALL,'CF2','CD')

figure
subplot(1,3,1);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
    if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
        y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
    else
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
    CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

    %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    plot(x(xind),(y(xind))*1000./x(xind));hold on
    line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(1,3,2);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
    if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
        y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
    else
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
    CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

    %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    plot(x(xind),(y(xind))*1000./x(xind));hold on
    %line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(1,3,3);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
    CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
    if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
        y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
    else
        CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
    xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
    CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
    x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
    %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

    %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
    %plot(x(xind),(y(xind))*1000./x(xind));hold on
    line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;


%Classify by CD
figure
subplot(2,3,1);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-1.0 & CFcombiselectALL(n).CD<-0.6
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(2,3,2);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-0.6 & CFcombiselectALL(n).CD<-0.2
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');        
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(2,3,3);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=-0.2 & CFcombiselectALL(n).CD<0.2
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');        
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(2,3,4);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=0.2 & CFcombiselectALL(n).CD<0.6
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');        
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(2,3,5);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=0.6 & CFcombiselectALL(n).CD<1.0
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');        
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;

subplot(2,3,6);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CD>=1.0 & CFcombiselectALL(n).CD<1.4
        x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;X=CFcombiselectALL(n).ISRx;Y=CFcombiselectALL(n).ISRy;
        CFcombiselectALL(n).CF2P=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
    
        if (CFcombiselectALL(n).CF2P < -0.5)|(CFcombiselectALL(n).CF2P >= 0.5)
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P-round(CFcombiselectALL(n).CF2P);
            y=y+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2Pr-CFcombiselectALL(n).CF2P);
        else
            CFcombiselectALL(n).CF2Pr=CFcombiselectALL(n).CF2P;
            CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
        end;
        
        [YM,YMi]=max(Y);
        CFcombiselectALL(n).BPrr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).BF;
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BPrr;
        CFcombiselectALL(n).CF1Prr=CFcombiselectALL(n).CPrr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF1;
        x1=CFcombiselectALL(n).CF1;y1=CFcombiselectALL(n).CF1Prr;
        %CFcombiselectALL(n).CF2p=CFcombiselectALL(n).CPr+(CFcombiselectALL(n).CD/1000)*CFcombiselectALL(n).CF2;
        x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2Pr;

        %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
        xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(0.5)));
        plot(x(xind),(y(xind))*1000./x(xind));hold on
        line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
        %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
        plot(x2,y2*1000/x2,'>','MarkerSize',2,'Color','k','MarkerFaceColor','k');        
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');axis([0 4000 -2 2]);
hold off;



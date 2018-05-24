CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for n=1:length(CFcombiselectALL)
    plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
end;
hold off;

%Classification by DeltaCF
figure
subplot(2,3,1)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF<0.05
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(2,3,2)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF>=0.05 & CFcombiselectALL(n).DeltaCF<0.1
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(2,3,3)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF>=0.1 & CFcombiselectALL(n).DeltaCF<0.15
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(2,3,4)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF>=0.15 & CFcombiselectALL(n).DeltaCF<0.2
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(2,3,5)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF>=0.2 & CFcombiselectALL(n).DeltaCF<0.25
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(2,3,6)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).DeltaCF>=0.25
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

%Classification by CF2 (CFi)
figure
subplot(3,3,1)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2<500
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,2)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=500 & CFcombiselectALL(n).CF2<1000
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,3)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=1000 & CFcombiselectALL(n).CF2<1500
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,4)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=1500 & CFcombiselectALL(n).CF2<2000
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,5)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=2000 & CFcombiselectALL(n).CF2<2500
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,6)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=2500 & CFcombiselectALL(n).CF2<3000
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,7)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=3000 & CFcombiselectALL(n).CF2<3500
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;

subplot(3,3,8)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=3500
        plot(CFcombiselectALL(n).IPCx,(CFcombiselectALL(n).IPCy)*1000./CFcombiselectALL(n).IPCx);hold on
        x=CFcombiselectALL(n).IPCx;line(x,(x.^(-1))*1000*CFcombiselectALL(n).CPr+ones(1,length(x))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    end;
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');
hold off;






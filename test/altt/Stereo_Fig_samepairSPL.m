

for n=1:length(CFcombiselect8121)
    CFcombiselect8121(n).spl=CFcombiselect8121(n).SPL1(1);
    
    space=findstr(CFcombiselect8121(n).Fiber1, ' ');
    allhy=findstr(CFcombiselect8121(n).Fiber1, '-');
    hy=allhy(1);
    a1=CFcombiselect8121(n).Fiber1(1:(space-1));
    b1=CFcombiselect8121(n).Fiber1((space+1):(hy-1));
    name1=[a1 ' ' b1];
    
    space=findstr(CFcombiselect8121(n).Fiber2, ' ');
    allhy=findstr(CFcombiselect8121(n).Fiber2, '-');
    hy=allhy(1);
    a2=CFcombiselect8121(n).Fiber2(1:(space-1));
    b2=CFcombiselect8121(n).Fiber2((space+1):(hy-1));
    name2=[a2 ' ' b2];
    
    CFcombiselect8121(n).ds1.filename=[name1 ' ' name2];
    CFcombiselect8121(n).ds1.icell=[b1 ' ' b2];
end;
for n=1:length(CFcombiselect8121)    
    same=CFcombiselect8121(n);
    
    for k=1:length(CFcombiselect8121)
        if strcmp(CFcombiselect8121(k).ds1.filename, CFcombiselect8121(n).ds1.filename)==1
            same=[same,CFcombiselect8121(k)];
        end;
    end;
    L=length(same);
    same=same(2:L);clear L;
    
    if length(same)>=2;
        CFcombiselect8121(n).solo=0;
    else
        CFcombiselect8121(n).solo=1;
    end;
    
    clear same;
end;
CFcombiselect8121multi=structfilter(CFcombiselect8121, '$solo$ == 0');
CFcombiselect8121multi=structsort(CFcombiselect8121multi,'$ds1.filename$')
assignin('base','CFcombiselect8121multi',CFcombiselect8121multi);

list=[{CFcombiselect8121multi(1).ds1.filename}];
for n=2:length(CFcombiselect8121multi)
    if strcmp(CFcombiselect8121multi(n-1).ds1.filename, CFcombiselect8121multi(n).ds1.filename)==0
        list=[list;[{CFcombiselect8121multi(n).ds1.filename}]];
    end;
end;
list
for p=1:length(list)
    gr(1)=CFcombiselect8121multi(1);
    for m=1:length(CFcombiselect8121multi)
        if strcmp(CFcombiselect8121multi(m).ds1.filename, char(list(p)))==1
            gr=[gr,CFcombiselect8121multi(m)];
        end;
    end;
    q=length(gr);
    gr=gr(2:q);
    gr=structsort(gr, '$spl$');
    line([gr.spl], [gr.CD], 'color','k','marker','o');hold on;
    xlabel('Tone intensity (dB)');ylabel('CD (ms)');ylim([-1 1.5]);
    clear gr;clear q;
    display(p)
end;
hold off;

figure
for p=1:length(list)
    gr(1)=CFcombiselect8121multi(1);
    for m=1:length(CFcombiselect8121multi)
        if strcmp(CFcombiselect8121multi(m).ds1.filename, char(list(p)))==1
            gr=[gr,CFcombiselect8121multi(m)];
        end;
    end;
    q=length(gr);
    gr=gr(2:q);
    gr=structsort(gr, '$spl$');
    line([gr.spl], [gr.CPr], 'color','k','marker','o');hold on;
    xlabel('Tone intensity (dB)');ylabel('CP (cycles)');
    clear gr;clear q;
    display(p)
end;
hold off;

figure
for p=1:length(list)
    gr(1)=CFcombiselect8121multi(1);
    for m=1:length(CFcombiselect8121multi)
        if strcmp(CFcombiselect8121multi(m).ds1.filename, char(list(p)))==1
            gr=[gr,CFcombiselect8121multi(m)];
        end;
    end;
    q=length(gr);
    gr=gr(2:q);
    gr=structsort(gr, '$spl$');
    line([gr.spl], [gr.BF], 'color','k','marker','o');hold on;
    xlabel('Tone intensity (dB)');ylabel('Dominant frequency (Hz)');
    clear gr;clear q;
    display(p)
end;
hold off;

%8121 example 4 SPLs for 1 pair
figure
for n=39:42
    x=CFcombiselect8121multi(n).IPCx;y=CFcombiselect8121multi(n).IPCy;X=CFcombiselect8121multi(n).ISRx;Y=CFcombiselect8121multi(n).ISRy;
    if (CFcombiselect8121multi(n).CP < -0.5)|(CFcombiselect8121multi(n).CP >= 0.5)
        %CFcombiselect8121multi(n).CPr=CFcombiselect8121multi(n).CP-round(CFcombiselect8121multi(n).CP);
        y=y+(CFcombiselect8121multi(n).CPr-CFcombiselect8121multi(n).CP);
    %else
        %CFcombiselect8121multi(n).CPr=CFcombiselect8121multi(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect8121multi(n).BPr=CFcombiselect8121multi(n).CPr+(CFcombiselect8121multi(n).CD/1000)*CFcombiselect8121multi(n).BF;
    xb=CFcombiselect8121multi(n).BF;yb=CFcombiselect8121multi(n).BPr;
    %CFcombiselect8121multi(n).CF1p=CFcombiselect8121multi(n).CPr+(CFcombiselect8121multi(n).CD/1000)*CFcombiselect8121multi(n).CF1;
    x1=CFcombiselect8121multi(n).CF1;y1=CFcombiselect8121multi(n).CF1p;
    %CFcombiselect8121multi(n).CF2p=CFcombiselect8121multi(n).CPr+(CFcombiselect8121multi(n).CD/1000)*CFcombiselect8121multi(n).CF2;
    x2=CFcombiselect8121multi(n).CF2;y2=CFcombiselect8121multi(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    %plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    %plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',10);%CFc
    plot(x2,y2,'>','MarkerSize',10,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect8121multi(n).CPr+(CFcombiselect8121multi(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect8121multi(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    xlim([0 4000]);%axis([0 4000 -3 3]);
end;
hold off;
xlabel('Tone frequency (Hz)');
ylabel('Interaural phase (cycles)')

%241
for n=1:length(CFcombiselect241)
    CFcombiselect241(n).spl=CFcombiselect241(n).SPL1(1);
    
    space=findstr(CFcombiselect241(n).Fiber1, ' ');
    allhy=findstr(CFcombiselect241(n).Fiber1, '-');
    hy=allhy(1);
    a1=CFcombiselect241(n).Fiber1(1:(space-1));
    b1=CFcombiselect241(n).Fiber1((space+1):(hy-1));
    name1=[a1 ' ' b1];
    
    space=findstr(CFcombiselect241(n).Fiber2, ' ');
    allhy=findstr(CFcombiselect241(n).Fiber2, '-');
    hy=allhy(1);
    a2=CFcombiselect241(n).Fiber2(1:(space-1));
    b2=CFcombiselect241(n).Fiber2((space+1):(hy-1));
    name2=[a2 ' ' b2];
    
    CFcombiselect241(n).ds1.filename=[name1 ' ' name2];
    CFcombiselect241(n).ds1.icell=[b1 ' ' b2];
end;
for n=1:length(CFcombiselect241)    
    same=CFcombiselect241(n);
    
    for k=1:length(CFcombiselect241)
        if strcmp(CFcombiselect241(k).ds1.filename, CFcombiselect241(n).ds1.filename)==1
            same=[same,CFcombiselect241(k)];
        end;
    end;
    L=length(same);
    same=same(2:L);clear L;
    
    if length(same)>=2;
        CFcombiselect241(n).solo=0;
    else
        CFcombiselect241(n).solo=1;
    end;
    
    clear same;
end;
CFcombiselect241multi=structfilter(CFcombiselect241, '$solo$ == 0');
assignin('base','CFcombiselect241multi',CFcombiselect241multi);

%242
for n=1:length(CFcombiselect242)
    CFcombiselect242(n).spl=CFcombiselect242(n).SPL1(1);
    
    space=findstr(CFcombiselect242(n).Fiber1, ' ');
    allhy=findstr(CFcombiselect242(n).Fiber1, '-');
    hy=allhy(1);
    a1=CFcombiselect242(n).Fiber1(1:(space-1));
    b1=CFcombiselect242(n).Fiber1((space+1):(hy-1));
    name1=[a1 ' ' b1];
    
    space=findstr(CFcombiselect242(n).Fiber2, ' ');
    allhy=findstr(CFcombiselect242(n).Fiber2, '-');
    hy=allhy(1);
    a2=CFcombiselect242(n).Fiber2(1:(space-1));
    b2=CFcombiselect242(n).Fiber2((space+1):(hy-1));
    name2=[a2 ' ' b2];
    
    CFcombiselect242(n).ds1.filename=[name1 ' ' name2];
    CFcombiselect242(n).ds1.icell=[b1 ' ' b2];
end;
for n=1:length(CFcombiselect242)    
    same=CFcombiselect242(n);
    
    for k=1:length(CFcombiselect242)
        if strcmp(CFcombiselect242(k).ds1.filename, CFcombiselect242(n).ds1.filename)==1
            same=[same,CFcombiselect242(k)];
        end;
    end;
    L=length(same);
    same=same(2:L);clear L;
    
    if length(same)>=2;
        CFcombiselect242(n).solo=0;
    else
        CFcombiselect242(n).solo=1;
    end;
    
    clear same;
end;
CFcombiselect242multi=structfilter(CFcombiselect242, '$solo$ == 0');
assignin('base','CFcombiselect242multi',CFcombiselect242multi);

%898
for n=1:length(CFcombiselect898)
    CFcombiselect898(n).spl=CFcombiselect898(n).SPL1(1);
    
    space=findstr(CFcombiselect898(n).Fiber1, ' ');
    allhy=findstr(CFcombiselect898(n).Fiber1, '-');
    hy=allhy(1);
    a1=CFcombiselect898(n).Fiber1(1:(space-1));
    b1=CFcombiselect898(n).Fiber1((space+1):(hy-1));
    name1=[a1 ' ' b1];
    
    space=findstr(CFcombiselect898(n).Fiber2, ' ');
    allhy=findstr(CFcombiselect898(n).Fiber2, '-');
    hy=allhy(1);
    a2=CFcombiselect898(n).Fiber2(1:(space-1));
    b2=CFcombiselect898(n).Fiber2((space+1):(hy-1));
    name2=[a2 ' ' b2];
    
    CFcombiselect898(n).ds1.filename=[name1 ' ' name2];
    CFcombiselect898(n).ds1.icell=[b1 ' ' b2];
end;
for n=1:length(CFcombiselect898)    
    same=CFcombiselect898(n);
    
    for k=1:length(CFcombiselect898)
        if strcmp(CFcombiselect898(k).ds1.filename, CFcombiselect898(n).ds1.filename)==1
            same=[same,CFcombiselect898(k)];
        end;
    end;
    L=length(same);
    same=same(2:L);clear L;
    
    if length(same)>=2;
        CFcombiselect898(n).solo=0;
    else
        CFcombiselect898(n).solo=1;
    end;
    
    clear same;
end;
CFcombiselect898multi=structfilter(CFcombiselect898, '$solo$ == 0');
assignin('base','CFcombiselect898multi',CFcombiselect898multi);




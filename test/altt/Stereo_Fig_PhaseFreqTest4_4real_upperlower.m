CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];


%from real phase-frequency curve, window:[CFi*(2^(-1/3)) CFi*(2^(1/3))]
subplot(4,3,1);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2<500
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2<500
    M=[M CFcombiselectALL(n).DFC];
    end;
end;
L=size(M,2);
M=M(:,(2:L));
for k=1:80
    kind=find(M(1,:)==50*k);
    if isempty(M(2,kind))==0
        plot(50*k,mean(M(2,kind)),'o','MarkerSize',5,'Color','b','MarkerFaceColor','b');hold on;
    
        Min=min(M(2,kind));
        Max=max(M(2,kind));
        line([50*k 50*k],[Min(1) Max(1)],'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','b');hold on;
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,3);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2<500
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    %CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
%plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');
axis([0 4000 0 1]);
hold off;

subplot(4,3,4);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=500 & CFcombiselectALL(n).CF2<1000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,5);
M=[0;0];
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=500 & CFcombiselectALL(n).CF2<1000
    M=[M CFcombiselectALL(n).DFC];
    end;
end;
L=size(M,2);
M=M(:,(2:L));
for k=1:80
    kind=find(M(1,:)==50*k);
    if isempty(M(2,kind))==0
        plot(50*k,mean(M(2,kind)),'o','MarkerSize',5,'Color','b','MarkerFaceColor','b');hold on;
    
        Min=min(M(2,kind));
        Max=max(M(2,kind));
        line([50*k 50*k],[Min(1) Max(1)],'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','b');hold on;
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,6);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=500 & CFcombiselectALL(n).CF2<1000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    %CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
%plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');
axis([0 4000 0 1]);
hold off;

subplot(4,3,7);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=1000 & CFcombiselectALL(n).CF2<2000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,8);
M=[0;0];
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=1000 & CFcombiselectALL(n).CF2<2000
    M=[M CFcombiselectALL(n).DFC];
    end;
end;
L=size(M,2);
M=M(:,(2:L));
for k=1:80
    kind=find(M(1,:)==50*k);
    if isempty(M(2,kind))==0
        plot(50*k,mean(M(2,kind)),'o','MarkerSize',5,'Color','b','MarkerFaceColor','b');hold on;
    
        Min=min(M(2,kind));
        Max=max(M(2,kind));
        line([50*k 50*k],[Min(1) Max(1)],'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','b');hold on;
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,9);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=1000 & CFcombiselectALL(n).CF2<2000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    %CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
%plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');
axis([0 4000 0 1]);
hold off;

subplot(4,3,10);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=2000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,11);
M=[0;0];
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=2000
    M=[M CFcombiselectALL(n).DFC];
    end;
end;
L=size(M,2);
M=M(:,(2:L));
for k=1:80
    kind=find(M(1,:)==50*k);
    if isempty(M(2,kind))==0
        plot(50*k,mean(M(2,kind)),'o','MarkerSize',5,'Color','b','MarkerFaceColor','b');hold on;
    
        Min=min(M(2,kind));
        Max=max(M(2,kind));
        line([50*k 50*k],[Min(1) Max(1)],'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','b');hold on;
    end;
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(4,3,12);
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).CF2>=2000
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*((2^(1/3))));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    %CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
    end;
end;
f=(100:1:4000);
%plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');
axis([0 4000 0 1]);
hold off;


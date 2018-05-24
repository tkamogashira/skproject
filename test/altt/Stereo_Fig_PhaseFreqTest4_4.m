CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];


for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    plot(x,y,'--');hold on;
    plot(x,yn,'-');hold on;
end;hold off;

figure
for n=1:length(CFcombiselectALL)
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
    
    plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    %xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    %line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 -2 2]);
hold off;

figure
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    Y=x*(CFcombiselectALL(n).CD/1000)+ones(1,length(x))*CFcombiselectALL(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    plot(x,Y,'--');hold on;
    plot(x,Yn,'r-');hold on;
end;hold off;


figure %from real phase-frequency curve, window:[CFi CFi*(2^(1/3))]
subplot(1,2,1);
for n=1:length(CFcombiselectALL)
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
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(1,2,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    M=[M CFcombiselectALL(n).DFC];
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

figure %from real phase-frequency curve, window:[CFi*(2^(-1/3)) CFi]
subplot(1,2,1);
for n=1:length(CFcombiselectALL)
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
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*(2^(0)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(1,2,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    M=[M CFcombiselectALL(n).DFC];
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

figure %from linear regression line, window:[CFi CFi*(2^(1/3))]
subplot(1,2,1);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    Y=x*(CFcombiselectALL(n).CD/1000)+ones(1,length(x))*CFcombiselectALL(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=Yn(Lind)+(Yn(Rind)-Yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;Y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,Y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),Yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);Yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(1,2,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    M=[M CFcombiselectALL(n).DFC];
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

figure %from linear regression line, window:[CFi*(2^(-1/3)) CFi]
subplot(1,2,1);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    Y=x*(CFcombiselectALL(n).CD/1000)+ones(1,length(x))*CFcombiselectALL(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=Yn(Lind)+(Yn(Rind)-Yn(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL(n).CF2;Y2=CFcombiselectALL(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,Y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL(n).CF2*(2^(0)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),Yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);Yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(1,2,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    M=[M CFcombiselectALL(n).DFC];
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

figure %from real phase-frequency curve, window:[DF DF*(2^(1/3))]
subplot(1,2,1);
for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).BF;
    Lind=min(find(xdif>0));
    Rind=max(find(xdif<0));
    if isempty(Lind)==0 & isempty(Rind)==0
        CFcombiselectALL(n).BFph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL(n).BF-x(Lind))/(x(Rind)-x(Lind));%Phase at BF on real curve
    
        xb=CFcombiselectALL(n).BF;yb=CFcombiselectALL(n).BFph;
    
        %plot(x,yn*1000./x);hold on;
        plot(xb,yb*1000/xb,'>','MarkerSize',5,'Color','m','MarkerFaceColor','m');hold on;
    end;
    xind=find(x>=CFcombiselectALL(n).BF*(2^(0)) & x<=CFcombiselectALL(n).BF*(2^(1/3)));%Window at BF
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    CFcombiselectALL(n).DFC=[x(xind);yn(xind)*1000./x(xind)];
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(1,2,2);
M=[0;0];
for n=1:length(CFcombiselectALL)
    M=[M CFcombiselectALL(n).DFC];
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


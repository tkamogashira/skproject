CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];
for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;
CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');

for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    plot(x,y,'--');hold on;
    plot(x,yn,'-');hold on;
end;hold off;

figure
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2ph;
    
    plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    %xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(0)) & x<=CFcombiselectALL_70(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    %line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL_70(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL_70(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 -2 2]);
hold off;

figure
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    Y=x*(CFcombiselectALL_70(n).CD/1000)+ones(1,length(x))*CFcombiselectALL_70(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    plot(x,Y,'--');hold on;
    plot(x,Yn,'r-');hold on;
end;hold off;


figure
subplot(2,3,1);
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(0)) & x<=CFcombiselectALL_70(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(2,3,2);
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL_70(n).CF2*(2^(0)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(2,3,3);
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
    yn=y;
    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL_70(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(2,3,4);%linear regression
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    Y=x*(CFcombiselectALL_70(n).CD/1000)+ones(1,length(x))*CFcombiselectALL_70(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=Yn(Lind)+(Yn(Rind)-Yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;Y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,Y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(0)) & x<=CFcombiselectALL_70(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),Yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(2,3,5);%linear regression
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    Y=x*(CFcombiselectALL_70(n).CD/1000)+ones(1,length(x))*CFcombiselectALL_70(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=Yn(Lind)+(Yn(Rind)-Yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;Y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,Y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL_70(n).CF2*(2^(0)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),Yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

subplot(2,3,6);%linear regression
for n=1:length(CFcombiselectALL_70)
    x=CFcombiselectALL_70(n).IPCx;y=CFcombiselectALL_70(n).IPCy;
    Y=x*(CFcombiselectALL_70(n).CD/1000)+ones(1,length(x))*CFcombiselectALL_70(n).CP;
    negYind1=find(Y>=-1 & Y<0);negYind2=find(Y>=-2 & Y<-1);negYind3=find(Y>=-3 & Y<-2);
    posYind1=find(Y>=1 & Y<2);posYind2=find(Y>=2 & Y<3);
    Yn=Y;
    Yn(negYind1)=Y(negYind1)+1;Yn(negYind2)=Y(negYind2)+2;Yn(negYind3)=Y(negYind3)+3;
    Yn(posYind1)=Y(posYind1)-1;Yn(posYind2)=Y(posYind2)-2;
    
    xdif=x-ones(1,length(x))*CFcombiselectALL_70(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL_70(n).CF2ph=Yn(Lind)+(Yn(Rind)-Yn(Lind))*(CFcombiselectALL_70(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    x2=CFcombiselectALL_70(n).CF2;Y2=CFcombiselectALL_70(n).CF2ph;
    
    %plot(x,yn*1000./x);hold on;
    plot(x2,Y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');hold on;
    
    xind=find(x>=CFcombiselectALL_70(n).CF2*(2^(-1/3)) & x<=CFcombiselectALL_70(n).CF2*(2^(1/3)));%Window at CF2
    %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    %plot(xplus,yplus*1000./xplus);hold on
    line(x(xind),Yn(xind)*1000./x(xind),'Marker','o','MarkerSize',5,'MarkerEdgeColor','b','Color','c');hold on;
    
    %x2=CFcombiselectALL_70(n).CF2;y2=CFcombiselectALL_70(n).CF2p;
    %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);
plot(f,f.^(-1)*1000,'g');plot(f,f.^(-1)*(-1000),'g');plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 0 4]);
hold off;

CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];


for n=1:length(CFcombiselectALL)
    x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xdif=x-ones(1,length(x))*CFcombiselectALL(n).CF2;
    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
    CFcombiselectALL(n).CF2ph=y(Lind)+(y(Rind)-y(Lind))*(CFcombiselectALL(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
    if (CFcombiselectALL(n).CF2ph < -0.5)|(CFcombiselectALL(n).CF2ph >= 0.5)
        CFcombiselectALL(n).CF2phr=CFcombiselectALL(n).CF2ph-round(CFcombiselectALL(n).CF2ph);
        y=y+(CFcombiselectALL(n).CF2phr-CFcombiselectALL(n).CF2ph);
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP+(CFcombiselectALL(n).CF2phr-CFcombiselectALL(n).CF2ph);
    else
        CFcombiselectALL(n).CF2phr=CFcombiselectALL(n).CF2ph;
        CFcombiselectALL(n).CPrr=CFcombiselectALL(n).CP;
    end;
    
    x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2phr;

    %x=CFcombiselectALL(n).IPCx;y=CFcombiselectALL(n).IPCy;
    xind=find(x>=CFcombiselectALL(n).CF2*(2^(0)) & x<=CFcombiselectALL(n).CF2*(2^(1/3)));%Window at CF2
    xplus=[x2 x(xind)];yplus=[y2 y(xind)];
    plot(xplus,yplus*1000./xplus);hold on
    %line(x(xind),(x(xind).^(-1))*1000*CFcombiselectALL(n).CPrr+ones(1,length(x(xind)))*CFcombiselectALL(n).CD,'LineStyle', '-', 'Color', 'r', 'Marker', 'none');hold on;
    
    %x2=CFcombiselectALL(n).CF2;y2=CFcombiselectALL(n).CF2p;
    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
end;
f=(100:1:4000);plot(f,f.^(-1)*500,'g');plot(f,f.^(-1)*(-500),'g');plot(f,f*0,'g');axis([0 4000 -2 2]);
hold off;






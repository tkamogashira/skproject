
%4 pairs example
for n=40:43
    x=CFcombiselect242(n).IPCx;y=CFcombiselect242(n).IPCy;X=CFcombiselect242(n).ISRx;Y=CFcombiselect242(n).ISRy;
    if (CFcombiselect242(n).CP < -0.5)|(CFcombiselect242(n).CP >= 0.5)
        %CFcombiselect242(n).CPr=CFcombiselect242(n).CP-round(CFcombiselect242(n).CP);
        y=y+(CFcombiselect242(n).CPr-CFcombiselect242(n).CP);
    %else
        %CFcombiselect242(n).CPr=CFcombiselect242(n).CP;
    end;
        
    [YM,YMi]=max(Y);
    %CFcombiselect242(n).BPr=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).BF;
    xb=CFcombiselect242(n).BF;yb=CFcombiselect242(n).BPr;
    %CFcombiselect242(n).CF1p=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).CF1;
    x1=CFcombiselect242(n).CF1;y1=CFcombiselect242(n).CF1p;
    %CFcombiselect242(n).CF2p=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*CFcombiselect242(n).CF2;
    x2=CFcombiselect242(n).CF2;y2=CFcombiselect242(n).CF2p;
        
        
    plot(x,y,'-','LineWidth',2, 'Color',[0.7 0.7 0.7]);hold on;
    plot(X(YMi),y(YMi),'o','LineWidth',2,'MarkerSize',12,'Color',[0.7 0.7 0.7],'MarkerFaceColor',[1 1 1]);
    plot(xb,yb,'ko','MarkerSize',10);
    plot(x1,y1,'k<','MarkerSize',10);%CFc
    plot(x2,y2,'>','MarkerSize',10,'Color','k','MarkerFaceColor','k');%CFi
    xk=(0:10:max(x));
    yk=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');
    x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CFcombiselect242(n).BestITD)/1000+yb,'LineStyle', '-','LineWidth',2, 'Color', 'k', 'Marker', 'none');
    xlim([0 4000]);%axis([0 4000 -3 3]);
    
    ykd=CFcombiselect242(n).CPr+(CFcombiselect242(n).CD/1000)*x;
    Dif=y-ykd;
    for a=1:(length(Dif)-1)
        if Dif(a)*Dif(a+1)<0
            DifM(a)=1;
        else
            DifM(a)=0;
        end;
    end;
        DifM(length(Dif))=0;
        MM1=find(DifM==1);
    if length(MM1)>=2
        clear bump
        bumpM=[0;0];
        for g=1:length(MM1)-1
            [bumpabs,idx]=max(abs(Dif(MM1(g)+1:MM1(g+1))));
            bumpidx=MM1(g)+idx;
            bump=Dif(MM1(g)+idx);
            bumpM=[bumpM [bump;bumpidx]];
        end;
        bumpM(:,1)=[];
        if CFcombiselect242(n).CD>=0
            [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
        else
            [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
        end;
        Low=CFcombiselect242(n).CF2*(2^(-1/3));
        High=CFcombiselect242(n).CF2*(2^(1/3));
        if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
            plot(x(maxbumpidx),y(maxbumpidx),'k*','MarkerSize',18);hold on
            CFcombiselect242(n).bumpfreq=x(maxbumpidx);
            CFcombiselect242(n).bumpdif=Dif(maxbumpidx);
        end;
        if x(maxbumpidx)<Low|High<x(maxbumpidx)
            plot(x(maxbumpidx),y(maxbumpidx),'k*','MarkerSize',18);hold on
            CFcombiselect242(n).bumpfreq=x(maxbumpidx);
            CFcombiselect242(n).bumpdif=Dif(maxbumpidx);
        end;
    end;
    
end;
hold off;clear bump;clear Dif;clear MM1;clear bumpM;
xlabel('Tone frequency (Hz)');
ylabel('Interaural phase (cycles)')


  



CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for n=1:length(CFcombiselectALL)
    CFcombiselectALL(n).coch=greenwood(CFcombiselectALL(n).CF2)-greenwood(CFcombiselectALL(n).CF1);
end;

for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;
CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');


%x: frequency y: phase-frequency curve (blue line), CF2(ipsi; green), CF1(contra; black), bump(red) I have to add grid and adjust size of each panel

%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
SIZE=size(CFcombiselectALL_70);
nnn=0;
for k=1:20
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:SIZE(2)
        clear Dif;
        
        if (CFcombiselectALL_70(m).CF2>=(k-1)*200)&(CFcombiselectALL_70(m).CF2<k*200)
            N=N+1;
            x=CFcombiselectALL_70(m).IPCx;y=CFcombiselectALL_70(m).IPCy;X=CFcombiselectALL_70(m).ISRx;Y=CFcombiselectALL_70(m).ISRy;
            if (CFcombiselectALL_70(m).CP < -0.5)|(CFcombiselectALL_70(m).CP >= 0.5)
                y=y+(CFcombiselectALL_70(m).CPr-CFcombiselectALL_70(m).CP);
            end;
            if CFcombiselectALL_70(m).pLinReg < 0.005
                plot(x,y,'b');hold on;
            elseif CFcombiselectALL_70(m).pLinReg >= 0.005
                plot(x,y,'r');hold on;    
            end;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CFcombiselectALL_70(m).BF;yb=CFcombiselectALL_70(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=CFcombiselectALL_70(m).CF1;y1=CFcombiselectALL_70(m).CF1p;
            x2=CFcombiselectALL_70(m).CF2;y2=CFcombiselectALL_70(m).CF2p;
            plot(x1,y1,'m.','MarkerSize',8);hold on
            plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*xk;
            line(xk,yk,'LineStyle', '-', 'Color', [0.7 0.7 0.7], 'Marker', 'none');hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*x;
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
                if CFcombiselectALL_70(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselectALL_70(m).CF2*(2^(-1/3));
                High=CFcombiselectALL_70(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx),'r*','MarkerSize',8);hold on
                    CFcombiselectALL_70(m).bumpfreq=x(maxbumpidx);
                    CFcombiselectALL_70(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',8);hold on
                    CFcombiselectALL_70(m).bumpfreq=x(maxbumpidx);
                    CFcombiselectALL_70(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
        end;
        
    end;
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N)],'FontSize',10,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;display(nnn)
    hold off;
end;

assignin('base','CFcombiselectALL_70_bump',CFcombiselectALL_70);

%figure2
figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
SIZE=size(CFcombiselectALL_70);
for k=1:20
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.04 1-(NN+1)*(1/4)+0.04 1/5-0.06 1/4-0.06],'FontSize',8);hold on;
    axis([0 1.2 -1 1.5]);ylabel('CD (ms)');
    text('string',[num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N)],'FontSize',10,'Units','normalized','Position',[0.1,0.95]);
    xlabel('Delta CF on basal membrane (mm)');
    line([0 1.2],[0 0],'color','k');
    
    for m=1:SIZE(2)
        
        if (CFcombiselectALL_70(m).CF2>=(k-1)*200)&(CFcombiselectALL_70(m).CF2<k*200)
            N=N+1;
            
            if CFcombiselectALL_70(m).pLinReg < 0.005
                plot(CFcombiselectALL_70(m).coch, CFcombiselectALL_70(m).CD, 'k.','markersize',6);hold on;
            elseif CFcombiselectALL_70(m).pLinReg >= 0.005
                plot(CFcombiselectALL_70(m).coch, CFcombiselectALL_70(m).CD, 'ko','markersize',6);hold on;
            end;
        end;
        
    end;
    
    hold off;
end;

%figure3
figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
SIZE=size(CFcombiselectALL_70);
for k=1:20
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:SIZE(2)
        clear Dif;
        
        if (CFcombiselectALL_70(m).CF2>=(k-1)*200)&(CFcombiselectALL_70(m).CF2<k*200)
            N=N+1;
            x=CFcombiselectALL_70(m).IPCx;y=CFcombiselectALL_70(m).IPCy;X=CFcombiselectALL_70(m).ISRx;Y=CFcombiselectALL_70(m).ISRy;
            if (CFcombiselectALL_70(m).CP < -0.5)|(CFcombiselectALL_70(m).CP >= 0.5)
                y=y+(CFcombiselectALL_70(m).CPr-CFcombiselectALL_70(m).CP);
            end;
            
            
            plot(CFcombiselectALL_70(m).CF2,0,'g.','MarkerSize',10);hold on
            
            xk=(0:10:max(x));
            %yk=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            yk2=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*x;
            
            if CFcombiselectALL_70(m).pLinReg < 0.005
                plot(x,y-yk2,'color',[0.7 0.7 0.7]);hold on;ylim([-0.5 0.5]);
            elseif CFcombiselectALL_70(m).pLinReg >= 0.005
                plot(x,y-yk2,'color','r');hold on;ylim([-0.5 0.5]);  
            end;
            
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselectALL_70(m).CPr+(CFcombiselectALL_70(m).CD/1000)*x;
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
                if CFcombiselectALL_70(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselectALL_70(m).CF2*(2^(-1/3));
                High=CFcombiselectALL_70(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx)-yk2(maxbumpidx),'r*','MarkerSize',8);hold on
                    CFcombiselectALL_70(m).bumpfreq=x(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx)-yk2(maxbumpidx),'c*','MarkerSize',8);hold on
                    CFcombiselectALL_70(m).bumpfreq=x(maxbumpidx);
                    
                end;
            end;
        end;
        
    end;
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N)],'FontSize',10,'Units','normalized','Position',[0.5,1]);
    
    hold off;
end;




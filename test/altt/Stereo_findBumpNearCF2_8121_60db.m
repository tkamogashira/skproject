%all phase-frequency curves with bump and without bump
SIZE=size(CFcombiselect8121single60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect8121single60db(n).CF2>=(k-1)*100)&(CFcombiselect8121single60db(n).CF2<k*100)
            
            
            x=CFcombiselect8121single60db(n).IPCx;y=CFcombiselect8121single60db(n).IPCy;X=CFcombiselect8121single60db(n).ISRx;Y=CFcombiselect8121single60db(n).ISRy;
            if (CFcombiselect8121single60db(n).CP < -0.5)|(CFcombiselect8121single60db(n).CP >= 0.5)
                y=y+(CFcombiselect8121single60db(n).CPr-CFcombiselect8121single60db(n).CP);
            end;
            %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
            plot(x,y,'b');grid on;hold on;axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CFcombiselect8121single60db(n).BF;yb=CFcombiselect8121single60db(n).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=CFcombiselect8121single60db(n).CF1;y1=CFcombiselect8121single60db(n).CF1p;
            x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2p;
            plot(x1,y1,'m.','MarkerSize',8);hold on
            plot(x2,y2,'g.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CFcombiselect8121single60db(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*x;
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
                if CFcombiselect8121single60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect8121single60db(n).CF2*(2^(-1/3));
                High=CFcombiselect8121single60db(n).CF2*(2^(1/3));
                %if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                %end;
                %if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                %end;
            end;
            
        end;
    end;
    hold off;
end;

figure
%zoomin for x-axis all phase-frequency curves with bump and without bump
SIZE=size(CFcombiselect8121single60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect8121single60db(n).CF2>=(k-1)*100)&(CFcombiselect8121single60db(n).CF2<k*100)
            
            
            x=CFcombiselect8121single60db(n).IPCx;y=CFcombiselect8121single60db(n).IPCy;X=CFcombiselect8121single60db(n).ISRx;Y=CFcombiselect8121single60db(n).ISRy;
            if (CFcombiselect8121single60db(n).CP < -0.5)|(CFcombiselect8121single60db(n).CP >= 0.5)
                y=y+(CFcombiselect8121single60db(n).CPr-CFcombiselect8121single60db(n).CP);
            end;
            line([min(x) max(x)],[0 0],'Color','k','LineWidth',2.5);hold on;
            %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
            plot(x,y,'b');grid on;hold on;%ylim([-2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CFcombiselect8121single60db(n).BF;yb=CFcombiselect8121single60db(n).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=CFcombiselect8121single60db(n).CF1;y1=CFcombiselect8121single60db(n).CF1p;
            x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2p;
            plot(x1,y1,'m.','MarkerSize',8);hold on
            plot(x2,y2,'g.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CFcombiselect8121single60db(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*x;
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
                if CFcombiselect8121single60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect8121single60db(n).CF2*(2^(-1/3));
                High=CFcombiselect8121single60db(n).CF2*(2^(1/3));
                %if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                %end;
                %if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                %end;
            end;
            
        end;
    end;
    hold off;
end;

figure
%All delay-frequency curves
SIZE=size(CFcombiselect8121single60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect8121single60db(n).CF2>=(k-1)*100)&(CFcombiselect8121single60db(n).CF2<k*100)
            
            x=CFcombiselect8121single60db(n).IPCx;y=CFcombiselect8121single60db(n).IPCy;
            ylast=y(length(y));
            
            if  ylast<-0.5 | ylast>= 0.5
                ylastr=ylast-round(ylast);
                yn=y+(ylastr-ylast);
            else
                yn=y;
            end;
            
    
            xdif=x-ones(1,length(x))*CFcombiselect8121single60db(n).CF2;
            Lind=min(find(xdif>0));Rind=max(find(xdif<0));
            CFcombiselect8121single60db(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselect8121single60db(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
            x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2ph;
    
            %plot(x,yn*1000./x);hold on;
            plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
    
            %xind=find(x>=CFcombiselect8121single60db(n).CF2*(2^(-1/3)) & x<=CFcombiselect8121single60db(n).CF2*(2^(1/3)));%Window at CF2
            %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
            %plot(xplus,yplus*1000./xplus);hold on
            line(x,yn*1000./x,'Marker','o','MarkerSize',2,'MarkerEdgeColor','b','Color','b');hold on;
    
            %x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2p;
            %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
            
            
            
            
            
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*x;
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
                if CFcombiselect8121single60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect8121single60db(n).CF2*(2^(-1/3));
                High=CFcombiselect8121single60db(n).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                end;
            end;
            
        end;
    end;
    %f=(((k-1)*100+1)*(2^(-1/3)):1:(k*100)*(2^(1/3)));
    f=(1:1:4000);
    plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    %ylim([0 4]);
    %xlim([((k-1)*100+1)*(2^(-1/3)) (k*100)*(2^(1/3))]);
    xlim([min(x) max(x)]);
    hold off;
end;

figure
%Zoomin for x-axis near CF2: all delay-frequency curves
SIZE=size(CFcombiselect8121single60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect8121single60db(n).CF2>=(k-1)*100)&(CFcombiselect8121single60db(n).CF2<k*100)
            
            x=CFcombiselect8121single60db(n).IPCx;y=CFcombiselect8121single60db(n).IPCy;
            ylast=y(length(y));
            
            if  ylast<-0.5 | ylast>= 0.5
                ylastr=ylast-round(ylast);
                yn=y+(ylastr-ylast);
            else
                yn=y;
            end;
            
    
            xdif=x-ones(1,length(x))*CFcombiselect8121single60db(n).CF2;
            Lind=min(find(xdif>0));Rind=max(find(xdif<0));
            CFcombiselect8121single60db(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselect8121single60db(n).CF2-x(Lind))/(x(Rind)-x(Lind));%Phase at CF2 on real curve
    
            x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2ph;
    
            %plot(x,yn*1000./x);hold on;
            plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
    
            %xind=find(x>=CFcombiselect8121single60db(n).CF2*(2^(-1/3)) & x<=CFcombiselect8121single60db(n).CF2*(2^(1/3)));%Window at CF2
            %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
            %plot(xplus,yplus*1000./xplus);hold on
            line(x,yn*1000./x,'Marker','o','MarkerSize',2,'MarkerEdgeColor','b','Color','b');hold on;
    
            %x2=CFcombiselect8121single60db(n).CF2;y2=CFcombiselect8121single60db(n).CF2p;
            %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','r','MarkerFaceColor','r');
            
            
            
            
            
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect8121single60db(n).CPr+(CFcombiselect8121single60db(n).CD/1000)*x;
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
                if CFcombiselect8121single60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect8121single60db(n).CF2*(2^(-1/3));
                High=CFcombiselect8121single60db(n).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                end;
            end;
            
        end;
    end;
    %f=(((k-1)*100+1)*(2^(-1/3)):1:(k*100)*(2^(1/3)));
    f=(1:1:4000);
    plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    %ylim([0 4]);
    xlim([((k-1)*100+1)*(2^(-1/3)) (k*100)*(2^(1/3))]);
    %xlim([min(x) max(x)]);
    hold off;
end;

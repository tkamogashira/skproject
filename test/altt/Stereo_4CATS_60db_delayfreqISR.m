SIZE=size(CFcombiselect4CATS_bump60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect4CATS_bump60db(n).CF2>=(k-1)*100)&(CFcombiselect4CATS_bump60db(n).CF2<k*100)
            
            x=CFcombiselect4CATS_bump60db(n).IPCx;y=CFcombiselect4CATS_bump60db(n).IPCy;
            difvec=abs(x-ones(1,length(x))*CFcombiselect4CATS_bump60db(n).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %adjust phase at CF2 between -0.5 and 0.5
            if  yref<-0.5 | yref>= 0.5
                yrefr=yref-round(yref);
                yn=y+(yrefr-yref);
            else
                yn=y;
            end;
            %line(x,yn*1000./x,'Marker','none','Color','k');hold on;
            
            for qq=1:length(CFcombiselect4CATS_bump60db(n).ISRy)
                z=CFcombiselect4CATS_bump60db(n).ISRy(qq);
                zmin=0;zmax=0.4;m=64;
                if z>=0.39
                    index = fix((0.39-zmin)/(zmax-zmin)*m)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*m)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                %line(x,yn*1000./x,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');hold on;
            
                plot(x(qq),(yn(qq))*1000/(x(qq)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
            
                %colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.25;0.5;0.75;1]);
            end;
            
            %locate CF2 mark on real curve
            xdif=x-ones(1,length(x))*CFcombiselect4CATS_bump60db(n).CF2;
            Lind=min(find(xdif>0));Rind=max(find(xdif<0));
            CFcombiselect4CATS_bump60db(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselect4CATS_bump60db(n).CF2-x(Lind))/(x(Rind)-x(Lind));
            x2=CFcombiselect4CATS_bump60db(n).CF2;y2=CFcombiselect4CATS_bump60db(n).CF2ph;
            %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
            line([x2 x2],[x2.^(-1)*(-500)-0.5 x2.^(-1)*(500)+0.5],'Color',[0.7 0.7 0.7]);
            
            %plot(x,yn*1000./x);hold on;
            %xind=find(x>=CFcombiselect4CATS_bump60db(n).CF2*(2^(-1/3)) & x<=CFcombiselect4CATS_bump60db(n).CF2*(2^(1/3)));%Window at CF2
            %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
            %plot(xplus,yplus*1000./xplus);hold on
            
            %find bump
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect4CATS_bump60db(n).CPr+(CFcombiselect4CATS_bump60db(n).CD/1000)*x;
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
                if CFcombiselect4CATS_bump60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect4CATS_bump60db(n).CF2*(2^(-1/3));
                High=CFcombiselect4CATS_bump60db(n).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'ko','MarkerSize',6);hold on
                    %line([x(maxbumpidx) x(maxbumpidx)],[x(maxbumpidx).^(-1)*(500) x(maxbumpidx).^(-1)*(500)+0.5],'Color','m');
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'ko','MarkerSize',6);hold on
                    %line([x(maxbumpidx) x(maxbumpidx)],[x(maxbumpidx).^(-1)*(500) x(maxbumpidx).^(-1)*(500)+0.5],'Color','c');
                end;
            end;
            
        end;
    end;
    %f=(((k-1)*100+1)*(2^(-1/3)):1:(k*100)*(2^(1/3)));
    f=(1:1:4000);
    plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    %ylim([0 4]);
    xlim([((k-1)*100+1)*(2^(-3/3)) (k*100)*(2^(3/3))]);
    hold off;
end;

%No magnification
figure
SIZE=size(CFcombiselect4CATS_bump60db);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=CFi<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect4CATS_bump60db(n).CF2>=(k-1)*100)&(CFcombiselect4CATS_bump60db(n).CF2<k*100)
            
            x=CFcombiselect4CATS_bump60db(n).IPCx;y=CFcombiselect4CATS_bump60db(n).IPCy;
            difvec=abs(x-ones(1,length(x))*CFcombiselect4CATS_bump60db(n).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %adjust phase at CF2 between -0.5 and 0.5
            if  yref<-0.5 | yref>= 0.5
                yrefr=yref-round(yref);
                yn=y+(yrefr-yref);
            else
                yn=y;
            end;
            %line(x,yn*1000./x,'Marker','none','Color','k');hold on;
            
            for qq=1:length(CFcombiselect4CATS_bump60db(n).ISRy)
                z=CFcombiselect4CATS_bump60db(n).ISRy(qq);
                zmin=0;zmax=0.4;m=64;
                if z>=0.39
                    index = fix((0.39-zmin)/(zmax-zmin)*m)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*m)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                %line(x,yn*1000./x,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');hold on;
            
                plot(x(qq),(yn(qq))*1000/(x(qq)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %line([0 x],[z y],'Color',CC,'LineWidth',2);hold on;grid on;
            
                %colorbar('YTick',[1;17;33;49;65],'YTickLabel',[0;0.25;0.5;0.75;1]);
            end;
            
            %locate CF2 mark on real curve
            xdif=x-ones(1,length(x))*CFcombiselect4CATS_bump60db(n).CF2;
            Lind=min(find(xdif>0));Rind=max(find(xdif<0));
            CFcombiselect4CATS_bump60db(n).CF2ph=yn(Lind)+(yn(Rind)-yn(Lind))*(CFcombiselect4CATS_bump60db(n).CF2-x(Lind))/(x(Rind)-x(Lind));
            x2=CFcombiselect4CATS_bump60db(n).CF2;y2=CFcombiselect4CATS_bump60db(n).CF2ph;
            %plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
            line([x2 x2],[x2.^(-1)*(-500)-1 x2.^(-1)*(500)+1],'Color',[0.7 0.7 0.7]);
            
            %plot(x,yn*1000./x);hold on;
            %xind=find(x>=CFcombiselect4CATS_bump60db(n).CF2*(2^(-1/3)) & x<=CFcombiselect4CATS_bump60db(n).CF2*(2^(1/3)));%Window at CF2
            %xplus=[x2 x(xind)];yplus=[y2 y(xind)];
            %plot(xplus,yplus*1000./xplus);hold on
            
            %find bump
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect4CATS_bump60db(n).CPr+(CFcombiselect4CATS_bump60db(n).CD/1000)*x;
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
                if CFcombiselect4CATS_bump60db(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect4CATS_bump60db(n).CF2*(2^(-1/3));
                High=CFcombiselect4CATS_bump60db(n).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                end;
            end;
            
        end;
    end;
    %f=(((k-1)*100+1)*(2^(-1/3)):1:(k*100)*(2^(1/3)));
    f=(1:1:4000);
    plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    ylim([-3 3]);
    %xlim([((k-1)*100+1)*(2^(-3/3)) (k*100)*(2^(3/3))]);
    hold off;
end;


CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for n=1:length(CFcombiselectALL)
    CFcombiselectALL(n).coch=greenwood(CFcombiselectALL(n).CF2)-greenwood(CFcombiselectALL(n).CF1);
end;

for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;
CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');
CFcombiselectALL_60=structfilter(CFcombiselectALL,'$spl$==60');
CFcombiselectALL_50=structfilter(CFcombiselectALL,'$spl$==50');
CFcombiselectALL_40=structfilter(CFcombiselectALL,'$spl$==40');
CFcombiselectALL_30=structfilter(CFcombiselectALL,'$spl$==30');

list(1,1)={CFcombiselectALL_60};%0-200
list(1,2)={CFcombiselectALL_60};%200-400
list(1,3)={CFcombiselectALL_70};%400-600
list(1,4)={CFcombiselectALL_50};%600-800
list(1,5)={CFcombiselectALL_50};%800-1000
list(1,6)={CFcombiselectALL_50};%1000-1200
list(1,7)={CFcombiselectALL_60};%1200-1400
list(1,8)={CFcombiselectALL_60};%1400-1600
list(1,9)={CFcombiselectALL_60};%1600-1800
list(1,10)={CFcombiselectALL_50};%1800-2000
list(1,11)={CFcombiselectALL_60};%2000-2200
list(1,12)={CFcombiselectALL_60};%2200-2400
list(1,13)={CFcombiselectALL_60};%2400-2600
list(1,14)={CFcombiselectALL_50};%2600-2800
list(1,15)={CFcombiselectALL_50};%2800-3000
list(1,16)={CFcombiselectALL_70};%3000-3200
list(1,17)={CFcombiselectALL_50};%3200-3400
list(1,18)={CFcombiselectALL_70};%3400-3600
list(1,19)={CFcombiselectALL_70};%3600-3800
list(1,20)={CFcombiselectALL_70};%3800-4000


%figure1
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);%set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    axis auto;
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                y=y+(MM(m).CPr-MM(m).CP);
            end;
            if MM(m).pLinReg < 0.005
                line(x,y,'color','b','linewidth',1);hold on;
            elseif MM(m).pLinReg >= 0.005
                line(x,y,'color','r');hold on;    
            end;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            line(xk,yk,'LineStyle', '-', 'Color', [0.8 0.8 0.8], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    height=get(gca,'ylim');
    if height<1
        ylim([-0.5 1]);
    end;
    height=get(gca,'ylim')
    patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    hold off;
end;


%figure2 without nonlinear
figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);%set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                y=y+(MM(m).CPr-MM(m).CP);
            end;
            
            line(x,y,'color','b','linewidth',1);hold on;
              
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    height=get(gca,'ylim');
    if height<1
        ylim([-0.5 1]);
    end;
    height=get(gca,'ylim')
    patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    hold off;
end;

%figure3
figure

for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.04 1-(NN+1)*(1/4)+0.04 1/5-0.06 1/4-0.06],'FontSize',8);hold on;
    axis([0 1.2 -1 1.5]);ylabel('CD (ms)');
    
    
    for m=1:length(MM)
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)
            N=N+1;
            
            if MM(m).pLinReg < 0.005
                plot(MM(m).coch, MM(m).CD, 'k.','markersize',6);hold on;
            elseif MM(m).pLinReg >= 0.005
                plot(MM(m).coch, MM(m).CD, 'ko','markersize',6);hold on;
            end;
        end;
        
    end;
    text('string',[num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.1,0.95]);
    xlabel('Delta CF on basal membrane (mm)');
    line([0 1.2],[0 0],'color','k');
    hold off;
end;

%figure4
figure

for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.04 1-(NN+1)*(1/4)+0.04 1/5-0.06 1/4-0.06],'FontSize',8);hold on;
    axis([0 0.35 -1 1.5]);ylabel('CD (ms)');
    
    
    for m=1:length(MM)
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)
            N=N+1;
            
            if MM(m).pLinReg < 0.005
                plot(MM(m).DeltaCF, MM(m).CD, 'k.','markersize',6);hold on;
            elseif MM(m).pLinReg >= 0.005
                plot(MM(m).DeltaCF, MM(m).CD, 'ko','markersize',6);hold on;
            end;
        end;
        
    end;
    text('string',[num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.1,0.95]);
    xlabel('Delta CF (octave)');
    line([0 1.2],[0 0],'color','k');
    hold off;
end;

%figure5 without nonlinear plus color ISR
figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);%set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                y=y+(MM(m).CPr-MM(m).CP);
            end;
            
            %line(x,y,'color',[0.8 0.8 0.8],'linewidth',0.1);hold on;
            
            for s=1:length(x)
                z=Y(s);
                zmin=0;zmax=0.8;r=64;
                if z>=0.79
                    index = fix((0.79-zmin)/(zmax-zmin)*r)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*r)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                plot(x(s),y(s),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',5);hold on;
                clear z;
            end;
            
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    height=get(gca,'ylim');
    if height<1
        ylim([-0.5 1]);
    end;
    height=get(gca,'ylim')
    patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    hold off;
end;


%figure6 without nonlinear delay-freq color ISR;
figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                y=y+(MM(m).CPr-MM(m).CP);
            end;
            
            %adjust phase at CF2 between -0.5 and 0.5
            difvec=abs(x-ones(1,length(x))*MM(m).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %if  yref<-0.5 | yref>= 0.5
                %yrefr=yref-round(yref);
                %yn=y+(yrefr-yref);
            %else
                yn=y;
            %end;
            
            for s=1:length(x)
                z=Y(s);
                zmin=0;zmax=0.8;r=64;
                if z>=0.79
                    index = fix((0.79-zmin)/(zmax-zmin)*r)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*r)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                clear z;
            end;
            
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    
    height=get(gca,'ylim');
    width=get(gca,'xlim');
    ylim(height);
    xlim(width);
    %if height<1
        %ylim([-0.5 1]);
    %end;
    %height=get(gca,'ylim')
    patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;clear width;
    
    f=(1:1:4000);
    plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    
    xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    hold off;
end;

%figure7 without nonlinear delay-freq ISR>0.2 on one figure
figure
subplot(1,3,1)%ISR>0.2 on one figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
%scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            %if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                %y=y+(MM(m).CPr-MM(m).CP);
            %end;
            
            %adjust phase at CF2 between -0.5 and 0.5
            difvec=abs(x-ones(1,length(x))*MM(m).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %if  yref<-0.5 | yref>= 0.5
                %yrefr=yref-round(yref);
                %yn=y+(yrefr-yref);
            %else
                yn=y;
            %end;
            large=find(Y>0.2);
            for s=large
                z=Y(s);
                zmin=0;zmax=0.8;r=64;
                if z>=0.79
                    index = fix((0.79-zmin)/(zmax-zmin)*r)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*r)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                if z>0.2
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                end;
                clear z;
            end;
            line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    
    height=get(gca,'ylim');
    width=get(gca,'xlim');
    %ylim(height);
    %xlim(width);
    %if height<1
        %ylim([-0.5 1]);
    %end;
    %height=get(gca,'ylim')
    %patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;clear width;
    
    
    %xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    %hold off;
end;
height=get(gca,'ylim');
width=get(gca,'xlim');
ylim(height);
xlim(width);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('ISR > 0.2');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

subplot(1,3,2)%ISR>0.3 on one figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
%scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);set(gcf,'resize','off');
nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            %if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                %y=y+(MM(m).CPr-MM(m).CP);
            %end;
            
            %adjust phase at CF2 between -0.5 and 0.5
            difvec=abs(x-ones(1,length(x))*MM(m).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %if  yref<-0.5 | yref>= 0.5
                %yrefr=yref-round(yref);
                %yn=y+(yrefr-yref);
            %else
                yn=y;
            %end;
            large=find(Y>0.3);
            for s=large
                z=Y(s);
                zmin=0;zmax=0.8;r=64;
                if z>=0.79
                    index = fix((0.79-zmin)/(zmax-zmin)*r)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*r)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                %if z>0.3
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    
    height=get(gca,'ylim');
    width=get(gca,'xlim');
    %ylim(height);
    %xlim(width);
    %if height<1
        %ylim([-0.5 1]);
    %end;
    %height=get(gca,'ylim')
    %patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;clear width;
    
    
    %xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    nnn=nnn+N;%display(nnn)
    %hold off;
end;
height=get(gca,'ylim');
width=get(gca,'xlim');
ylim(height);
xlim(width);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('ISR > 0.3');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');


subplot(1,3,3)%ISR>0.4 on one figure
%set(gcf, 'PaperType', 'A4');set(gcf, 'PaperOrientation', 'landscape');
%scrsz = get(0,'ScreenSize');set(gcf,'position',scrsz);set(gcf,'resize','off');
%nnn=0;
for k=1:20
    MM=list{1,k};
    N=0;
    NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if (MM(m).CF2>=(k-1)*200)&(MM(m).CF2<k*200)& MM(m).pLinReg < 0.005
            N=N+1;
            x=MM(m).IPCx;y=MM(m).IPCy;X=MM(m).ISRx;Y=MM(m).ISRy;
            %if (MM(m).CP < -0.5)|(MM(m).CP >= 0.5)
                %y=y+(MM(m).CPr-MM(m).CP);
            %end;
            
            %adjust phase at CF2 between -0.5 and 0.5
            difvec=abs(x-ones(1,length(x))*MM(m).CF2);
            [mindif,mindifidx]=min(difvec);
            yref=y(mindifidx);
            %if  yref<-0.5 | yref>= 0.5
                %yrefr=yref-round(yref);
                %yn=y+(yrefr-yref);
            %else
                yn=y;
            %end;
            large=find(Y>0.4);
            for s=large
                z=Y(s);
                zmin=0;zmax=0.8;r=64;
                if z>=0.79
                    index = fix((0.79-zmin)/(zmax-zmin)*r)+1;
                else
                    index = fix((z-zmin)/(zmax-zmin)*r)+1;
                end;
                aaa=colormap(jet);
                CC=aaa(index,:);
                %if z>0.4
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=MM(m).CPr+(MM(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=MM(m).BF;yb=MM(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=MM(m).CF1;y1=MM(m).CF1p;
            x2=MM(m).CF2;y2=MM(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=MM(m).CPr+(MM(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=MM(m).CPr+(MM(m).CD/1000)*x;
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
                if MM(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=MM(m).CF2*(2^(-1/3));
                High=MM(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    MM(m).bumpfreq=x(maxbumpidx);
                    MM(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        end;   
    end;
    
    height=get(gca,'ylim');
    width=get(gca,'xlim');
    %ylim(height);
    %xlim(width);
    %if height<1
        %ylim([-0.5 1]);
    %end;
    %height=get(gca,'ylim')
    %patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    clear height;clear width;
    
    
    %xlabel([num2str((k-1)*200) '<=CFi<' num2str(k*200) ' N=' num2str(N) ' (' num2str(MM(1).spl(1)) ' dB)'],'FontSize',8,'Units','normalized','Position',[0.5,1]);
    %nnn=nnn+N;%display(nnn)
    %hold off;
end;
height=get(gca,'ylim');
width=get(gca,'xlim');
ylim(height);
xlim(width);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('ISR > 0.4');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

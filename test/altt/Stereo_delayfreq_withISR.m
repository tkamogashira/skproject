CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;
CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');
CFcombiselectALL_60=structfilter(CFcombiselectALL,'$spl$==60');
CFcombiselectALL_50=structfilter(CFcombiselectALL,'$spl$==50');
CFcombiselectALL_40=structfilter(CFcombiselectALL,'$spl$==40');
CFcombiselectALL_30=structfilter(CFcombiselectALL,'$spl$==30');

%70dB
subplot(3,2,1)%ISR>0.4 on one figure
MM=CFcombiselectALL_70;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
                %if z>0.4
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            %line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
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
    
height1=get(gca,'ylim');
width1=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('70dB ISR > 0.2');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

subplot(3,2,2)%-1 octave to 0 octave
MM=CFcombiselectALL_70;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
            range=find((x > MM(m).CF2*2^(-1))&(x <= MM(m).CF2*2^(0)));
            for s=range
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
            %line(x(range),(yn(range))*1000./(x(range)),'color','k');hold on;
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
    
height2=get(gca,'ylim');
width2=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('70dB CFi*2^(-1)-CFi*2^(0)');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');


%60dB
subplot(3,2,3)%ISR>0.4 on one figure
MM=CFcombiselectALL_60;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
                %if z>0.4
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            %line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
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
    
height1=get(gca,'ylim');
width1=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('60dB ISR > 0.2');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

subplot(3,2,4)%-1 octave to 0 octave
MM=CFcombiselectALL_60;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
            range=find((x > MM(m).CF2*2^(-1))&(x <= MM(m).CF2*2^(0)));
            for s=range
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
            %line(x(range),(yn(range))*1000./(x(range)),'color','k');hold on;
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
    
height2=get(gca,'ylim');
width2=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('60dB CFi*2^(-1)-CFi*2^(0)');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

%50dB
subplot(3,2,5)%ISR>0.4 on one figure
MM=CFcombiselectALL_50;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
                %if z>0.4
                    plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            %line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
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
    
height1=get(gca,'ylim');
width1=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('50dB ISR > 0.2');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');

subplot(3,2,6)%-1 octave to 0 octave
MM=CFcombiselectALL_50;
    N=0;
    %NN=ceil(k/5)-1;
    %axes('Position',[(k-NN*5-1)*(1/5)+0.01 1-(NN+1)*(1/4)+0.02 1/5-0.04 1/4-0.04],'FontSize',8);hold on;
    
    for m=1:length(MM)
        clear Dif;
        
        if MM(m).pLinReg < 0.005 & MM(m).CF2 <=2000
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
            range=find((x > MM(m).CF2*2^(-1))&(x <= MM(m).CF2*2^(0)));
            for s=range
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
            %line(x(range),(yn(range))*1000./(x(range)),'color','k');hold on;
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
    
height2=get(gca,'ylim');
width2=get(gca,'xlim');
ylim(height1);
xlim(width1);

f=(1:1:4000);
plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');

qq=[0;0.2;0.4;0.6;0.8];
for k=1:length(qq)
    qqi(k,1)=fix((qq(k,1)-zmin)/(zmax-zmin)*r)+1;
end;
[qq qqi]
colorbar('YTick',qqi,'YTickLabel',qq);
hold off;
title('50dB CFi*2^(-1)-CFi*2^(0)');xlabel('Tone frequency (Hz)');ylabel('Delay (ms)');


CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;

for m=1:length(CFcombiselectALL)
        clear Dif;
        
        %if (CFcombiselectALL(m).CF2>=(k-1)*200)&(CFcombiselectALL(m).CF2<k*200)& CFcombiselectALL(m).pLinReg < 0.005
            %N=N+1;
            x=CFcombiselectALL(m).IPCx;y=CFcombiselectALL(m).IPCy;X=CFcombiselectALL(m).ISRx;Y=CFcombiselectALL(m).ISRy;
            if (CFcombiselectALL(m).CP < -0.5)|(CFcombiselectALL(m).CP >= 0.5)
                y=y+(CFcombiselectALL(m).CPr-CFcombiselectALL(m).CP);
            end;
            
            %adjust phase at CF2 between -0.5 and 0.5
            difvec=abs(x-ones(1,length(x))*CFcombiselectALL(m).CF2);
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
                    %plot(x(s),(yn(s))*1000/(x(s)),'o','MarkerFaceColor',CC,'MarkerEdgeColor',CC,'MarkerSize',3);hold on;
                %end;
                clear z;
            end;
            %line(x(large),(yn(large))*1000./(x(large)),'color','k');hold on;
            %ylim([-2.5 2.5]);%axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CFcombiselectALL(m).CPr+(CFcombiselectALL(m).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CFcombiselectALL(m).BF;yb=CFcombiselectALL(m).BPr;
            %plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=CFcombiselectALL(m).CF1;y1=CFcombiselectALL(m).CF1p;
            x2=CFcombiselectALL(m).CF2;y2=CFcombiselectALL(m).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            %xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            %xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            %plot(xd1,yd1,'r.','MarkerSize',8);hold on
            %plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CFcombiselectALL(m).CPr+(CFcombiselectALL(m).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '-', 'Color', [0.9 0.9 0.9], 'Marker', 'none','linewidth',0.1);hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselectALL(m).CPr+(CFcombiselectALL(m).CD/1000)*x;
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
                if CFcombiselectALL(m).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselectALL(m).CF2*(2^(-1/3));
                High=CFcombiselectALL(m).CF2*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    CFcombiselectALL(m).bumpfreq=x(maxbumpidx);
                    CFcombiselectALL(m).bumpdif=Dif(maxbumpidx);
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    %plot(x(maxbumpidx),y(maxbumpidx),'r.','MarkerSize',14);hold on
                    CFcombiselectALL(m).bumpfreq=x(maxbumpidx);
                    CFcombiselectALL(m).bumpdif=Dif(maxbumpidx);
                    
                end;
            end;
            
        %end;   
end;
    
    %height=get(gca,'ylim');
    %width=get(gca,'xlim');
    %ylim(height);
    %xlim(width);
    %if height<1
        %ylim([-0.5 1]);
    %end;
    %height=get(gca,'ylim')
    %patch([(k-1)*200 (k-1)*200 k*200 k*200],[height(1) height(2) height(2) height(1)],[0.8 0.8 0.8],'edgecolor',[0.8 0.8 0.8],'facealpha',0.5,'edgealpha',0.5);
    %clear height;clear width;

CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');
CFcombiselectALL_60=structfilter(CFcombiselectALL,'$spl$==60');
CFcombiselectALL_50=structfilter(CFcombiselectALL,'$spl$==50');
CFcombiselectALL_40=structfilter(CFcombiselectALL,'$spl$==40');
CFcombiselectALL_30=structfilter(CFcombiselectALL,'$spl$==30');

for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).pLinReg < 0.005
        plot(CFcombiselectALL(n).bumpfreq,CFcombiselectALL(n).spl,'k.','markersize',10);hold on;
    elseif CFcombiselectALL(n).pLinReg >= 0.005
        plot(CFcombiselectALL(n).bumpfreq,CFcombiselectALL(n).spl,'ko','markersize',10);hold on;
    end;
end;
hold off;ylabel('Tone intensity (dB)');xlabel('Frequency at bump (Hz)');

%one-way ANOVA for bumpfreq
bumpfreqX=[[CFcombiselectALL_70(:).bumpfreq] [CFcombiselectALL_60(:).bumpfreq] [CFcombiselectALL_50(:).bumpfreq] [CFcombiselectALL_40(:).bumpfreq] [CFcombiselectALL_30(:).bumpfreq]];
groupX=[repmat({'70'},1,length([CFcombiselectALL_70(:).bumpfreq])),...
    repmat({'60'},1,length([CFcombiselectALL_60(:).bumpfreq])),...
    repmat({'50'},1,length([CFcombiselectALL_50(:).bumpfreq])),...
    repmat({'40'},1,length([CFcombiselectALL_40(:).bumpfreq])),...
    repmat({'30'},1,length([CFcombiselectALL_30(:).bumpfreq]))];
[p,table,stats] = anova1(bumpfreqX,groupX)

c = multcompare(stats)



structplot(CFcombiselectALL,'bumpfreq','CF1','fit','linear')

structplot(CFcombiselectALL,'bumpfreq','CF2','fit','linear')

structplot(CFcombiselectALL,'bumpfreq','BF','fit','linear')

structplot(CFcombiselectALL,'bumpfreq','CF1',CFcombiselectALL,'bumpfreq','CF2','fit','linear')



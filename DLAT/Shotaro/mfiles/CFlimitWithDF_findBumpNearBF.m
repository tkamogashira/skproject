%x: frequency y: phase-frequency curve (blue line), CF2(ipsi; green), CF1(contra; black), bump(red) I have to add grid and adjust size of each panel
SIZE=size(CFcombiselectWithDFS);
startN=1;GroupN=0;
Nn=0;Nn2=0;

for m=1:(SIZE(2)-1)
    if strcmp(CFcombiselectWithDFS(m).Fiber2,CFcombiselectWithDFS(m+1).Fiber2)==0
        CF2group=CFcombiselectWithDFS(startN:m);
        %startN=m+1;
        GroupN=GroupN+1;
        display(GroupN)
        Size=size(CF2group);
        %assignin('base',['CF2group' num2str(GroupN)],CF2group);
        NN=ceil(GroupN/10)-1;
        axes('Position',[(GroupN-NN*10-1)*(1/10)+0.01 NN*(1/4)+0.01 1/10-0.01 1/4-0.01],'FontSize',8);hold on;
        N=0;N2=0;
        for n=1:Size(2)
            x=CF2group(n).IPCx;y=CF2group(n).IPCy;X=CF2group(n).ISRx;Y=CF2group(n).ISRy;
            if (CF2group(n).CP < -0.5)|(CF2group(n).CP >= 0.5)
                y=y+(CF2group(n).CPr-CF2group(n).CP);
            end;
            %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
            plot(x,y,'b');axis([0 4000 -2.5 2.5]);grid on;hold on
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CF2group(n).CPr+(CF2group(n).CD/1000)*X(YMi);
            plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CF2group(n).BF;yb=CF2group(n).BPr;
            plot(xb,yb,'y*','MarkerSize',5);hold on
            
            x1=CF2group(n).CF1;y1=CF2group(n).CF1p;
            x2=CF2group(n).CF2;y2=CF2group(n).CF2p;
            plot(x1,y1,'m.','MarkerSize',8);hold on
            plot(x2,y2,'g.','MarkerSize',8);hold on
            
            xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
            xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
            plot(xd1,yd1,'r.','MarkerSize',8);hold on
            plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CF2group(n).CPr+(CF2group(n).CD/1000)*xk;
            line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CF2group(n).CPr+(CF2group(n).CD/1000)*x;
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
                if CF2group(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CF2group(n).BF*(2^(-1/3));
                High=CF2group(n).BF*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                    CFcombiselectWithDFS(startN-1+n).bumpfreq=x(maxbumpidx);
                    N=[N startN-1+n];
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx),'b*','MarkerSize',6);hold on
                    CFcombiselectWithDFS(startN-1+n).bumpfreq=x(maxbumpidx);
                    N2=[N2 startN-1+n];
                end;
            end;
        end;
        hold off;
        Nn=[Nn N];display(Nn);Nn2=[Nn2 N2];display(Nn2);
        startN=m+1;
    end;
  
end;
%Sequence for the last group, which has the largest CF2
CF2group=CFcombiselectWithDFS(startN:SIZE(2));
GroupN=GroupN+1;
display(GroupN)
Size=size(CF2group);
%assignin('base',['CF2group' num2str(GroupN)],CF2group);
NN=ceil(GroupN/10)-1;
axes('Position',[(GroupN-NN*10-1)*(1/10)+0.01 NN*(1/4)+0.01 1/10-0.01 1/4-0.01],'FontSize',8);hold on;
N=0;N2=0;
for n=1:Size(2)
    x=CF2group(n).IPCx;y=CF2group(n).IPCy;X=CF2group(n).ISRx;Y=CF2group(n).ISRy;
    if (CF2group(n).CP < -0.5)|(CF2group(n).CP >= 0.5)
        y=y+(CF2group(n).CPr-CF2group(n).CP);
    end;
    %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
    plot(x,y,'b');axis([0 4000 -2.5 2.5]);grid on;hold on
    %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
    [YM,YMi]=max(Y);YY=CF2group(n).CPr+(CF2group(n).CD/1000)*X(YMi);
    plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
    xb=CF2group(n).BF;yb=CF2group(n).BPr;
    plot(xb,yb,'y*','MarkerSize',5);hold on
            
    x1=CF2group(n).CF1;y1=CF2group(n).CF1p;
    x2=CF2group(n).CF2;y2=CF2group(n).CF2p;
    plot(x1,y1,'m.','MarkerSize',8);hold on
    plot(x2,y2,'g.','MarkerSize',8);hold on
            
    xd1=CF2group(n).DF1;yd1=CF2group(n).CPr+(CF2group(n).CD/1000)*xd1;
    xd2=CF2group(n).DF2;yd2=CF2group(n).CPr+(CF2group(n).CD/1000)*xd2;
    plot(xd1,yd1,'r.','MarkerSize',8);hold on
    plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
    xk=(0:10:max(x));
    yk=CF2group(n).CPr+(CF2group(n).CD/1000)*xk;
    line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            
    %x3=(xb-100:10:xb+100);
    %line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
    clear Dif;clear MM1;clear bump;clear DifM;
    ykd=CF2group(n).CPr+(CF2group(n).CD/1000)*x;
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
        if CF2group(n).CD>=0
            [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
        else
            [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
        end;
        Low=CF2group(n).BF*(2^(-1/3));
        High=CF2group(n).BF*(2^(1/3));
        if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
            plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
            CFcombiselectWithDFS(startN-1+n).bumpfreq=x(maxbumpidx);
            N=[N startN-1+n];
        end;
        if x(maxbumpidx)<Low|High<x(maxbumpidx)
            plot(x(maxbumpidx),y(maxbumpidx),'b*','MarkerSize',6);hold on
            CFcombiselectWithDFS(startN-1+n).bumpfreq=x(maxbumpidx);
            N2=[N2 startN-1+n];
        end;
    end;
end;
hold off;
Nn=[Nn N];display(Nn);Nn2=[Nn2 N2];display(Nn2);

Number1=length(find(Nn>0));display(Number1)
Number2=length(find(Nn2>0));display(Number2)
assignin('base','CFcombiselectWithDFS_NearBF',CFcombiselectWithDFS);

%x: frequency y: phase-frequency curve (blue line), CF2(ipsi; green), CF1(contra; black), bump(red) I have to add grid and adjust size of each panel
SIZE=size(DFcombiselectS);
startN=1;GroupN=0;
for m=1:(SIZE(2)-1)
    if strcmp(DFcombiselectS(m).Fiber2,DFcombiselectS(m+1).Fiber2)==0
        DF2group=DFcombiselectS(startN:m);
        startN=m+1;
        GroupN=GroupN+1;
        Size=size(DF2group);
        assignin('base',['DF2group' num2str(GroupN)],DF2group);
        NN=ceil(GroupN/10)-1;
        axes('Position',[(GroupN-NN*10-1)*(1/10)+0.01 NN*(1/4)+0.01 1/10-0.01 1/4-0.01],'FontSize',6);hold on;
        for n=1:Size(2)
            x=DF2group(n).IPCx;y=DF2group(n).IPCy;X=DF2group(n).ISRx;Y=DF2group(n).ISRy;
            if (DF2group(n).CP < -0.5)|(DF2group(n).CP >= 0.5)
                y=y+(DF2group(n).CPr-DF2group(n).CP);
            end;
            [YM,YMi]=max(Y);
            xb=DF2group(n).BF;yb=DF2group(n).BPr;
            x1=DF2group(n).CF1;y1=DF2group(n).CF1p;
            x2=DF2group(n).CF2;y2=DF2group(n).CF2p;
            
            xd1=DF2group(n).DF1;yd1=DF2group(n).DF1p;
            xd2=DF2group(n).DF2;yd2=DF2group(n).DF2p;
            
            %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-xd2));bumpx=x(dif(id));bumpy=y(dif(id));
            plot(x,y,'b');axis([0 4000 -4 4]);grid on;hold on
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            
            %plot(DF2group(n).CF1,X(YMi),'ro','MarkerSize',8);axis([0 4000 0 2500]);hold on
            %plot(DF2group(n).CF1,xb,'b*','MarkerSize',3);hold on
            plot(x1,y1,'k.','MarkerSize',8);hold on
            plot(x2,y2,'g.','MarkerSize',8);hold on
            
            plot(xd1,yd1,'r.','MarkerSize',8);hold on
            plot(xd2,yd2,'c.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=DF2group(n).CPr+(DF2group(n).CD/1000)*xk;
            line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');hold on
            x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(DF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
        end;
        hold off;
    end;
end
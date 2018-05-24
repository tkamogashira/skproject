%x: frequency y: phase-frequency curve (blue line), CF2(ipsi; green), CF1(contra; black), bump(red) I have to add grid and adjust size of each panel
SIZE=size(CFcombiselectWithDFS);
startN=1;GroupN=0;
for m=1:(SIZE(2)-1)
    if strcmp(CFcombiselectWithDFS(m).Fiber2,CFcombiselectWithDFS(m+1).Fiber2)==0
        CF2group=CFcombiselectWithDFS(startN:m);
        startN=m+1;
        GroupN=GroupN+1;
        Size=size(CF2group);
        %assignin('base',['CF2group' num2str(GroupN)],CF2group);
        NN=ceil(GroupN/10)-1;
        axes('Position',[(GroupN-NN*10-1)*(1/10)+0.01 NN*(1/4)+0.01 1/10-0.01 1/4-0.01],'FontSize',8);hold on;
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
        end;
        hold off;
    end;
end
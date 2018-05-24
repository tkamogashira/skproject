function struct2bump2

SIZE=size(CFcombiselectS);
startN=1;GroupN=0;
for m=1:(SIZE(2)-1)
    if strcmp(CFcombiselectS(m).Fiber2,CFcombiselectS(m+1).Fiber2)==0
        CF2group=CFcombiselectS(startN:m);
        startN=m+1;
        GroupN=GroupN+1;
        Size=size(CF2group);
        %assignin('base',['CF2group' num2str(GroupN)],CF2group);
        
        for n=1:Size(2)
            x=CF2group(n).IPCx;y=CF2group(n).IPCy;X=CF2group(n).ISRx;Y=CF2group(n).ISRy;
            if (CF2group(n).CP < -0.5)|(CF2group(n).CP >= 0.5)
                y=y+(CF2group(n).CPr-CF2group(n).CP);
            end;
            
            [YM,YMi]=max(Y);
        
            xb=CF2group(n).BF;yb=CF2group(n).BPr;
        
            x1=CF2group(n).CF1;y1=CF2group(n).CF1p;
        
            x2=CF2group(n).CF2;y2=CF2group(n).CF2p;
        
            R=13;C=3;
            
            dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
            
            
            subplot(R,C,GroupN);plot(x,y,'b');axis([0 4000 -1 2.5]);hold on
            subplot(R,C,GroupN);plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            %subplot(R,C,GroupN);plot(CF2group(n).CF1,X(YMi),'ro','MarkerSize',8);axis([0 4000 0 2500]);hold on
            %subplot(R,C,GroupN);plot(CF2group(n).CF1,xb,'b*','MarkerSize',3);hold on
            subplot(R,C,GroupN);plot(x1,y1,'k.','MarkerSize',8);plot(x2,y2,'g.','MarkerSize',8);hold on
            xk=(0:10:max(x));
            yk=CF2group(n).CPr+(CF2group(n).CD/1000)*xk;
            %subplot(R,C,GroupN);line(xk,yk,'LineStyle', '-', 'Color', 'k', 'Marker', 'none');hold on
            x3=(xb-100:10:xb+100);
            %subplot(R,C,GroupN);line(x3,(x3-xb)*(CF2group(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
        end;
        
    end;
end
        
    
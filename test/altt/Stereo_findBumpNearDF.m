SIZE=size(CFcombiselect8121single);
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=DF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    for n=1:SIZE(2)
        if (CFcombiselect8121single(n).BF>=(k-1)*100)&(CFcombiselect8121single(n).BF<k*100)
            
            
            x=CFcombiselect8121single(n).IPCx;y=CFcombiselect8121single(n).IPCy;X=CFcombiselect8121single(n).ISRx;Y=CFcombiselect8121single(n).ISRy;
            if (CFcombiselect8121single(n).CP < -0.5)|(CFcombiselect8121single(n).CP >= 0.5)
                y=y+(CFcombiselect8121single(n).CPr-CFcombiselect8121single(n).CP);
            end;
            %dify=[y 0]-[0 y];dify(1)=[];dif=find(dify<0);[Min,id]=min(abs(x(dif)-x2));bumpx=x(dif(id));bumpy=y(dif(id));
            plot(x,y,'b');grid on;hold on;axis([0 4000 -2.5 2.5]);
            %plot(bumpx,bumpy,'r*','MarkerSize',4);hold on
            [YM,YMi]=max(Y);YY=CFcombiselect8121single(n).CPr+(CFcombiselect8121single(n).CD/1000)*X(YMi);
            %plot(X(YMi),YY,'ko','MarkerSize',6);hold on
            
            xb=CFcombiselect8121single(n).BF;yb=CFcombiselect8121single(n).BPr;
            plot(xb,yb,'go','MarkerSize',2,'MarkerFaceColor','g');hold on
            
            x1=CFcombiselect8121single(n).CF1;y1=CFcombiselect8121single(n).CF1p;
            x2=CFcombiselect8121single(n).CF2;y2=CFcombiselect8121single(n).CF2p;
            %plot(x1,y1,'m.','MarkerSize',8);hold on
            %plot(x2,y2,'g.','MarkerSize',8);hold on
            
            xk=(0:10:max(x));
            yk=CFcombiselect8121single(n).CPr+(CFcombiselect8121single(n).CD/1000)*xk;
            %line(xk,yk,'LineStyle', '--', 'Color', 'k', 'Marker', 'none');hold on
            
            %x3=(xb-100:10:xb+100);
            %line(x3,(x3-xb)*(CFcombiselect8121single(n).BestITD)/1000+yb,'LineStyle', '-', 'Color', 'm', 'Marker', 'none');
            clear Dif;clear MM1;clear bump;clear DifM;
            ykd=CFcombiselect8121single(n).CPr+(CFcombiselect8121single(n).CD/1000)*x;
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
                if CFcombiselect8121single(n).CD>=0
                    [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                else
                    [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                end;
                Low=CFcombiselect8121single(n).BF*(2^(-1/3));
                High=CFcombiselect8121single(n).BF*(2^(1/3));
                if Low<=x(maxbumpidx)&x(maxbumpidx)<=High
                    plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                    
                end;
                if x(maxbumpidx)<Low|High<x(maxbumpidx)
                    plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
                    
                end;
            end;
            
        end;
    end;
    hold off;
end;



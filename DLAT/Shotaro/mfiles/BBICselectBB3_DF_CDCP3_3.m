SIZE=size(BBICselectBB3);
for k=1:50
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.03 1-(NN+1)*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    xlabel([num2str(40*2^((k-1)/8)) '<=DF<' num2str(40*2^(k/8))],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    n=1;
    for m=1:SIZE(2)
        if (BBICselectBB3(m).CP < -0.5)|(BBICselectBB3(m).CP >= 0.5)
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP-round(BBICselectBB3(m).CP);
        
            Dif=BBICselectBB3(m).CPr-BBICselectBB3(m).CP;
        
            size1=size(BBICselectBB3(m).sigpY);
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY+ones(1,size1(2))*Dif;
        
            size2=size(BBICselectBB3(m).lineY);
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY+ones(1,size2(2))*Dif;
        
        else
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP;
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY;
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY;
        end;
        
        %if BBICselectBB3(m).ThrCF>0
            if (BBICselectBB3(m).DomF>=40*2^((k-1)/8))&(BBICselectBB3(m).DomF<40*2^(k/8))
                if BBICselectBB3(m).pLinReg<0.001
                    plot(BBICselectBB3(m).CP,BBICselectBB3(m).CD,'b.','MarkerSize',10);axis([-1 1 -2 2]);grid on;hold on
                    grp(1,n)=BBICselectBB3(m).CP;grp(2,n)=BBICselectBB3(m).CD;
                    display(n);
                    n=n+1;
                else
                    plot(BBICselectBB3(m).CP,BBICselectBB3(m).CD,'m.','MarkerSize',10);axis([-1 1 -2 2]);grid on;hold on
                end;
                %plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
            
            end;
            %end;
    end;
    if n>2
        display(grp)
        p=polyfit(grp(1,:),grp(2,:),1);z=polyval(p,grp(1,:));plot(grp(1,:),z,'k');axis([-1 1 -2 2]);grid on;hold on
        pLinReg=signlinreg(p,grp(1,:),grp(2,:));
        text(0,-1.5,num2str(pLinReg));
    end;
    hold off;
    clear n;clear grp;clear p;clear z;clear pLinReg;
end;

figure;
SIZE=size(BBICselectBB3);
for k=1:50
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.03 1-(NN+1)*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    xlabel([num2str(40*2^((k-1)/8)) '<=DF<' num2str(40*2^(k/8))],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    n=1;
    for m=1:SIZE(2)
        if (BBICselectBB3(m).CP < -0.5)|(BBICselectBB3(m).CP >= 0.5)
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP-round(BBICselectBB3(m).CP);
        
            Dif=BBICselectBB3(m).CPr-BBICselectBB3(m).CP;
        
            size1=size(BBICselectBB3(m).sigpY);
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY+ones(1,size1(2))*Dif;
        
            size2=size(BBICselectBB3(m).lineY);
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY+ones(1,size2(2))*Dif;
        
        else
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP;
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY;
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY;
        end;
        
        %if BBICselectBB3(m).ThrCF>0
            if (BBICselectBB3(m).DomF>=40*2^((k-1)/8))&(BBICselectBB3(m).DomF<40*2^(k/8))
                if BBICselectBB3(m).pLinReg<0.001
                    %plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'b.','MarkerSize',10);axis([-0.5 0.5 -2 2]);grid on;hold on
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpY,'b');axis([0 4000 -2 2]);grid on;hold on
                    plot(BBICselectBB3(m).DomF,BBICselectBB3(m).DomF*BBICselectBB3(m).CD/1000+BBICselectBB3(m).CP,'c.','MarkerSize',8);
                    plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineY,'c');
                    
                    grp(1,n)=BBICselectBB3(m).CP;grp(2,n)=BBICselectBB3(m).CD;
                    display(n);
                    n=n+1;
                else
                    %plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'m.','MarkerSize',10);axis([-0.5 0.5 -2 2]);grid on;hold on
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpY,'m');axis([0 4000 -2 2]);grid on;hold on
                    plot(BBICselectBB3(m).DomF,BBICselectBB3(m).DomF*BBICselectBB3(m).CD/1000+BBICselectBB3(m).CP,'r.','MarkerSize',8);
                    plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineY,'r');
                end;
                %plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
            
            end;
            %end;
    end;
    if n>2
        display(grp)
        p=polyfit(grp(1,:),grp(2,:),1);z=polyval(p,grp(1,:));%plot(grp(1,:),z,'k');axis([-0.5 0.5 -2 2]);grid on;hold on
        pLinReg=signlinreg(p,grp(1,:),grp(2,:));
        %text(0,-1.5,num2str(pLinReg));
    end;
    hold off;
    clear n;clear grp;clear p;clear z;clear pLinReg;
end;

SIZE=size(BBICselectBB3);
for k=1:30
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.03 1-(NN+1)*(1/3)+0.02 1/10-0.02 1/3-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-13)*0.2) '<=CD<' num2str((k-12)*0.2)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
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
        
        %if BBICselectBB3(m).ThrCF~=[]
            if (BBICselectBB3(m).CD>=(k-13)*0.2)&(BBICselectBB3(m).CD<(k-12)*0.2)
                if BBICselectBB3(m).Mserr<0.0005
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'b');axis([0 2000 -2 2]);grid on;hold on
                    plot(0,BBICselectBB3(m).CPr,'b.','MarkerSize',8);axis([0 2000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectWithCF(m).lineYr,'b');axis([0 2000 -2 2]);grid on;hold on
                elseif (BBICselectBB3(m).Mserr>=0.0005)&(BBICselectBB3(m).Mserr<0.001)
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'c');axis([0 2000 -2 2]);grid on;hold on
                    plot(100,BBICselectBB3(m).CPr,'c.','MarkerSize',8);axis([0 2000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectWithCF(m).lineYr,'c');axis([0 2000 -2 2]);grid on;hold on
                elseif (BBICselectBB3(m).Mserr>=0.001)&(BBICselectBB3(m).Mserr<0.005)
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'g');axis([0 2000 -2 2]);grid on;hold on
                    plot(200,BBICselectBB3(m).CPr,'g.','MarkerSize',8);axis([0 2000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectWithCF(m).lineYr,'g');axis([0 2000 -2 2]);grid on;hold on
                else
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'m');axis([0 2000 -2 2]);grid on;hold on
                    plot(300,BBICselectBB3(m).CPr,'r.','MarkerSize',8);axis([0 2000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectWithCF(m).lineYr,'r');axis([0 2000 -2 2]);grid on;hold on
                end;
                %plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
            
            end;
            %end;
    end;
    hold off;
end;

figure;
for m=1:SIZE(2)
    if BBICselectBB3(m).Mserr<0.0005
        plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'b.','MarkerSize',8);axis([-0.5 0.5 -2 2]);grid on;hold on
    elseif (BBICselectBB3(m).Mserr>=0.0005)&(BBICselectBB3(m).Mserr<0.001)
        plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'c.','MarkerSize',8);axis([-0.5 0.5 -2 2]);grid on;hold on
    elseif (BBICselectBB3(m).Mserr>=0.001)&(BBICselectBB3(m).Mserr<0.005)
        plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'g.','MarkerSize',8);axis([-0.5 0.5 -2 2]);grid on;hold on
    else
        plot(BBICselectBB3(m).CPr,BBICselectBB3(m).CD,'r.','MarkerSize',8);axis([-0.5 0.5 -2 2]);grid on;hold on
    end;
end;



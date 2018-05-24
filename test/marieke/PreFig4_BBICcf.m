SIZE=size(BBICselectWithCF);
for k=1:44
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    for m=1:SIZE(2)
        if isempty(BBICselectWithCF(m).ThrCF)==0
            if (BBICselectWithCF(m).ThrCF>=(k-1)*50)&(BBICselectWithCF(m).ThrCF<k*50)
                plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
            end;
        end;
    end;
    hold off;
end;

figure

SIZE=size(BBICselectWithCF);
for k=1:44
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    for m=1:SIZE(2)
        if isempty(BBICselectWithCF(m).ThrCF)==0
            if (BBICselectWithCF(m).ThrCF>=(k-1)*50)&(BBICselectWithCF(m).ThrCF<k*50)
                plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');grid on;hold on
                plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
            end;
        end;
    end;
    hold off;
end;



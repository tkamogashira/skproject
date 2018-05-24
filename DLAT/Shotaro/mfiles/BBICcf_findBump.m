SIZE=size(BBICselectWithCF);
BBICselectWithCF_S=BBICselectWithCF;
for k=1:44
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    for m=1:SIZE(2)
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF(m).sigpX.*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr;
        Dif=BBICselectWithCF(m).sigpY-LINEY;
        %display(m)
        %display(Dif)
        %display(length(Dif)-1)
        clear DifM;
        for a=1:(length(Dif)-1)
            if Dif(a)*Dif(a+1)<0
                DifM(a)=1;
            else
                DifM(a)=0;
            end;
        end;
        %display(DifM)
        DifM(length(Dif))=0;
        %display(DifM)
        MM1=find(DifM==1);
        
        %display(MM1)
        %display(Dif)
        if length(MM1)>=2
            bump=Dif(min(MM1)+1:max(MM1));
            MMM=max(abs(bump));
            d=find(abs(Dif)==MMM);
            BBICselectWithCF_S(m).maxbumpidx=d;
            BBICselectWithCF_S(m).maxbump=Dif(d);
        else
            BBICselectWithCF_S(m).maxbumpidx=0;
            BBICselectWithCF_S(m).maxbump=0;
        end;
        if BBICselectWithCF(m).ThrCF~=[]
            if (BBICselectWithCF(m).ThrCF>=(k-1)*50)&(BBICselectWithCF(m).ThrCF<k*50)
                plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                if BBICselectWithCF_S(m).maxbumpidx>0
                    plot(BBICselectWithCF(m).sigpX(BBICselectWithCF_S(m).maxbumpidx),BBICselectWithCF(m).sigpY(BBICselectWithCF_S(m).maxbumpidx),'b*','MarkerSize',6);
                end;
                
            end;
            
            
            
        end;
        
    end;
    hold off;
end;
assignin('base','BBICselectWithCF_S',BBICselectWithCF_S)



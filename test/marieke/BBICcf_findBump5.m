SIZE=size(BBICselectWithCF);
%BBICselectWithCF_S=BBICselectWithCF;
for k=1:44
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/5)+0.02 1/10-0.02 1/5-0.02],'FontSize',8);hold on;
    for m=1:SIZE(2)
        clear Dif;
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF(m).sigpX.*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr;
        Dif=BBICselectWithCF(m).sigpY-LINEY;
        %display(m)
        %display(Dif)
        %display(length(Dif)-1)
        clear DifM;clear MM1;clear bump;clear MMM;
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
        
        if BBICselectWithCF(m).ThrCF~=[]
            Low=BBICselectWithCF(m).ThrCF*(2^(-1/3));
            High=BBICselectWithCF(m).ThrCF*(2^(1/3));
            
            if (BBICselectWithCF(m).ThrCF>=(k-1)*50)&(BBICselectWithCF(m).ThrCF<k*50)
                plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 4000 -2 2]);grid on;hold on
                plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
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
                    if BBICselectWithCF(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    Low=BBICselectWithCF(m).ThrCF*(2^(-1/3));
                    High=BBICselectWithCF(m).ThrCF*(2^(1/3));
                    if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'m*','MarkerSize',6);hold on
                    else
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'b*','MarkerSize',6);hold on
                    end;
                end;
            end;
        end;
    end;
    hold off;
end;




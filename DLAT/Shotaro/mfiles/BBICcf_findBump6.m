SIZE=size(BBICselectWithCF);
BBICselectWithCF_S=BBICselectWithCF;
for k=1:11
    NN=ceil(k/6)-1;
    axes('Position',[(k-NN*6-1)*(1/6)+0.02 NN*(1/2)+0.02 1/6-0.02 1/2-0.02],'FontSize',8);hold on;
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
            
            if (BBICselectWithCF(m).ThrCF>=(k-1)*200)&(BBICselectWithCF(m).ThrCF<k*200)
                
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
                        plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 3000 -2 2]);grid on;hold on
                        plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        %else
                        %BBICselectWithCF_S(m).bumpfreq=[];
                    end;
                    %else
                    %BBICselectWithCF_S(m).bumpfreq=[];
                end;
                
            end;
        end;
    end;
    hold off;
end;
hold off
figure
for x=1:SIZE(2)
    if isempty(BBICselectWithCF_S(x).bumpfreq)==0
        plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq,'bo');grid on;hold on
    end;
end;
hold off

figure
for x=1:SIZE(2)
    if isempty(BBICselectWithCF_S(x).bumpfreq)==0&isempty(BBICselectWithCF_S(x).ThrCF)==0
        plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).ThrCF,'bo');grid on;hold on
        plot(BBICselectWithCF_S(x).CD,abs(BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).ThrCF),'r*','MarkerSize',4);
    end;
end;
hold off

figure
SIZE=size(BBICselectWithCF);
for k=1:11
    NN=ceil(k/6)-1;
    axes('Position',[(k-NN*6-1)*(1/6)+0.02 NN*(1/2)+0.02 1/6-0.02 1/2-0.02],'FontSize',8);hold on;
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
            
            if (BBICselectWithCF(m).ThrCF>=(k-1)*200)&(BBICselectWithCF(m).ThrCF<k*200)
                
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
                    if BBICselectWithCF(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF(m).sigpX(maxbumpidx)
                        plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 3000 -2 2]);grid on;hold on
                        plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'b*','MarkerSize',6);hold on
                    end;
                else
                    plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');axis([0 3000 -2 2]);grid on;hold on
                    plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                    plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                    plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                    plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                end;
            end;
        end;
    end;
    hold off;
end;
assignin('base','BBICselectWithCF_S',BBICselectWithCF_S);


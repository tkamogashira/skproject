SIZE=size(BBICselectWithCF);
BBICselectWithCF_S=BBICselectWithCF;
Nn=0;
for k=1:18
    NN=ceil(k/6)-1;
    axes('Position',[(k-NN*6-1)*(1/6)+0.02 NN*(1/3)+0.02 1/6-0.02 1/3-0.02],'FontSize',8);hold on;
    N=0;
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
        
        if BBICselectWithCF(m).ThrCF>0
            
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
                    Low=BBICselectWithCF(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF(m).DomF*(2^(1/3));
                    if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                        plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');grid on;hold on;%axis([0 3000 -2 2]);
                        plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        end;
    end;
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)



figure
SIZE=size(BBICselectWithCF);
Nn2=0;Nn3=0;
for k=1:18
    NN=ceil(k/6)-1;
    axes('Position',[(k-NN*6-1)*(1/6)+0.02 NN*(1/3)+0.02 1/6-0.02 1/3-0.02],'FontSize',8);hold on;
    N2=0;N3=0;
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
        
        if BBICselectWithCF(m).ThrCF>0
            
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
                    Low=BBICselectWithCF(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF(m).DomF*(2^(1/3));
                    if BBICselectWithCF(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF(m).sigpX(maxbumpidx)
                        plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');grid on;hold on;%axis([0 3000 -2 2]);
                        plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),BBICselectWithCF(m).sigpY(maxbumpidx),'b*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        N2=[N2 m];
                    end;
                else
                    plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr,'b');grid on;hold on;%axis([0 3000 -2 2]);
                    plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                    plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                    plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                    plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                    N3=[N3 m];    
                end;
            end;
        end;
    end;
    hold off;
    Nn2=[Nn2 N2];display(Nn2);Nn3=[Nn3 N3];display(Nn3);
end;
display(Number1);
Number2=length(find(Nn2>0));display(Number2);Number3=length(find(Nn3>0));display(Number3);
assignin('base','BBICselectWithCF_S',BBICselectWithCF_S);

figure
for x=1:SIZE(2)
    if isempty(BBICselectWithCF_S(x).bumpfreq)==0
        Low=BBICselectWithCF_S(x).DomF*(2^(-1/3));
        High=BBICselectWithCF_S(x).DomF*(2^(1/3));
        if Low<=BBICselectWithCF_S(x).bumpfreq&BBICselectWithCF_S(x).bumpfreq<=High
            plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq,'mo');grid on;hold on
        else
            plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq,'bo');grid on;hold on
        end;
    end;
end;
hold off

figure
for x=1:SIZE(2)
    if isempty(BBICselectWithCF_S(x).bumpfreq)==0&isempty(BBICselectWithCF_S(x).DomF)==0
        Low=BBICselectWithCF_S(x).DomF*(2^(-1/3));
        High=BBICselectWithCF_S(x).DomF*(2^(1/3));
        if Low<=BBICselectWithCF_S(x).bumpfreq&BBICselectWithCF_S(x).bumpfreq<=High
            plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).DomF,'mo');grid on;hold on
            plot(BBICselectWithCF_S(x).CD,abs(BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).DomF),'m*','MarkerSize',4);
        else
            plot(BBICselectWithCF_S(x).CD,BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).DomF,'bo');grid on;hold on
            plot(BBICselectWithCF_S(x).CD,abs(BBICselectWithCF_S(x).bumpfreq-BBICselectWithCF_S(x).DomF),'b*','MarkerSize',4);
        end;
    end;
end;
hold off

figure

SIZE=size(BBICselectWithCF);
Nn2=0;Nn3=0;
for k=1:18
    NN=ceil(k/6)-1;
    axes('Position',[(k-NN*6-1)*(1/6)+0.02 NN*(1/3)+0.02 1/6-0.02 1/3-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*200) '<=DomF<' num2str(k*200)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    
    N2=0;N3=0;
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
        
        %if BBICselectWithCF(m).ThrCF>0
            if (BBICselectWithCF(m).DomF>=(k-1)*200)&(BBICselectWithCF(m).DomF<k*200)
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
                    Low=BBICselectWithCF(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF(m).DomF*(2^(1/3));
                    
                    plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr-BBICselectWithCF(m).lineYr,'k');grid on;hold on;%axis([0 3000 -2 2]);
                    
                    BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                    BBICselectWithCF_S(m).bumpdif=Dif(maxbumpidx);
                    
                    if BBICselectWithCF(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),Dif(maxbumpidx),'b*','MarkerSize',6);hold on
                        
                    elseif Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                        plot(BBICselectWithCF(m).sigpX(maxbumpidx),Dif(maxbumpidx),'m*','MarkerSize',6);hold on
                    else
                        N2=[N2 m];
                    end;
                else
                    plot(BBICselectWithCF(m).sigpX,BBICselectWithCF(m).sigpYr-BBICselectWithCF(m).lineYr,'k');grid on;hold on;%axis([0 3000 -2 2]);
                    %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                    %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                    %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                    %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                    N3=[N3 m];    
                end;
            end;
            %end;
    end;
    hold off;
    Nn2=[Nn2 N2];display(Nn2);Nn3=[Nn3 N3];display(Nn3);
end;
display(Number1);
Number2=length(find(Nn2>0));display(Number2);Number3=length(find(Nn3>0));display(Number3);


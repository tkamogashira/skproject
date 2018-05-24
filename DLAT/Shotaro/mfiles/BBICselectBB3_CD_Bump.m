SIZE=size(BBICselectBB3);
BBICselectBB3_S=BBICselectBB3;
Nn=0;
for k=1:30
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.03 1-(NN+1)*(1/3)+0.02 1/10-0.02 1/3-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-13)*0.2) '<=CD<' num2str((k-12)*0.2)],'FontSize',6,'Units','normalized','Position',[0.5,1]);

    N=0;
    for m=1:SIZE(2)
        clear Dif;
        
        clear Diff;
        if (BBICselectBB3(m).CP < -0.5)|(BBICselectBB3(m).CP >= 0.5)
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP-round(BBICselectBB3(m).CP);
        
            Diff=BBICselectBB3(m).CPr-BBICselectBB3(m).CP;
        
            size1=size(BBICselectBB3(m).sigpY);
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY+ones(1,size1(2))*Diff;
        
            size2=size(BBICselectBB3(m).lineY);
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY+ones(1,size2(2))*Diff;
        
        else
            BBICselectBB3(m).CPr=BBICselectBB3(m).CP;
            BBICselectBB3(m).sigpYr=BBICselectBB3(m).sigpY;
            BBICselectBB3(m).lineYr=BBICselectBB3(m).lineY;
        end;
        
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectBB3(m).sigpX.*BBICselectBB3(m).CD/1000+BBICselectBB3(m).CPr;
        Dif=BBICselectBB3(m).sigpY-LINEY;
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
        if (BBICselectBB3(m).CD>=(k-13)*0.2)&(BBICselectBB3(m).CD<(k-12)*0.2)
            %plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'b');axis([0 2000 -2 2]);grid on;hold on
            %plot(0,BBICselectBB3(m).CPr,'b.','MarkerSize',8);axis([0 2000 -2 2]);grid on;hold on
            if BBICselectBB3(m).Mserr>=0.001            
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
                    if BBICselectBB3(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    %Low=BBICselectWithCF(m).DomF*(2^(-1/3));
                    %High=BBICselectWithCF(m).DomF*(2^(1/3));
                    %if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'r');axis([0 3000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineYr,'k--');
                    plot(BBICselectBB3(m).VSBF,-1,'r.','MarkerSize',8);
                    plot(BBICselectBB3(m).RateBF,-0.5,'r.','MarkerSize',8);
                    %plot(BBICselectBB3(m).ThrCF,BBICselectBB3(m).ThrCF*BBICselectBB3(m).CD/1000+BBICselectBB3(m).CPr,'r.','MarkerSize',8);
                        
                    plot(BBICselectBB3(m).sigpX(maxbumpidx),BBICselectBB3(m).sigpY(maxbumpidx),'r*','MarkerSize',6);hold on
                    BBICselectBB3_S(m).bumpfreq=BBICselectBB3(m).sigpX(maxbumpidx);
                    N=[N m];
                else
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'m');axis([0 3000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineYr,'k--');
                    plot(BBICselectBB3(m).VSBF,-1.1,'m.','MarkerSize',8);
                    plot(BBICselectBB3(m).RateBF,-0.6,'m.','MarkerSize',8);
                end;
            else
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
                    if BBICselectBB3(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    %Low=BBICselectWithCF(m).DomF*(2^(-1/3));
                    %High=BBICselectWithCF(m).DomF*(2^(1/3));
                    %if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'b');axis([0 3000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineYr,'k--');
                    plot(BBICselectBB3(m).VSBF,-1.2,'b.','MarkerSize',8);
                    plot(BBICselectBB3(m).RateBF,-0.7,'b.','MarkerSize',8);
                    %plot(BBICselectBB3(m).ThrCF,BBICselectBB3(m).ThrCF*BBICselectBB3(m).CD/1000+BBICselectBB3(m).CPr,'r.','MarkerSize',8);
                        
                    plot(BBICselectBB3(m).sigpX(maxbumpidx),BBICselectBB3(m).sigpY(maxbumpidx),'b*','MarkerSize',6);hold on
                    BBICselectBB3_S(m).bumpfreq=BBICselectBB3(m).sigpX(maxbumpidx);
                    N=[N m];
                else
                    plot(BBICselectBB3(m).sigpX,BBICselectBB3(m).sigpYr,'c');axis([0 3000 -2 2]);grid on;hold on
                    %plot(BBICselectBB3(m).lineX,BBICselectBB3(m).lineYr,'k--');
                    plot(BBICselectBB3(m).VSBF,-1.3,'c.','MarkerSize',8);
                    plot(BBICselectBB3(m).RateBF,-0.8,'c.','MarkerSize',8);
                end;
            end;
        end;
    end;
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)


assignin('base','BBICselectBB3_S',BBICselectBB3_S);



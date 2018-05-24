SIZE=size(BBICselectWithCF);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=ThrCF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
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
            
            if (BBICselectWithCF(m).ThrCF>=(k-1)*100)&(BBICselectWithCF(m).ThrCF<k*100)
                
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
                    
                    x=BBICselectWithCF(m).sigpX;y=BBICselectWithCF(m).sigpYr;
                    xdif=x-ones(1,length(x))*BBICselectWithCF(m).ThrCF;
                    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                    if isempty(Lind)==0 & isempty(Rind)==0
                        BBICselectWithCF(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
                        x2=BBICselectWithCF(m).ThrCF;y2=BBICselectWithCF(m).ThrCFph;
                        plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                    end;
                    line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;axis([0 2500 -1.2 1.2]);
    
                    if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
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

%delay-frequency plot
figure
SIZE=size(BBICselectWithCF);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=ThrCF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
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
            
            if (BBICselectWithCF(m).ThrCF>=(k-1)*100)&(BBICselectWithCF(m).ThrCF<k*100)
                
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
                    
                    x=BBICselectWithCF(m).sigpX;y=BBICselectWithCF(m).sigpYr;
                    negyind1=find(y>=-1 & y<0);negyind2=find(y>=-2 & y<-1);
                    posyind1=find(y>=1 & y<2);posyind2=find(y>=2 & y<3);
                    yn=y;
                    yn(negyind1)=y(negyind1)+1;yn(negyind2)=y(negyind2)+2;
                    yn(posyind1)=y(posyind1)-1;yn(posyind2)=y(posyind2)-2;
                    
                    
                    xdif=x-ones(1,length(x))*BBICselectWithCF(m).ThrCF;
                    Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                    if isempty(Lind)==0 & isempty(Rind)==0
                        BBICselectWithCF(m).ThrCFph=yn(Lind)+(yn(Rind)-yn(Lind))*(BBICselectWithCF(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
                        x2=BBICselectWithCF(m).ThrCF;y2=BBICselectWithCF(m).ThrCFph;
                        plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                    end;
                    line(x,yn*1000./x,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;%axis([0 4000 -1.2 1.2]);
    
                    if Low<=BBICselectWithCF(m).sigpX(maxbumpidx)&BBICselectWithCF(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF(m).lineX,BBICselectWithCF(m).lineYr,'k--');
                        %plot(BBICselectWithCF(m).DomF,BBICselectWithCF(m).DomF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).RateBF,BBICselectWithCF(m).RateBF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF(m).ThrCF,BBICselectWithCF(m).ThrCF*BBICselectWithCF(m).CD/1000+BBICselectWithCF(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                        BBICselectWithCF_S(m).bumpfreq=BBICselectWithCF(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        end;
    end;
    f=(1:1:4000);
    plot(f,f.^(-1)*1000,'k');plot(f,f.^(-1)*500,'k');%plot(f,f*0,'g');
    ylim([0 4]);
    xlim([0 (k*100)*(2^(1/3))]);
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)






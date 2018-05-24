SIZE=size(BBICselectWithCF_60db);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=DF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    N=0;
    for m=1:SIZE(2)
        clear Dif;
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF_60db(m).sigpX.*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr;
        Dif=BBICselectWithCF_60db(m).sigpY-LINEY;
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
        
        %if BBICselectWithCF_60db(m).ThrCF>0
            
            if (BBICselectWithCF_60db(m).DomF>=(k-1)*100)&(BBICselectWithCF_60db(m).DomF<k*100)
                    
                x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                if isempty(Lind)==0 & isempty(Rind)==0
                    BBICselectWithCF_60db(m).DomFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                    x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                    plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                end;
                line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;axis([0 2500 -1.2 1.2]);
                
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
                    if BBICselectWithCF_60db(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    Low=BBICselectWithCF_60db(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF_60db(m).DomF*(2^(1/3));
                    
                    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                    %xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                    %Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                    %if isempty(Lind)==0 & isempty(Rind)==0
                        %BBICselectWithCF_60db(m).DomFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                        %x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                        %plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                    %end;
                    %line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;axis([0 2500 -1.2 1.2]);
    
                    if Low<=BBICselectWithCF_60db(m).sigpX(maxbumpidx)&BBICselectWithCF_60db(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF_60db(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF_60db(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        %end;
    end;
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)

%Zoomin
figure
SIZE=size(BBICselectWithCF_60db);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=DF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    N=0;
    for m=1:SIZE(2)
        clear Dif;
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF_60db(m).sigpX.*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr;
        Dif=BBICselectWithCF_60db(m).sigpY-LINEY;
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
        
        %if BBICselectWithCF_60db(m).ThrCF>0
            
            if (BBICselectWithCF_60db(m).DomF>=(k-1)*100)&(BBICselectWithCF_60db(m).DomF<k*100)
                    
                x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                if isempty(Lind)==0 & isempty(Rind)==0
                    BBICselectWithCF_60db(m).DomFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                    x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                    plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                end;
                line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;%axis([0 2500 -1.2 1.2]);
                line([min(x) max(x)],[0 0],'Color','k','LineWidth',2.5);hold on;
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
                    if BBICselectWithCF_60db(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    Low=BBICselectWithCF_60db(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF_60db(m).DomF*(2^(1/3));
                    
                    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                    %xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                    %Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                    %if isempty(Lind)==0 & isempty(Rind)==0
                        %BBICselectWithCF_60db(m).DomFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                        %x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                        %plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                    %end;
                    %line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;axis([0 2500 -1.2 1.2]);
    
                    if Low<=BBICselectWithCF_60db(m).sigpX(maxbumpidx)&BBICselectWithCF_60db(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF_60db(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF_60db(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        plot(x(maxbumpidx),y(maxbumpidx),'c*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        %end;
    end;
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)

%delay-frequency plot
figure
SIZE=size(BBICselectWithCF_60db);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=DF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    N=0;
    for m=1:SIZE(2)
        clear Dif;
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF_60db(m).sigpX.*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr;
        Dif=BBICselectWithCF_60db(m).sigpY-LINEY;
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
        
        %if BBICselectWithCF_60db(m).ThrCF>0
            
            if (BBICselectWithCF_60db(m).DomF>=(k-1)*100)&(BBICselectWithCF_60db(m).DomF<k*100)
                x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                ylast=y(length(y));
                if  ylast<-0.5 | ylast>= 0.5
                    ylastr=ylast-round(ylast);
                    yn=y+(ylastr-ylast);
                else
                    yn=y;
                end;    
                    
                xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                if isempty(Lind)==0 & isempty(Rind)==0
                    BBICselectWithCF_60db(m).DomFph=yn(Lind)+(yn(Rind)-yn(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                    x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                end;
                line(x,yn*1000./x,'Color','b');hold on;%axis([0 4000 -1.2 1.2]);
                
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
                    if BBICselectWithCF_60db(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    Low=BBICselectWithCF_60db(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF_60db(m).DomF*(2^(1/3));
                    
                    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    
                    if Low<=BBICselectWithCF_60db(m).sigpX(maxbumpidx)&BBICselectWithCF_60db(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF_60db(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF_60db(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        %end;
    end;
    f=(1:1:2500);
    plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    ylim([-2.5 2.5]);
    xlim([0 2500]);
    %xlim([0 (k*100)*(2^(1/3))]);
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)

%Zoomin
figure
SIZE=size(BBICselectWithCF_60db);
Nn=0;
for k=1:40
    NN=ceil(k/10)-1;
    axes('Position',[(k-NN*10-1)*(1/10)+0.02 NN*(1/4)+0.02 1/10-0.02 1/4-0.02],'FontSize',8);hold on;
    xlabel([num2str((k-1)*100) '<=DF<' num2str(k*100)],'FontSize',6,'Units','normalized','Position',[0.5,1]);
    N=0;
    for m=1:SIZE(2)
        clear Dif;
        %making a vector of difference between curve and line with CD&CP
        LINEY=BBICselectWithCF_60db(m).sigpX.*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr;
        Dif=BBICselectWithCF_60db(m).sigpY-LINEY;
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
        
        %if BBICselectWithCF_60db(m).ThrCF>0
            
            if (BBICselectWithCF_60db(m).DomF>=(k-1)*100)&(BBICselectWithCF_60db(m).DomF<k*100)
                x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
                
                ylast=y(length(y));
                if  ylast<-0.5 | ylast>= 0.5
                    ylastr=ylast-round(ylast);
                    yn=y+(ylastr-ylast);
                else
                    yn=y;
                end;    
                    
                xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).DomF;
                Lind=min(find(xdif>0));Rind=max(find(xdif<0));
                if isempty(Lind)==0 & isempty(Rind)==0
                    BBICselectWithCF_60db(m).DomFph=yn(Lind)+(yn(Rind)-yn(Lind))*(BBICselectWithCF_60db(m).DomF-x(Lind))/(x(Rind)-x(Lind));%Phase at DomF on real curve
                    x2=BBICselectWithCF_60db(m).DomF;y2=BBICselectWithCF_60db(m).DomFph;
                    plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
                end;
                line(x,yn*1000./x,'Color','b');hold on;%axis([0 4000 -1.2 1.2]);
                
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
                    if BBICselectWithCF_60db(m).CD>=0
                        [p,q]=max(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    else
                        [p,q]=min(bumpM(1,:));maxbumpidx=bumpM(2,q);
                    end;
                    Low=BBICselectWithCF_60db(m).DomF*(2^(-1/3));
                    High=BBICselectWithCF_60db(m).DomF*(2^(1/3));
                    
                    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    
                    if Low<=BBICselectWithCF_60db(m).sigpX(maxbumpidx)&BBICselectWithCF_60db(m).sigpX(maxbumpidx)<=High
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'m*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    elseif BBICselectWithCF_60db(m).sigpX(maxbumpidx)<Low|High<BBICselectWithCF_60db(m).sigpX(maxbumpidx)
                        
                        %plot(BBICselectWithCF_60db(m).lineX,BBICselectWithCF_60db(m).lineYr,'k--');
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'g.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).RateBF,BBICselectWithCF_60db(m).RateBF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'c.','MarkerSize',8);
                        %plot(BBICselectWithCF_60db(m).DomF,BBICselectWithCF_60db(m).DomF*BBICselectWithCF_60db(m).CD/1000+BBICselectWithCF_60db(m).CPr,'r.','MarkerSize',8);
                        
                        %plot(x(maxbumpidx),yn(maxbumpidx)*1000/x(maxbumpidx),'c*','MarkerSize',6);hold on
                        BBICselectWithCF_60db(m).bumpfreq=BBICselectWithCF_60db(m).sigpX(maxbumpidx);
                        N=[N m];
                    end;
                end;
            end;
        %end;
    end;
    f=(1:1:3000);
    plot(f,f.^(-1)*500,'k');plot(f,f.^(-1)*(-500),'k');plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
    %ylim([-2 2]);
    %xlim([0 3000]);
    xlim([max([100 ((k-4)*100)*(2^(-1/3))]) ((k+1)*100)*(2^(1/3))]);
    ylim([max([100 ((k-4)*100)*(2^(-1/3))])^(-1)*(-500) max([100 ((k-4)*100)*(2^(-1/3))])^(-1)*(500)]);
    hold off;
    Nn=[Nn N];display(Nn)
end;
hold off
Number1=length(find(Nn>0));display(Number1)




%%% figure1...all data %%%
%phase-frequency plot
subplot(1,2,1)
for m=1:length(BBICselectWithCF)
    x=BBICselectWithCF(m).sigpX;y=BBICselectWithCF(m).sigpYr;
    line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;
    if BBICselectWithCF(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF(m).ThrCF;
        Lind=1;Rind=length(xdif);
        %Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF(m).ThrCF;y2=BBICselectWithCF(m).ThrCFph;
            plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
        end;
    end;
end;
xlim([0 2500]);%ylim([-1.2 1.2]);
hold off;

%delay-frequency plot
subplot(1,2,2)
for m=1:length(BBICselectWithCF)
    x=BBICselectWithCF(m).sigpX;y=BBICselectWithCF(m).sigpYr;
    line(x,y*1000./x,'Color','b');hold on;%axis([0 4000 -1.2 1.2]);
    
    if BBICselectWithCF(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF(m).ThrCF;
        %Lind=1;Rind=length(xdif);
        Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF(m).ThrCF;y2=BBICselectWithCF(m).ThrCFph;
            plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
        end;
    end;
end;
f=(1:1:2500);
plot(f,f.^(-1)*500,'k','linewidth',3);plot(f,f.^(-1)*(-500),'k','linewidth',3);plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
ylim([-2.5 2.5]);
xlim([0 2500]);



%%% figure2...only 60db %%%
figure
%phase-frequency plot
subplot(1,2,1)
for m=1:length(BBICselectWithCF_60db)
    
    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;
    if BBICselectWithCF_60db(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).ThrCF;
        %Lind=1;Rind=length(xdif);
        Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF_60db(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF_60db(m).ThrCF;y2=BBICselectWithCF_60db(m).ThrCFph;
            plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
        end;
    end;
end;
xlim([0 2500]);%ylim([-1.2 1.2]);
hold off;

%delay-frequency plot
subplot(1,2,2)
for m=1:length(BBICselectWithCF_60db)
    
    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    line(x,y*1000./x,'Color','b');hold on;%axis([0 4000 -1.2 1.2]);
    
    if BBICselectWithCF_60db(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).ThrCF;
        %Lind=1;Rind=length(xdif);
        Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF_60db(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF_60db(m).ThrCF;y2=BBICselectWithCF_60db(m).ThrCFph;
            plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
        end;
    end;
end;
f=(1:1:2500);
plot(f,f.^(-1)*500,'k','linewidth',3);plot(f,f.^(-1)*(-500),'k','linewidth',3);plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
ylim([-2.5 2.5]);
xlim([0 2500]);


%%% figure3...only 60db withCF %%%
figure
%phase-frequency plot
subplot(1,2,1)
for m=1:length(BBICselectWithCF_60db)
    
    if BBICselectWithCF_60db(m).ThrCF>0
    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    line(x,y,'Marker','o','MarkerSize',1,'MarkerEdgeColor','b','Color','b');grid on;hold on;
    %if BBICselectWithCF_60db(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).ThrCF;
        %Lind=1;Rind=length(xdif);
        Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF_60db(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF_60db(m).ThrCF;y2=BBICselectWithCF_60db(m).ThrCFph;
            plot(x2,y2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
            
        end;
    end;
end;
xlim([0 2500]);%ylim([-1.2 1.2]);
hold off;

%delay-frequency plot
subplot(1,2,2)
for m=1:length(BBICselectWithCF_60db)
    
    if BBICselectWithCF_60db(m).ThrCF>0
    x=BBICselectWithCF_60db(m).sigpX;y=BBICselectWithCF_60db(m).sigpYr;
    line(x,y*1000./x,'Color','b');hold on;%axis([0 4000 -1.2 1.2]);
    %if BBICselectWithCF_60db(m).ThrCF>0 %250/334 cells have data of thr.cf...not all!
        xdif=x-ones(1,length(x))*BBICselectWithCF_60db(m).ThrCF;
        %Lind=1;Rind=length(xdif);
        Lind=min(find(xdif>0));Rind=max(find(xdif<0));
        if isempty(Lind)==0 & isempty(Rind)==0
            BBICselectWithCF_60db(m).ThrCFph=y(Lind)+(y(Rind)-y(Lind))*(BBICselectWithCF_60db(m).ThrCF-x(Lind))/(x(Rind)-x(Lind));%Phase at ThrCF on real curve
            x2=BBICselectWithCF_60db(m).ThrCF;y2=BBICselectWithCF_60db(m).ThrCFph;
            plot(x2,y2*1000/x2,'>','MarkerSize',5,'Color','g','MarkerFaceColor','g');hold on;
            
        end;
    end;
end;
f=(1:1:2500);
plot(f,f.^(-1)*500,'k','linewidth',3);plot(f,f.^(-1)*(-500),'k','linewidth',3);plot(f,f.^(-1)*0,'k');%plot(f,f*0,'g');
ylim([-2.5 2.5]);
xlim([0 2500]);



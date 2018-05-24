for n=1:length(BBICselectWithCF)
    plot(BBICselectWithCF(n).sigpX,BBICselectWithCF(n).sigpYr);axis([0 3500 -3 3]);hold on
end;line([0 3500],[0 0],'color',[0 0 0]);

figure
for n=1:length(BBICselectWithCF)
    if isnan(BBICselectWithCF(n).ThrCF)==0
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'ro');axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY);hold on
        clear ShiftedY
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=1:50
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=51:100
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=101:150
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=151:200
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=201:250
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/3 scrsz(4)]);
for n=251:length(BBICselectWithCF)
    if isnan(BBICselectWithCF(n).ThrCF)==0
        f = ceil(100.*rand(100,1));
        plot(BBICselectWithCF(n).ThrCF,BBICselectWithCF(n).BestITD,'*','color',[f(1)/100 f(2)/100 f(3)/100]);axis([0 3500 -3 3]);hold on
        CFY=BBICselectWithCF(n).CPr+BBICselectWithCF(n).CD/1000*BBICselectWithCF(n).ThrCF;
        ShiftedY=ones(1,length(BBICselectWithCF(n).sigpX))*(BBICselectWithCF(n).BestITD-CFY)+BBICselectWithCF(n).sigpYr;
        plot(BBICselectWithCF(n).sigpX,ShiftedY,'color',[f(1)/100 f(2)/100 f(3)/100]);hold on
        clear ShiftedY;clear f;
    end;
end;line([0 3500],[0 0],'color',[0 0 0]);








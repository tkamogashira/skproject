%contra
%subplot(1,2,1)
dia_contra_all=[contra89151_16;...
    contra87039_10;...
    contra88107_15;...
    contra89021_22;...
    contra89141_27;...
    contra87102_7;...
    contra89007_39;...
    contra87039_9;...
    contra87091_27];

%Remove a segment from ML to FB
dia_contra_all=structfilter(dia_contra_all,'$Order$ > 1');

Size=size((0:0.1:5),2);
nsum1=zeros(1,Size);
for k=1:length(dia_contra_all)
    [n1,xout1]=hist(dia_contra_all(k).AvgDiameter,(0:0.1:5));
    %nlength1=n1*(dia_contra_all(k).SectionLength);
    nsum1=nsum1 + n1;
end;
bar(xout1,nsum1,'w');hold on;
 
dia_contra_terminal=structfilter(dia_contra_all,'$BP$ == 0');
Size=size((0:0.1:5),2);
nsum2=zeros(1,Size);
for k=1:length(dia_contra_terminal)
    [n2,xout2]=hist(dia_contra_terminal(k).AvgDiameter,(0:0.1:5));
    %nlength2=n2*(dia_contra_all(k).SectionLength);
    nsum2=nsum2 + n2;
end;
bar(xout2,nsum2,'facecolor',[0.7 0.7 0.7]);hold on;
 
%dia_contra_start=structfilter(dia_contra_all,'$Order$ == 1');
%Size=size((0:0.1:5),2);
%nlengthsum3=zeros(1,Size);
%for k=1:length(dia_contra_start)
    %[n3,xout3]=hist(dia_contra_start(k).AvgDiameter,(0:0.1:5));
    %nlength3=n3*(dia_contra_start(k).SectionLength);
    %nlengthsum3=nlengthsum3 + nlength3;
%end;
%bar(xout3,nlengthsum3,'facecolor','k');

CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);
% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.081 0.1296 0.8381 0.7407]);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);

set(HdlA,'units','centimeters','position',[2 11 7 7],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel('Diameter (\mum)','fontsize',8);xlim([0 4.5]);
ylabel('Number of segments','fontsize',8);%ylim([0 120]);
title('Contralateral segments from FB','fontsize',8);
%Hdls=get(HdlA,'children')

box off;
close(CurFig);

%ipsi
%subplot(1,2,2)
hold off;figure

dia_ipsi_all=[ipsi88311_20;...
    ipsi89021_22;...
    ipsi87056_24;...
    ipsi90043_15;...
    ipsi89007_39;...
    ipsi89007_43;...
    ipsi88011_3];

Size=size((0:0.1:5),2);
nsum4=zeros(1,Size);
for k=1:length(dia_ipsi_all)
    [n4,xout4]=hist(dia_ipsi_all(k).AvgDiameter,(0:0.1:5));
    %nlength4=n4*(dia_ipsi_all(k).SectionLength);
    nsum4=nsum4 + n4;
end;
bar(xout4,nsum4,'w');hold on;
 
dia_ipsi_terminal=structfilter(dia_ipsi_all,'$BP$ == 0');
Size=size((0:0.1:5),2);
nsum5=zeros(1,Size);
for k=1:length(dia_ipsi_terminal)
    [n5,xout5]=hist(dia_ipsi_terminal(k).AvgDiameter,(0:0.1:5));
    %nlength5=n5*(dia_ipsi_all(k).SectionLength);
    nsum5=nsum5 + n5;
end;
bar(xout5,nsum5,'facecolor',[0.7 0.7 0.7]);hold on;
 


CurFig=gcf;
HdlA=getplot(CurFig);%HdlB=getplot(CurFig,1);

HdlA=copyobj(HdlA,FigHdl);%HdlB=copyobj(HdlB,FigHdl);
set(HdlA,'units','centimeters','position',[2 2 7 7],'fontsize',8,'tickdir','out');
axes(HdlA);
xlabel('Diameter (\mum)','fontsize',8);xlim([0 4.5]);
ylabel('Number of segments','fontsize',8);%ylim([0 120]);
title('Ipsilateral segments from FB','fontsize',8);
%Hdls=get(HdlA,'children')
box off;

close(CurFig);



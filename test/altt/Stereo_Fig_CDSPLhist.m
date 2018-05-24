%70db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==70
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_70db',single);
CFcombiselect_70db = [CFcombiselect241, CFcombiselect898, CFcombiselect8121_70db];

lin70=structfilter(CFcombiselect_70db, '$pLinReg$ < 0.005');
ns70=structfilter(CFcombiselect_70db, '$pLinReg$ >= 0.005');
subplot(5,2,1);
hist([lin70(:).CD],(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('70dB');xlabel('CD (ms)');ylabel('Number of pairs');
subplot(5,2,2);
hist([ns70(:).CD]',(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('70dB');xlabel('CD (ms)');ylabel('Number of pairs');


%60db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==60
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_60db',single);
CFcombiselect_60db = CFcombiselect8121_60db;

lin60=structfilter(CFcombiselect_60db, '$pLinReg$ < 0.005');
ns60=structfilter(CFcombiselect_60db, '$pLinReg$ >= 0.005');
subplot(5,2,3);
hist([lin60(:).CD],(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('60dB');xlabel('CD (ms)');ylabel('Number of pairs');
subplot(5,2,4);
hist([ns60(:).CD]',(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('60dB');xlabel('CD (ms)');ylabel('Number of pairs');

%50db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==50
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_50db',single);
CFcombiselect_50db = [CFcombiselect242, CFcombiselect8121_50db];

lin50=structfilter(CFcombiselect_50db, '$pLinReg$ < 0.005');
ns50=structfilter(CFcombiselect_50db, '$pLinReg$ >= 0.005');
subplot(5,2,5);
hist([lin50(:).CD],(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('50dB');xlabel('CD (ms)');ylabel('Number of pairs');
subplot(5,2,6);
hist([ns50(:).CD]',(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('50dB');xlabel('CD (ms)');ylabel('Number of pairs');

%40db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==40
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_40db',single);
CFcombiselect_40db = CFcombiselect8121_40db;

lin40=structfilter(CFcombiselect_40db, '$pLinReg$ < 0.005');
ns40=structfilter(CFcombiselect_40db, '$pLinReg$ >= 0.005');
subplot(5,2,7);
hist([lin40(:).CD],(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('40dB');xlabel('CD (ms)');ylabel('Number of pairs');
subplot(5,2,8);
hist([ns40(:).CD]',(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('40dB');xlabel('CD (ms)');ylabel('Number of pairs');

%30db
single=CFcombiselect8121(1);
for n=1:length(CFcombiselect8121)
    if CFcombiselect8121(n).SPL1(1)==30
        single=[single,CFcombiselect8121(n)];
    end;
end;
single=single(2:length(single));
assignin('base','CFcombiselect8121_30db',single);
CFcombiselect_30db = CFcombiselect8121_30db;

lin30=structfilter(CFcombiselect_30db, '$pLinReg$ < 0.005');
ns30=structfilter(CFcombiselect_30db, '$pLinReg$ >= 0.005');
subplot(5,2,9);
hist([lin30(:).CD],(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('30dB');xlabel('CD (ms)');ylabel('Number of pairs');
subplot(5,2,10);
hist([ns30(:).CD]',(-1.5:0.1:1.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-1.5 1.5]);ylim([0 50]);title('30dB');xlabel('CD (ms)');ylabel('Number of pairs');

%one-way ANOVA for linear data
CDX=[[lin70(:).CD] [lin60(:).CD] [lin50(:).CD] [lin40(:).CD] [lin30(:).CD]];
groupX=[repmat({'70'},1,length([lin70(:).CD])),...
    repmat({'60'},1,length([lin60(:).CD])),...
    repmat({'50'},1,length([lin50(:).CD])),...
    repmat({'40'},1,length([lin40(:).CD])),...
    repmat({'30'},1,length([lin30(:).CD]))];
p = anova1(CDX,groupX)

linearCD=length(CDX)
positivelinearCD=length(find(CDX>0))

nCDX=[[ns70(:).CD] [ns60(:).CD] [ns50(:).CD] [ns40(:).CD] [ns30(:).CD]];
nonlinearCD=length(nCDX)
positivenonlinearCD=length(find(nCDX>0))


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
hist([lin70(:).CPr],(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('70dB');xlabel('CP (cycles)');ylabel('Number of pairs');
subplot(5,2,2);
hist([ns70(:).CPr]',(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('70dB');xlabel('CP (cycles)');ylabel('Number of pairs');


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
hist([lin60(:).CPr],(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('60dB');xlabel('CP (cycles)');ylabel('Number of pairs');
subplot(5,2,4);
hist([ns60(:).CPr]',(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('60dB');xlabel('CP (cycles)');ylabel('Number of pairs');

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
hist([lin50(:).CPr],(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('50dB');xlabel('CP (cycles)');ylabel('Number of pairs');
subplot(5,2,6);
hist([ns50(:).CPr]',(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('50dB');xlabel('CP (cycles)');ylabel('Number of pairs');

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
hist([lin40(:).CPr],(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('40dB');xlabel('CP (cycles)');ylabel('Number of pairs');
subplot(5,2,8);
hist([ns40(:).CPr]',(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('40dB');xlabel('CP (cycles)');ylabel('Number of pairs');

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
hist([lin30(:).CPr],(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('30dB');xlabel('CP (cycles)');ylabel('Number of pairs');
subplot(5,2,10);
hist([ns30(:).CPr]',(-0.5:0.1:0.5));
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlim([-0.5 0.5]);ylim([0 70]);title('30dB');xlabel('CP (cycles)');ylabel('Number of pairs');

%one-way ANOVA for linear data
CPX=[[lin70(:).CPr] [lin60(:).CPr] [lin50(:).CPr] [lin40(:).CPr] [lin30(:).CPr]];
groupX=[repmat({'70'},1,length([lin70(:).CPr])),...
    repmat({'60'},1,length([lin60(:).CPr])),...
    repmat({'50'},1,length([lin50(:).CPr])),...
    repmat({'40'},1,length([lin40(:).CPr])),...
    repmat({'30'},1,length([lin30(:).CPr]))];
[p,table,stats] = anova1(CPX,groupX)

c = multcompare(stats)


subplot(1,2,1)

for n=1:length(contra_data)
    semilogx(contra_data(n).cf,contra_data(n).al_from_ml,'bo');hold on;
end;

xlabel('CF');
ylabel(['Axonal length from ML']);
hold off;%ylim([0 1.1]);

subplot(1,2,2)

Mean=mean([contra_data(1:6).al_from_ml]);
Std=std([contra_data(1:6).al_from_ml]);
semilogx(contra_data(1).cf,Mean,'bo');hold on;
line([contra_data(1).cf contra_data(1).cf],[Mean-Std Mean+Std],'color','b');hold on;
%line([contra_data(1).cf contra_data(1).cf],[min([contra_data(1:6).al_from_ml]) max([contra_data(1:6).al_from_ml])],'color','b');hold on;
%text('position',[contra_data(1).cf,mean([contra_data(1:6).al_from_ml])],'string',num2str(contra_data(1).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(7:82).al_from_ml]);%same animal
Std=std([contra_data(7:82).al_from_ml]);
semilogx(contra_data(7).cf,Mean,'ro');hold on;
line([contra_data(7).cf contra_data(7).cf],[Mean-Std Mean+Std],'color','r');hold on;
%text('position',[contra_data(7).cf,mean([contra_data(7:82).al_from_ml])],'string',num2str(contra_data(7).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(83:110).al_from_ml]);
Std=std([contra_data(83:110).al_from_ml]);
semilogx(contra_data(83).cf,Mean,'bo');hold on;
line([contra_data(83).cf contra_data(83).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(83).cf,mean([contra_data(83:110).al_from_ml])],'string',num2str(contra_data(83).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(111:116).al_from_ml]);
Std=std([contra_data(111:116).al_from_ml]);
semilogx(contra_data(111).cf,Mean,'bo');hold on;
line([contra_data(111).cf contra_data(111).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(111).cf,mean([contra_data(111:116).al_from_ml])],'string',num2str(contra_data(111).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(117:140).al_from_ml]);%same animal
Std=std([contra_data(117:140).al_from_ml]);
semilogx(contra_data(117).cf,Mean,'ro');hold on;
line([contra_data(117).cf contra_data(117).cf],[Mean-Std Mean+Std],'color','r');hold on;
%text('position',[contra_data(117).cf,mean([contra_data(117:140).al_from_ml])],'string',num2str(contra_data(117).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(141:161).al_from_ml]);
Std=std([contra_data(141:161).al_from_ml]);
semilogx(contra_data(141).cf,Mean,'bo');hold on;
line([contra_data(141).cf contra_data(141).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(141).cf,mean([contra_data(141:161).al_from_ml])],'string',num2str(contra_data(141).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(162:175).al_from_ml]);
Std=std([contra_data(162:175).al_from_ml]);
semilogx(contra_data(162).cf,Mean,'bo');hold on;
line([contra_data(162).cf contra_data(162).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(162).cf,mean([contra_data(162:175).al_from_ml])],'string',num2str(contra_data(162).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(176:184).al_from_ml]);
Std=std([contra_data(176:184).al_from_ml]);
semilogx(contra_data(176).cf,Mean,'bo');hold on;
line([contra_data(176).cf contra_data(176).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(176).cf,mean([contra_data(176:184).al_from_ml])],'string',num2str(contra_data(176).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

Mean=mean([contra_data(185:279).al_from_ml]);
Std=std([contra_data(185:279).al_from_ml]);
semilogx(contra_data(185).cf,Mean,'bo');hold on;
line([contra_data(185).cf contra_data(185).cf],[Mean-Std Mean+Std],'color','b');hold on;
%text('position',[contra_data(185).cf,mean([contra_data(185:279).al_from_ml])],'string',num2str(contra_data(185).cf),'color','b','fontsize',10);hold on;
clear Mean;clear Std;

xlabel('CF');
ylabel(['Axonal length from ML']);
hold off;%ylim([0 1.1]);






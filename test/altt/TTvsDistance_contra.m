for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
end;


contra8902122_cf1498Hz=contra_data(1:6);
contra8703910_cf1345Hz=contra_data(7:82);
contra871027_cf2397Hz=contra_data(83:110);
contra8900739_cf2470Hz=contra_data(111:116);
contra870399_cf7184Hz=contra_data(117:140);
contra8914127_cf2018Hz=contra_data(141:161);
contra8810715_cf1345Hz=contra_data(162:175);
contra8709127_cf10508Hz=contra_data(176:184);
contra8915116_cf840Hz=contra_data(185:279);


structplot(contra8915116_cf840Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8703910_cf1345Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8810715_cf1345Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8902122_cf1498Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8914127_cf2018Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra871027_cf2397Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8900739_cf2470Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra870399_cf7184Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);
structplot(contra8709127_cf10508Hz,'distance','ctsum','fit','linear','xlim',[0 8000],'ylim',[0 0.5]);


structplot(contra8915116_cf840Hz,'distance','ctsum',...
    contra8703910_cf1345Hz,'distance','ctsum',...
    contra8810715_cf1345Hz,'distance','ctsum',...
    contra8902122_cf1498Hz,'distance','ctsum',...
    contra8914127_cf2018Hz,'distance','ctsum',...
    contra871027_cf2397Hz,'distance','ctsum',...
    contra8900739_cf2470Hz,'distance','ctsum',...
    contra870399_cf7184Hz,'distance','ctsum',...
    contra8709127_cf10508Hz,'distance','ctsum',...
    'info','no','fit','linear','xlim',[0 8000],'ylim',[0 0.45],...
    'markers',{'^f','vw'},...
    'colors',{'k','b', 'b', 'c', 'c', 'g', 'g', 'r','r'});hold on;
hold off;











for n=1:length(contra_data)
    contra_data(n).averagespeedfromML=contra_data(n).al_from_ml/contra_data(n).ctsum*0.001;
    firsttime=contra_data(n).ctall(1);
    contra_data(n).averagespeedfromFB=contra_data(n).al_from_fb/(contra_data(n).ctsum-firsttime)*0.001;
    clear firsttime;
end;

for n=1:length(ipsi_data)
    
    ipsi_data(n).averagespeedfromFB=ipsi_data(n).al_from_fb/(ipsi_data(n).ctsum)*0.001;
    
end;

structplot(contra_data,'cf','averagespeedfromML')

figure
structplot(contra_data,'cf','averagespeedfromFB')

figure
structplot(ipsi_data,'cf','averagespeedfromFB')
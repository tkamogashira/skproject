
%contra
for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
end;

contra_data_89021_22=contra_data(1:6);
contra_data_87039_10=contra_data(7:82);
contra_data_87102_7=contra_data(83:110);
contra_data_89007_39=contra_data(111:116);
contra_data_87039_9=contra_data(117:140);
contra_data_89141_27=contra_data(141:161);
contra_data_88107_15=contra_data(162:175);
contra_data_87091_27=contra_data(176:184);
contra_data_89151_16=contra_data(185:279);

structplot(contra_data_89021_22,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87039_10,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87102_7,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89007_39,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87039_9,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89141_27,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_88107_15,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87091_27,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89151_16,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    'xlim',[0 1],'ylim',[0 1]);hold on;
hold off;

%contra for figure
structplot(contra_data_89021_22,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87039_10,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87102_7,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89007_39,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87039_9,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89141_27,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_88107_15,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_87091_27,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    contra_data_89151_16,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    'xlim',[0 1],'ylim',[0 1],...
    'info','no','markers',{'^w','vf','^w','vf','^w','vf','^w','vf'},...
    'colors',{'k', 'k', 'r', 'r', 'b', 'b', 'g', 'g', 'c'});

%ipsi
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
end;

ipsi_data_89021_22=ipsi_data(1:22);
ipsi_data_89007_39=ipsi_data(23:33);
ipsi_data_89007_43=ipsi_data(34:40);
ipsi_data_90043_15=ipsi_data(41:70);
ipsi_data_87056_24=ipsi_data(71:81);
ipsi_data_88311_20=ipsi_data(82:117);
ipsi_data_88011_3=ipsi_data(118:121);

structplot(ipsi_data_89021_22,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_89007_39,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_89007_43,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_90043_15,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_87056_24,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_88311_20,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_88011_3,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    'xlim',[0 1],'ylim',[0 1]);hold on;
hold off;

%ipsi for figure
structplot(ipsi_data_89021_22,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_89007_39,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_89007_43,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_90043_15,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_87056_24,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_88311_20,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    ipsi_data_88011_3,'MLindex','ep_minus_vp_on_dp_minus_vp',...
    'xlim',[0 1],'ylim',[0 1],...
    'info','no','markers',{'^w','vf','^w','vf','^w','vf'},...
    'colors',{'k', 'k', 'r', 'r', 'b', 'g', 'g'});

%ipsi forward and backward
figure
for n=1:length(ipsi_data_89021_22)
    if strcmp(ipsi_data_89021_22(n).group(1),'f')==1
        plot(ipsi_data_89021_22(n).MLindex,ipsi_data_89021_22(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
    else
        plot(ipsi_data_89021_22(n).MLindex,ipsi_data_89021_22(n).ep_minus_vp_on_dp_minus_vp,'ro');hold on;
    end;
end;
        
for n=1:length(ipsi_data_89007_39)
    if strcmp(ipsi_data_89007_39(n).group(1),'f')==1
        plot(ipsi_data_89007_39(n).MLindex,ipsi_data_89007_39(n).ep_minus_vp_on_dp_minus_vp,'b^');hold on;
    else
        plot(ipsi_data_89007_39(n).MLindex,ipsi_data_89007_39(n).ep_minus_vp_on_dp_minus_vp,'r^');hold on;
    end;
end;
    
for n=1:length(ipsi_data_89007_43)
    if strcmp(ipsi_data_89007_43(n).group(1),'f')==1
        plot(ipsi_data_89007_43(n).MLindex,ipsi_data_89007_43(n).ep_minus_vp_on_dp_minus_vp,'bv');hold on;
    else
        plot(ipsi_data_89007_43(n).MLindex,ipsi_data_89007_43(n).ep_minus_vp_on_dp_minus_vp,'rv');hold on;
    end;
end;    
    
for n=1:length(ipsi_data_90043_15)
    if strcmp(ipsi_data_90043_15(n).group(1),'f')==1
        plot(ipsi_data_90043_15(n).MLindex,ipsi_data_90043_15(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    else
        plot(ipsi_data_90043_15(n).MLindex,ipsi_data_90043_15(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end;    
    
for n=1:length(ipsi_data_87056_24)
    if strcmp(ipsi_data_87056_24(n).group(1),'f')==1
        plot(ipsi_data_87056_24(n).MLindex,ipsi_data_87056_24(n).ep_minus_vp_on_dp_minus_vp,'b+');hold on;
    else
        plot(ipsi_data_87056_24(n).MLindex,ipsi_data_87056_24(n).ep_minus_vp_on_dp_minus_vp,'r+');hold on;
    end;
end;     
    
for n=1:length(ipsi_data_88311_20)
    if strcmp(ipsi_data_88311_20(n).group(1),'f')==1
        plot(ipsi_data_88311_20(n).MLindex,ipsi_data_88311_20(n).ep_minus_vp_on_dp_minus_vp,'bx');hold on;
    else
        plot(ipsi_data_88311_20(n).MLindex,ipsi_data_88311_20(n).ep_minus_vp_on_dp_minus_vp,'rx');hold on;
    end;
end;     

for n=1:length(ipsi_data_88011_3)
    if strcmp(ipsi_data_88011_3(n).group(1),'f')==1
        plot(ipsi_data_88011_3(n).MLindex,ipsi_data_88011_3(n).ep_minus_vp_on_dp_minus_vp,'b<');hold on;
    else
        plot(ipsi_data_88011_3(n).MLindex,ipsi_data_89007_43(n).ep_minus_vp_on_dp_minus_vp,'r<');hold on;
    end;
end; 
axis([0 1 0 1]);
xlabel([{'medial \leftarrow       \rightarrow lateral'},...
    {' '},...
    {'\color{blue}forward innervation'},...
    {'\color{red}backward innervation'}]);
ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;



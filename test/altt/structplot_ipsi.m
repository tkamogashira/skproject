
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
end;

%normalize axonal length using RPtoCP
for n=1:22
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4199.75;
end;
for n=23:33
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4108.17;
end;
for n=34:40
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4169.28;
end;
for n=41:70
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4279.84;
end;
for n=71:81
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/3136.7;
end;
for n=82:117
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4001.14;
end;
for n=118:121
    ipsi_data(n).normALfromFB=ipsi_data(n).al_from_fb/4771.82;
end;

ipsi_data_89021_22=ipsi_data(1:22);
ipsi_data_89007_39=ipsi_data(23:33);
ipsi_data_89007_43=ipsi_data(34:40);
ipsi_data_90043_15=ipsi_data(41:70);
ipsi_data_87056_24=ipsi_data(71:81);
ipsi_data_88311_20=ipsi_data(82:117);
ipsi_data_88011_3=ipsi_data(118:121);

structplot(ipsi_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_89007_43,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_90043_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_87056_24,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_88311_20,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
structplot(ipsi_data_88011_3,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);

structplot(ipsi_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_89007_43,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_90043_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_87056_24,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_88311_20,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    ipsi_data_88011_3,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    'fit','linear','xlim',[0 1],'ylim',[0 11000]);

%normalize axonal length using RPtoCP
structplot(ipsi_data_89021_22,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_39,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_43,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_90043_15,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_87056_24,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88311_20,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88011_3,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'fit','linear','xlim',[0 1]);

%normalize axonal length using RPtoCP for figure
structplot(ipsi_data_89021_22,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_39,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_43,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_90043_15,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_87056_24,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88311_20,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88011_3,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'info','no','fit','linear','xlim',[0 1],'ylim',[0 2.5],...
    'markers',{'^w','vf','^w','vf','^w','vf'},...
    'colors',{'k', 'k', 'r', 'r', 'b', 'g', 'g'});hold on;

line([0 1],[0 1],'color','k');

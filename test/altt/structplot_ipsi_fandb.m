
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

for n=1:length(ipsi_data)
    ipsi_data(n).fb=ipsi_data(n).group(1);
end;



ipsi_data_89021_22=ipsi_data(1:22);
ipsi_data_89021_22_f=structfilter(ipsi_data_89021_22,'strcmp($fb$,''f'')');
ipsi_data_89021_22_b=structfilter(ipsi_data_89021_22,'strcmp($fb$,''b'')');

ipsi_data_89007_39=ipsi_data(23:33);
ipsi_data_89007_39_f=structfilter(ipsi_data_89007_39,'strcmp($fb$,''f'')');
ipsi_data_89007_39_b=structfilter(ipsi_data_89007_39,'strcmp($fb$,''b'')');

ipsi_data_89007_43=ipsi_data(34:40);
ipsi_data_89007_43_f=structfilter(ipsi_data_89007_43,'strcmp($fb$,''f'')');
ipsi_data_89007_43_b=structfilter(ipsi_data_89007_43,'strcmp($fb$,''b'')');

ipsi_data_90043_15=ipsi_data(41:70);
ipsi_data_90043_15_f=structfilter(ipsi_data_90043_15,'strcmp($fb$,''f'')');
ipsi_data_90043_15_b=structfilter(ipsi_data_90043_15,'strcmp($fb$,''b'')');

ipsi_data_87056_24=ipsi_data(71:81);
ipsi_data_87056_24_f=structfilter(ipsi_data_87056_24,'strcmp($fb$,''f'')');
ipsi_data_87056_24_b=structfilter(ipsi_data_87056_24,'strcmp($fb$,''b'')');

ipsi_data_88311_20=ipsi_data(82:117);
ipsi_data_88311_20_f=structfilter(ipsi_data_88311_20,'strcmp($fb$,''f'')');
ipsi_data_88311_20_b=structfilter(ipsi_data_88311_20,'strcmp($fb$,''b'')');

ipsi_data_88011_3=ipsi_data(118:121);
ipsi_data_88011_3_f=structfilter(ipsi_data_88011_3,'strcmp($fb$,''f'')');
ipsi_data_88011_3_b=structfilter(ipsi_data_88011_3,'strcmp($fb$,''b'')');

%forward
if length(ipsi_data_89021_22_f)>0
structplot(ipsi_data_89021_22_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_89007_39_f)>0%empty
structplot(ipsi_data_89007_39_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_89007_43_f)>0
structplot(ipsi_data_89007_43_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_90043_15_f)>0
structplot(ipsi_data_90043_15_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_87056_24_f)>0%empty
structplot(ipsi_data_87056_24_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_88311_20_f)>0
structplot(ipsi_data_88311_20_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_88011_3_f)>0%empty
structplot(ipsi_data_88011_3_f,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;


%normalize axonal length using RPtoCP   forward
structplot(ipsi_data_89021_22_f,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_43_f,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_90043_15_f,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88311_20_f,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'colors',{'b','r','c','y'},'markers',{'o','v','*','x'},'fit','linear','xlim',[0 1]);

%backward
if length(ipsi_data_89021_22_b)>0
structplot(ipsi_data_89021_22_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_89007_39_b)>0%empty
structplot(ipsi_data_89007_39_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_89007_43_b)>0
structplot(ipsi_data_89007_43_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_90043_15_b)>0
structplot(ipsi_data_90043_15_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_87056_24_b)>0%empty
structplot(ipsi_data_87056_24_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_88311_20_b)>0
structplot(ipsi_data_88311_20_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;
if length(ipsi_data_88011_3_b)>0%empty
structplot(ipsi_data_88011_3_b,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 11000]);
end;


%normalize axonal length using RPtoCP   backward
structplot(ipsi_data_89021_22_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_39_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_89007_43_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_90043_15_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_87056_24_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88311_20_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    ipsi_data_88011_3_b,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'fit','linear','xlim',[0 1]);



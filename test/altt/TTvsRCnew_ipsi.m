
for n=1:length(ipsi_data)
    ipsi_data(n).ds1.filename = [ipsi_data(n).id ' ' ipsi_data(n).side];
    ipsi_data(n).ds1.icell = n;%[ipsi_data(n).id ' ' ipsi_data(n).side];
end;

ipsi8902122_cf1498Hz=ipsi_data(1:22);
ipsi8900739_cf2470Hz=ipsi_data(23:33);
ipsi8900743_cf2694Hz=ipsi_data(34:40);
ipsi9004315_cf2300Hz=ipsi_data(41:70);
ipsi8705624_cf1903Hz=ipsi_data(71:81);
ipsi8831120_cf200Hz=ipsi_data(82:117);
ipsi880113_cf5388Hz=ipsi_data(118:121);

[Info, Slope] = structplotdata(ipsi8831120_cf200Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi8902122_cf1498Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi8705624_cf1903Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi9004315_cf2300Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi8900739_cf2470Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi8900743_cf2694Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);
[Info, Slope] = structplotdata(ipsi880113_cf5388Hz,'ep_minus_rp','ctsum','fit','linear','xlim',[0 4000],'ylim',[0 0.5]);


structplot(ipsi8831120_cf200Hz,'ep_minus_rp','ctsum',...
    ipsi8902122_cf1498Hz,'ep_minus_rp','ctsum',...
    ipsi8705624_cf1903Hz,'ep_minus_rp','ctsum',...
    ipsi9004315_cf2300Hz,'ep_minus_rp','ctsum',...
    ipsi8900739_cf2470Hz,'ep_minus_rp','ctsum',...
    ipsi8900743_cf2694Hz,'ep_minus_rp','ctsum',...
    ipsi880113_cf5388Hz,'ep_minus_rp','ctsum',...
    'info','no','fit','linear','xlim',[0 4000],'ylim',[0 0.5],...
    'markers',{'^f','vw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;
hold off;




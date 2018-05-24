
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

[Info, Slope] = structplotdata(ipsi8902122_cf1498Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(1:22),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(1:22),'z'));
ri=mostrostrali;
ci=mostcaudali;
for n=1:22
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi8900739_cf2470Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(23:33),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(23:33),'z'));
ri=mostrostrali+22;
ci=mostcaudali+22;
for n=23:33
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi8900743_cf2694Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(34:40),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(34:40),'z'));
ri=mostrostrali+33;
ci=mostcaudali+33;
for n=34:40
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi9004315_cf2300Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(41:70),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(41:70),'z'));
ri=mostrostrali+40;
ci=mostcaudali+40;
for n=41:70
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi8705624_cf1903Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(71:81),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(71:81),'z'));
ri=mostrostrali+70;
ci=mostcaudali+70;
for n=71:81
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi8831120_cf200Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(82:117),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(82:117),'z'));
ri=mostrostrali+81;
ci=mostcaudali+81;
for n=82:117
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;

[Info, Slope] = structplotdata(ipsi880113_cf5388Hz,'ctsum','al_from_fb','fit','linear','xlim',[0 0.5],'ylim',[0 11000]);
[mostrostralz,mostrostrali]=min(structfield(ipsi_data(118:121),'z'));
[mostcaudalz,mostcaudali]=max(structfield(ipsi_data(118:121),'z'));
ri=mostrostrali+117;
ci=mostcaudali+117;
for n=118:121
    ipsi_data(n).slopempers=Slope*10^(-3);ipsi_data(n).pCorr=Info.pCorr;
    ipsi_data(n).inneRClength=((ipsi_data(ri).x-ipsi_data(ci).x)^2+(ipsi_data(ri).y-ipsi_data(ci).y)^2+(ipsi_data(ri).z-ipsi_data(ci).z)^2)^0.5;
    ipsi_data(n).inneRCwidth=abs(mostrostralz-mostcaudalz);
end;


structplot(ipsi8831120_cf200Hz,'ctsum','al_from_fb',...
    ipsi8902122_cf1498Hz,'ctsum','al_from_fb',...
    ipsi8705624_cf1903Hz,'ctsum','al_from_fb',...
    ipsi9004315_cf2300Hz,'ctsum','al_from_fb',...
    ipsi8900739_cf2470Hz,'ctsum','al_from_fb',...
    ipsi8900743_cf2694Hz,'ctsum','al_from_fb',...
    ipsi880113_cf5388Hz,'ctsum','al_from_fb',...
    'info','no','fit','linear','xlim',[0 0.5],'ylim',[0 11000],...
    'markers',{'^f','vw'},...
    'colors',{'b', 'c', 'c', 'g', 'g','r','r'});hold on;
hold off;




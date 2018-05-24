for n=1:length(contra_data)
    contra_data(n).ds1.filename = [contra_data(n).id ' ' contra_data(n).side];
    contra_data(n).ds1.icell = n;%[contra_data(n).id ' ' contra_data(n).side];
end;

%normalize axonal length using RPtoCP
for n=1:6
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4225.27;
end;
for n=7:82
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3055.33;
end;
for n=83:110
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4101.46;
end;
for n=111:116
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4169.28;
end;
for n=117:140
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3055.33;
end;
for n=141:161
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3869.3;
end;
for n=162:175
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3936.53;
end;
for n=176:184
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/3137.97;
end;
for n=185:279
    contra_data(n).normALfromFB=contra_data(n).al_from_fb/4295.17;
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

structplot(contra_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_87039_10,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_87102_7,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_87039_9,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_89141_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_88107_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_87091_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);
structplot(contra_data_89151_16,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear','xlim',[0 1],'ylim',[0 5000]);

structplot(contra_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87039_10,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87102_7,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87039_9,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89141_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_88107_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87091_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89151_16,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    'fit','linear','xlim',[0 1],'ylim',[0 5000]);


%normalize axonal length using RPtoCP
structplot(contra_data_89021_22,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_87039_10,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_87102_7,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_89007_39,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_87039_9,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_89141_27,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_88107_15,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_87091_27,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    contra_data_89151_16,'ep_minus_rp_on_cp_minus_rp','normALfromFB',...
    'info','no','fit','linear','xlim',[0 1],'ylim',[0 1.5],...
    'markers',{'^w','vf','^w','vf','^w','vf','^w','vf'},...
    'colors',{'k', 'k', 'r', 'r', 'b', 'b', 'g', 'g', 'c'});hold on;

line([0 1],[0 1],'color','k');








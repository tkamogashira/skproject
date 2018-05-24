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

structplot(contra_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_87039_10,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_87102_7,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_87039_9,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_89141_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_88107_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_87091_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
structplot(contra_data_89151_16,'ep_minus_rp_on_cp_minus_rp','al_from_fb','fit','linear');axis([0 1 0 5000]);hold on;
hold off;
structplot(contra_data_89021_22,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87039_10,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87102_7,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89007_39,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87039_9,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89141_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_88107_15,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_87091_27,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    contra_data_89151_16,'ep_minus_rp_on_cp_minus_rp','al_from_fb',...
    'fit','linear');axis([0 1 0 5000]);

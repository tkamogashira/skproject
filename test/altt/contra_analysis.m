%figure1
first=1;last=6;
subplot(1,2,1)
for n=first:last
    if contra_data(n).z <= contra_data(n).fb_z %CR
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'d','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','r','fontsize',10);hold on;
        end;
    elseif contra_data(n).z > contra_data(n).fb_z %RC
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'d','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','b','fontsize',10);hold on;
        end;
    end;
end;
xlabel('rostral \leftarrow  (EP-RP)/(CP-RP)  \rightarrow caudal');xlim([0 1]);
ylabel('axonal length from FB');
title([contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
plot(0.2,350,'r.');text(0.2,350,': from caudal FB to rostral endpoint (CR)','color','r');
plot(0.2,300,'b.');text(0.2,300,': from rostral FB to caudal endpoint (RC)','color','b');
plot(0.2,150,'ko');text(0.2,150,': g1','color','k');
plot(0.2,100,'kx');text(0.2,100,': g2','color','k');
plot(0.2,50,'kd');text(0.2,50,': g3','color','k');
hold off;

subplot(1,2,2)
for n=first:last
    if contra_data(n).y <= contra_data(n).fb_y %DV
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'d','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','c','fontsize',10);hold on;
        end;
    elseif contra_data(n).y > contra_data(n).fb_y %VD
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'d','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','m','fontsize',10);hold on;
        end;
    end;
end;
xlabel('ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal');xlim([0 1]);
ylabel('axonal length from FB');
title([contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
plot(0.2,350,'m.');text(0.2,350,': from ventral FB to dorsal endpoint (VD)','color','m');
plot(0.2,300,'c.');text(0.2,300,': from dorsal FB to ventral endpoint (DV)','color','c');
plot(0.2,150,'ko');text(0.2,150,': g1','color','k');
plot(0.2,100,'kx');text(0.2,100,': g2','color','k');
plot(0.2,50,'kd');text(0.2,50,': g3','color','k');
hold off;

%figure2
figure
first=7;last=82;
subplot(1,2,1)
for n=first:last
    if contra_data(n).z <= contra_data(n).fb_z %CR
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2&3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'d','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','r','fontsize',10);hold on;
        end;
    elseif contra_data(n).z > contra_data(n).fb_z %RC
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2&3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'d','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','b','fontsize',10);hold on;
        end;
    end;
end;
xlabel('rostral \leftarrow  (EP-RP)/(CP-RP)  \rightarrow caudal');xlim([0 1]);
ylabel('axonal length from FB');
title([contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
plot(0.2,350,'r.');text(0.2,350,': from caudal FB to rostral endpoint (CR)','color','r');
plot(0.2,300,'b.');text(0.2,300,': from rostral FB to caudal endpoint (RC)','color','b');
plot(0.2,150,'ko');text(0.2,150,': g1','color','k');
plot(0.2,100,'kx');text(0.2,100,': g2&3','color','k');
plot(0.2,50,'kd');text(0.2,50,': g4','color','k');
hold off;

subplot(1,2,2)
for n=first:last
    if contra_data(n).y <= contra_data(n).fb_y %DV
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2&3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'d','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','c','fontsize',10);hold on;
        end;
    elseif contra_data(n).y > contra_data(n).fb_y %VD
        if strcmp(contra_data(n).group,'g1')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g2&3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'d','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','m','fontsize',10);hold on;
        end;
    end;
end;
xlabel('ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal');xlim([0 1]);
ylabel('axonal length from FB');
title([contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
plot(0.2,350,'m.');text(0.2,350,': from ventral FB to dorsal endpoint (VD)','color','m');
plot(0.2,300,'c.');text(0.2,300,': from dorsal FB to ventral endpoint (DV)','color','c');
plot(0.2,150,'ko');text(0.2,150,': g1','color','k');
plot(0.2,100,'kx');text(0.2,100,': g2&3','color','k');
plot(0.2,50,'kd');text(0.2,50,': g4','color','k');
hold off;



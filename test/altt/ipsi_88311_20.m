
first=82;last=117;
subplot(1,2,1)
for n=first:last
    if ipsi_data(n).z <= ipsi_data(n).fb_z %CR
        if strcmp(ipsi_data(n).group,'b_g1')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'o','color','r','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'b_g2')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'x','color','r','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g3')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'^','color','r','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g4')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'*','color','r','markersize',10);hold on;
        %elseif strcmp(ipsi_data(n).group,'g5')==1
            %plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'v','color','r','markersize',10);hold on;
        end;
    elseif ipsi_data(n).z > ipsi_data(n).fb_z %RC
        if strcmp(ipsi_data(n).group,'b_g1')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'o','color','b','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'b_g2')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'x','color','b','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g3')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'^','color','b','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g4')==1
            plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'*','color','b','markersize',10);hold on;
        %elseif strcmp(ipsi_data(n).group,'g5')==1
            %plot(ipsi_data(n).ep_minus_rp_on_cp_minus_rp,ipsi_data(n).al_from_fb,'v','color','b','markersize',10);hold on;
        end;
    end;
end;
xlabel([{'rostral \leftarrow  (EP-RP)/(CP-RP)  \rightarrow caudal'},...
    {' '},...
    {'o: b_g1'},{'x: b_g2'},{'\Delta: f_g3'},{'*: f_g4'},...%{'\nabla: g5'},...
    {'\color{red}from caudal FB to rostral endpoint (CR)'},...
    {'\color{blue}from rostral FB to caudal endpoint (RC)'}]);
ylabel('axonal length from FB');
title([ipsi_data(first).side ipsi_data(first).id ' (CF=' num2str(ipsi_data(first).cf) 'Hz)']);%%%%%attention!
xlim([0 1]);
hold off;

subplot(1,2,2)
for n=first:last
    if ipsi_data(n).y <= ipsi_data(n).fb_y %DV
        if strcmp(ipsi_data(n).group,'b_g1')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'o','color','c','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'b_g2')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'x','color','c','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g3')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'^','color','c','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g4')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'*','color','c','markersize',10);hold on;
        %elseif strcmp(ipsi_data(n).group,'g5')==1
            %plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'v','color','c','markersize',10);hold on;
        end;
    elseif ipsi_data(n).y > ipsi_data(n).fb_y %VD
        if strcmp(ipsi_data(n).group,'b_g1')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'o','color','m','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'b_g2')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'x','color','m','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g3')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'^','color','m','markersize',10);hold on;
        elseif strcmp(ipsi_data(n).group,'f_g4')==1
            plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'*','color','m','markersize',10);hold on;
        %elseif strcmp(ipsi_data(n).group,'g5')==1
            %plot(ipsi_data(n).ep_minus_vp_on_dp_minus_vp,ipsi_data(n).al_from_fb,'v','color','m','markersize',10);hold on;
        end;
    end;
end;
xlabel([{'ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal'},...
    {' '},...
    {'o: b_g1'},{'x: b_g2'},{'\Delta: f_g3'},{'*: f_g4'},...%{'\nabla: g5'},...
    {'\color{magenta}from ventral FB to dorsal endpoint (VD)'},...
    {'\color{lightblue}from dorsal FB to ventral endpoint (DV)'}]);
ylabel('axonal length from FB');
title([ipsi_data(first).side ipsi_data(first).id ' (CF=' num2str(ipsi_data(first).cf) 'Hz)']);%%%%%attention!
xlim([0 1]);
hold off;






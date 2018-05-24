
first=117;last=140;
subplot(1,2,1)
for n=first:last
    if contra_data(n).z <= contra_data(n).fb_z %CR
        if strcmp(contra_data(n).group,'g1&2')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'^','color','r','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','r','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g5')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'*','color','r','markersize',10);hold on;
        end;
    elseif contra_data(n).z > contra_data(n).fb_z %RC
        if strcmp(contra_data(n).group,'g1&2')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'o','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'1','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'x','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'2','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'^','color','b','markersize',10);hold on;
            %text(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'3','color','b','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g5')==1
            plot(contra_data(n).ep_minus_rp_on_cp_minus_rp,contra_data(n).al_from_fb,'*','color','b','markersize',10);hold on;
        end;
    end;
end;
xlabel([{'rostral \leftarrow  (EP-RP)/(CP-RP)  \rightarrow caudal'},...
    {' '},...
    {'o: g1&2'},{'x: g3'},{'\Delta: g4'},{'*: g5'},...
    {'\color{red}from caudal FB to rostral endpoint (CR)'},...
    {'\color{blue}from rostral FB to caudal endpoint (RC)'}]);
ylabel('axonal length from FB');
title([contra_data(first).side contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
xlim([0 1]);
hold off;

subplot(1,2,2)
for n=first:last
    if contra_data(n).y <= contra_data(n).fb_y %DV
        if strcmp(contra_data(n).group,'g1&2')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'^','color','c','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','c','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g5')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'*','color','c','markersize',10);hold on;
        end;
    elseif contra_data(n).y > contra_data(n).fb_y %VD
        if strcmp(contra_data(n).group,'g1&2')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'o','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'1','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g3')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'x','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'2','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g4')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'^','color','m','markersize',10);hold on;
            %text(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'3','color','m','fontsize',10);hold on;
        elseif strcmp(contra_data(n).group,'g5')==1
            plot(contra_data(n).ep_minus_vp_on_dp_minus_vp,contra_data(n).al_from_fb,'*','color','m','markersize',10);hold on;
        end;
    end;
end;
xlabel([{'ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal'},...
    {' '},...
    {'o: g1&2'},{'x: g3'},{'\Delta: g4'},{'*: g5'},...
    {'\color{magenta}from ventral FB to dorsal endpoint (VD)'},...
    {'\color{lightblue}from dorsal FB to ventral endpoint (DV)'}]);
ylabel('axonal length from FB');
title([contra_data(first).side contra_data(first).id ' (CF=' num2str(contra_data(first).cf) 'Hz)']);%%%%%attention!
xlim([0 1]);
hold off;






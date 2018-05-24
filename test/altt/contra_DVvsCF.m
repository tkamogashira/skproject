for n=1:length(contra_data)
    plot(contra_data(n).cf,contra_data(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
end;
xlabel('CF (Hz)');
ylabel('ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal');
title('contra 9 fibers');

figure
for n=1:length(contra_data)
    plot(contra_data(n).cf,contra_data(n).al_from_fb,'bo');hold on;
end;
xlabel('CF (Hz)');
ylabel('Axonal length from FB');
title('contra 9 fibers');

figure
for n=1:length(contra_data)
    plot(contra_data(n).cf,contra_data(n).al_from_ml,'bo');hold on;
end;
xlabel('CF (Hz)');
ylabel('Axonal length from ML');
title('contra 9 fibers');

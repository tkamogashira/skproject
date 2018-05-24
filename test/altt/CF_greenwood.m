subplot(1,3,1)
    
for n=1:length(contra_data)
    plot(contra_data(n).cf,contra_data(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
end;
for n=1:length(ipsi_data)
    plot(ipsi_data(n).cf,ipsi_data(n).ep_minus_vp_on_dp_minus_vp,'ro');hold on;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'contra')==1
    plot(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    end;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'ipsi')==1
    plot(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end;
base=greenwood(60000);
f=(100:100:60000);
plot(f,(base-greenwood(f))/base,'k');hold on;
xlim([0 25000]);
xlabel([{'CF'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'}]);

ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;

subplot(1,3,2)
    
for n=1:length(contra_data)
    semilogx(contra_data(n).cf,contra_data(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
end;
for n=1:length(ipsi_data)
    semilogx(ipsi_data(n).cf,ipsi_data(n).ep_minus_vp_on_dp_minus_vp,'ro');hold on;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'contra')==1
    semilogx(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    end;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'ipsi')==1
    semilogx(guinan(n).cf,guinan(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end;
base=greenwood(60000);
f=(100:100:60000);
semilogx(f,(base-greenwood(f))/base,'k');hold on;

xlabel([{'CF'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'}]);

ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;

subplot(1,3,3)
    
for n=1:length(contra_data)
    plot(greenwood(contra_data(n).cf),contra_data(n).ep_minus_vp_on_dp_minus_vp,'bo');hold on;
end;
for n=1:length(ipsi_data)
    plot(greenwood(ipsi_data(n).cf),ipsi_data(n).ep_minus_vp_on_dp_minus_vp,'ro');hold on;
end; 
for n=1:length(guinan)
    if strcmp(guinan(n).side,'contra')==1
    plot(greenwood(guinan(n).cf),guinan(n).ep_minus_vp_on_dp_minus_vp,'b*');hold on;
    end;
end;
for n=1:length(guinan)
    if strcmp(guinan(n).side,'ipsi')==1
    plot(greenwood(guinan(n).cf),guinan(n).ep_minus_vp_on_dp_minus_vp,'r*');hold on;
    end;
end; 

xlabel([{'cochlear distance (mm) from the apex'},...
    {' '},...
    {'\color{blue}o: contra (our data)'},...
    {'\color{red}o: ipsi (our data)'},...
    {'\color{blue}*: contra (Guinan)'},...
    {'\color{red}*: ipsi (Guinan)'}]);

ylabel(['ventral \leftarrow  (EP-VP)/(DP-VP)  \rightarrow dorsal']);
hold off;
% Butter_forVocal
function EachMean=Butter_forVocal(M,z,t)
[b,a] = butter(2,[0.1/300 10/300]);
M2=filtfilt(b,a,M);
EachMean=mean(M2((1:z),:),1);
[m,n]=size(M2);
M3=M2-repmat(EachMean,m,1);
plot(t,M3),grid on
end

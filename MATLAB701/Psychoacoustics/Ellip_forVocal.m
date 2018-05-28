% Ellip_forVocal
function EachMean=Ellip_forVocal(M,z,t)
[b,a] = ellip(3,3,6,[0.1/300 10/300]);
M2=filtfilt(b,a,M);
EachMean=mean(M2((1:z),:),1);
[m,n]=size(M2);
M3=M2-repmat(EachMean,m,1);
plot(t,M3),grid on
end

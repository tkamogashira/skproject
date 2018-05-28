% FindMaxButter_forN100lowpass20
function MaxCh=FindMaxButter_forN100lowpass20(M,N,q)
[b,a] = butter(2,20/300,'low');
M1=filtfilt(b,a,M(:,(1:204)));
[d,c] = butter(2,1/300,'high');
M2=filtfilt(d,c,M1(:,(1:204)));
EachMean=mean(M2((5:29),(1:204)),1);
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);
[EachMaxVal,PreEachMaxLatIndex]=max(M3((75:116),(1:204)));
EachMaxLatIndex=PreEachMaxLatIndex+74;
[MaxChVal,MaxChLatIndex]=max(EachMaxVal.*(N(4,(1:204))==q));
MaxCh=[MaxChLatIndex N(1,MaxChLatIndex) M(EachMaxLatIndex(1,MaxChLatIndex),214) MaxChVal];
assignin('base',[inputname(1) '_MaxCh_' num2str(q)],MaxCh);
MaxChData=[M(:,214);M3(:,MaxChLatIndex)];
assignin('base',[inputname(1) '_MaxChData_' num2str(q)],MaxChData);
plot(M(:,214),M(:,MaxChLatIndex),'k',M(:,214),M3(:,MaxChLatIndex),'b'),grid on
end

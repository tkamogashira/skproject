% FindMaxButter90_180
function MaxCh=FindMaxButter90_180(M,N,q)
[b,a] = butter(2,20/300,'low');
M1=filtfilt(b,a,M(:,(1:204)));
[d,c] = butter(2,1/300,'high');
M2=filtfilt(d,c,M1(:,(1:204)));
EachMean=mean(M2((5:29),(1:204)),1);
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);
[EachMaxVal,PreEachMaxLatIndex]=max(M3((87:140),(1:204)));
EachMaxLatIndex=PreEachMaxLatIndex+86;
[MaxChVal,MaxChLatIndex]=max(EachMaxVal.*(N(4,(1:204))==q));
MaxCh=[MaxChLatIndex N(1,MaxChLatIndex) M(EachMaxLatIndex(1,MaxChLatIndex),214) MaxChVal];
assignin('base','MaxCh',MaxCh);
plot(M(:,214),M(:,MaxChLatIndex),M(:,214),M3(:,MaxChLatIndex)),grid on
end

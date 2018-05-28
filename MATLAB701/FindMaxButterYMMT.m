% FindMaxButter 204chs selected from 306chs

function MaxCh=FindMaxButterYMMT(M,N,q)
[b,a] = butter(2,20/300,'low');
M1=filtfilt(b,a,M(:,(1:204)));
[d,c] = butter(2,1/300,'high');
M2=filtfilt(d,c,M1(:,(1:204)));

EachMean=mean(M2((35:59),(1:204)),1);%baseline -45 to -5ms
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);

[EachMaxVal,PreEachMaxLatIndex]=max(M3((116:182),(1:204)));%Peak of MMN amplirude between 90 and 200ms on each channel
EachMaxLatIndex=PreEachMaxLatIndex+115;
[MaxChVal,MaxChLatIndex]=max(EachMaxVal.*(N(4,(1:204))==q));
MaxCh=[MaxChLatIndex N(1,MaxChLatIndex) M(EachMaxLatIndex(1,MaxChLatIndex),205) MaxChVal];%Time scale is on the 205th column
assignin('base','MaxCh',MaxCh);
plot(M(:,205),M(:,MaxChLatIndex),M(:,205),M3(:,MaxChLatIndex)),grid on
end

% FindMaxButter 204chs selected from 306chs

function FindMaxButterRMS_YMMT(M,N,q)
[b,a] = butter(2,20/300,'low');
M1=filtfilt(b,a,M(:,(1:204)));
[d,c] = butter(2,1/300,'high');
M2=filtfilt(d,c,M1(:,(1:204)));

EachMean=mean(M2((35:59),(1:204)),1);%baseline -45 to -5ms
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);



MM=[(M3(:,(1:204))).^2 M(:,205)];
SelectData=MM(:,(N(4,(1:204))==q));
SelectRMS=(mean(SelectData,2)).^(1/2);
[MaxVal,PreMaxLatIndex]=max(SelectRMS((116:182),1));%Peak of MMN amplirude between 90 and 200ms

MaxLatIndex=PreMaxLatIndex+115;
MaxRMS=[M(MaxLatIndex,205) MaxVal]
assignin('base',[inputname(1) '_MaxRMS_' num2str(q)],MaxRMS);
RMSdata=[(M(:,205))';(SelectRMS(:,1))'];
assignin('base',[inputname(1) '_RMSdata_' num2str(q)],RMSdata);
plot(M(:,205),SelectRMS(:,1)),grid on
end
% Butter_RMS_forN100
function MaxRMS=Butter_RMS_forN100(M,N,q)
[b,a] = butter(2,20/300,'low');
M1=filtfilt(b,a,M(:,(1:204)));
[d,c] = butter(2,1/300,'high');
M2=filtfilt(d,c,M1(:,(1:204)));
EachMean=mean(M2((5:29),(1:204)),1);
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);
MM=[(M3(:,(1:204))).^2 M(:,(205:214))];
SelectData=MM(:,(N(4,(1:204))==q));
SelectRMS=(mean(SelectData,2)).^(1/2);
[MaxVal,PreMaxLatIndex]=max(SelectRMS((75:116),1));
MaxLatIndex=PreMaxLatIndex+74;
MaxRMS=[M(MaxLatIndex,214) MaxVal];
assignin('base',[inputname(1) '_MaxRMS_' num2str(q)],MaxRMS);
RMSdata=[(M(:,214))';(SelectRMS(:,1))'];
assignin('base',[inputname(1) '_RMSdata_' num2str(q)],RMSdata);
plot(M(:,214),SelectRMS(:,1)),grid on
end

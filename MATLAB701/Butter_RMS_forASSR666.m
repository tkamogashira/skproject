% Butter_RMS_forASSR666
function MeanRMS=Butter_RMS_forASSR666(M,N)
[b,a] = butter(2,40/300);
M2=filtfilt(b,a,M(:,(1:204)));
EachMean=mean(M2(:,(1:204)),1);
[m,n]=size(M2);
M3=M2(:,(1:204))-repmat(EachMean,m,1);
MM=[(M3(:,(1:204))).^2 M(:,(205:221))];
SelectData1=MM(:,(N(4,(1:204))==1));
SelectRMS1=(mean(SelectData1,2)).^(1/2);
SelectData0=MM(:,(N(4,(1:204))==0));
SelectRMS0=(mean(SelectData0,2)).^(1/2);
SelectData2=MM(:,(N(4,(1:204))==2));
SelectRMS2=(mean(SelectData2,2)).^(1/2);
RMSdata=[(M(:,221))';(SelectRMS1(:,1))';(SelectRMS0(:,1))';(SelectRMS2(:,1))'];
assignin('base',[inputname(1) '_ButterRMSdata'],RMSdata);
MeanRMS1=mean(RMSdata(2,(138:227)));
MeanRMS0=mean(RMSdata(3,(138:227)));
MeanRMS2=mean(RMSdata(4,(138:227)));
MeanRMS=[MeanRMS1 MeanRMS0 MeanRMS2];
assignin('base',[inputname(1) '_ButterMeanRMS'],MeanRMS);
plot(M(:,221),SelectRMS1(:,1),'b',M(:,221),SelectRMS0(:,1),'k',M(:,221),SelectRMS2(:,1),'r'),grid on
end

% M to LtBlue14chsRtRed14chs
function Lt14Rt14=LtBlue14chsRtRed14chs(M,V)
ChPlusData=[M;V];
LtMean=(ChPlusData(:,3)+ChPlusData(:,4)+ChPlusData(:,5)+ChPlusData(:,6)+ChPlusData(:,7)+ChPlusData(:,8)+ChPlusData(:,55)+ChPlusData(:,103)+ChPlusData(:,104)+ChPlusData(:,105)+ChPlusData(:,106)+ChPlusData(:,107)+ChPlusData(:,108)+ChPlusData(:,155))/14
RtMean=(ChPlusData(:,47)+ChPlusData(:,48)+ChPlusData(:,49)+ChPlusData(:,50)+ChPlusData(:,53)+ChPlusData(:,54)+ChPlusData(:,98)+ChPlusData(:,147)+ChPlusData(:,148)+ChPlusData(:,149)+ChPlusData(:,150)+ChPlusData(:,153)+ChPlusData(:,154)+ChPlusData(:,199))/14
plot(ChPlusData(:,203)/1000,LtMean,'b',ChPlusData(:,203)/1000,RtMean,'r'),axis([1 5 0 40]),grid on
        


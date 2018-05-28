% M to LtBlue7chsRtRed7chs
function Lt7Rt7=LtBlue7chsRtRed7chs(M,V)
ChPlusData=[M;V];
LtMean=(ChPlusData(:,4)+ChPlusData(:,5)+ChPlusData(:,8)+ChPlusData(:,103)+ChPlusData(:,106)+ChPlusData(:,107)+ChPlusData(:,155))/7
RtMean=(ChPlusData(:,48)+ChPlusData(:,49)+ChPlusData(:,53)+ChPlusData(:,147)+ChPlusData(:,150)+ChPlusData(:,154)+ChPlusData(:,199))/7
plot(ChPlusData(:,203)/1000,LtMean,'b',ChPlusData(:,203)/1000,RtMean,'r'),axis([1 5 0 40]),grid on
        


% M to LtBlue4chsRtRed4chs
function Lt4Rt4=LtBlue4chsRtRed4chs(M,V)
ChPlusData=[M;V];
LtMean=(ChPlusData(:,5)+ChPlusData(:,8)+ChPlusData(:,106)+ChPlusData(:,107))/4
RtMean=(ChPlusData(:,48)+ChPlusData(:,49)+ChPlusData(:,147)+ChPlusData(:,150))/4
plot(ChPlusData(:,203)/1000,LtMean,'b',ChPlusData(:,203)/1000,RtMean,'r'),axis([1 5 0 40]),grid on
        


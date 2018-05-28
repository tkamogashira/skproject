% M to 4HzPeakLabel4
function Ch=Mto4HzPeakLabel4(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(55,n)==max(ChPlusData((49:62),n))
        if ChPlusData(411,n)==1
            subplot(1,2,1);
            plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'b'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusData(53,203)/1000,ChPlusData(55,n),num2str(ChPlusData(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusData(411,n)==2
            subplot(1,2,2);
            plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusData(50,203)/1000,ChPlusData(55,n),num2str(ChPlusData(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusData(410,n)
    elseif ChPlusData(56,n)==max(ChPlusData((49:62),n))
        if ChPlusData(411,n)==1
            subplot(1,2,1);
            plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'b'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusData(57,203)/1000,ChPlusData(56,n),num2str(ChPlusData(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusData(411,n)==2
            subplot(1,2,2);
            plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusData(60,203)/1000,ChPlusData(56,n),num2str(ChPlusData(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusData(410,n)
    end;
end

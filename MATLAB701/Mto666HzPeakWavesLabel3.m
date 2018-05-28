% M to 666HzPeakWavesLabel3
function Ch=Mto666HzPeakWavesLabel3(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(91,n)==max(ChPlusData((78:104),n))
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    elseif ChPlusData(92,n)==max(ChPlusData((78:104),n))
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    end
end


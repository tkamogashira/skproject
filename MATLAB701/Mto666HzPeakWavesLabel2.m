% M to 666HzPeakWavesLabel2
function Ch=Mto666HzPeakWavesLabel2(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(92,n)==max(ChPlusData((78:104),n))
        plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
        Ch=ChPlusData(410,n)
    end
end


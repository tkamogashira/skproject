% M to PeakCheck
function Ch=PeakCheck(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    plot(ChPlusData(:,203)/1000,ChPlusData(:,n),'r'),hold on,axis([1 10 0 40]),grid on
end


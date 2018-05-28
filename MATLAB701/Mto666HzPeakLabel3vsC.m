% M to 666HzPeakLabel3vsC
function Ch=Mto666HzPeakLabel3vsC(M,N,V)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
for n=1:202
    if ChPlusDataM(91,n)==max(ChPlusDataM((78:104),n))
        plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([5.65 7.67 0 20]),grid on
        text(ChPlusDataM(91,203)/1000,ChPlusDataM(91,n),num2str(ChPlusDataM(410,n)),'Color','r')
        Ch=ChPlusDataM(410,n)
    elseif ChPlusDataM(92,n)==max(ChPlusDataM((78:104),n)) 
        plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([5.65 7.67 0 20]),grid on
        text(ChPlusDataM(92,203)/1000,ChPlusDataM(92,n),num2str(ChPlusDataM(410,n)),'Color','r')
        Ch=ChPlusDataM(410,n)
    end
end


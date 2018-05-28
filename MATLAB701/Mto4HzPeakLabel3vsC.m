% M to 4HzPeakLabel3vsC
function Ch=Mto4HzPeakLabel3vsC(M,N,V)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
for n=1:202
    if ChPlusDataM(55,n)==max(ChPlusDataM((42:69),n))
        plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([3 5 0 20]),grid on
        text(ChPlusDataM(55,203)/1000,ChPlusDataM(55,n),num2str(ChPlusDataM(410,n)),'Color','r')
        Ch=ChPlusDataM(410,n)
    elseif ChPlusDataM(56,n)==max(ChPlusDataM((42:69),n)) 
        plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([3 5 0 20]),grid on
        text(ChPlusDataM(56,203)/1000,ChPlusDataM(56,n),num2str(ChPlusDataM(410,n)),'Color','r')
        Ch=ChPlusDataM(410,n)
    end
end


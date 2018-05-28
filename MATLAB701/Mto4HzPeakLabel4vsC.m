% M to 4HzPeakLabel4vsC
function Ch=Mto4HzPeakLabel4vsC(M,N,V)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
for n=1:202
    if ChPlusDataM(55,n)==max(ChPlusDataM((49:62),n))
        semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([3 5 0 20]),grid on
        text(ChPlusDataM(55,203)/1000,ChPlusDataM(55,n),num2str(ChPlusDataM(410,n)),'Color','r')
        text(ChPlusDataN(50,203)/1000,ChPlusDataN(55,n),num2str(ChPlusDataN(410,n)),'Color','m')
        Ch=ChPlusDataM(410,n)
    elseif ChPlusDataM(56,n)==max(ChPlusDataM((49:62),n)) 
        semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([3 5 0 20]),grid on
        text(ChPlusDataM(56,203)/1000,ChPlusDataM(56,n),num2str(ChPlusDataM(410,n)),'Color','r')
        text(ChPlusDataN(50,203)/1000,ChPlusDataN(56,n),num2str(ChPlusDataN(410,n)),'Color','m')
        Ch=ChPlusDataM(410,n)
    end
end


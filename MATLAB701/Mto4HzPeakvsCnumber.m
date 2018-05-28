% M to 4HzPeakvsCnumber
function Ch=Mto4HzPeakLabel4vsC(M,N,V,n)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
if ChPlusDataM(55,n)>ChPlusDataM(56,n)
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(55,n),num2str(ChPlusDataM(410,n)),'Color','r')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(55,n),num2str(ChPlusDataN(410,n)),'Color','r')
    Ch=ChPlusDataM(410,n)
else 
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b',ChPlusDataN(:,203)/1000,ChPlusDataN(:,n),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(56,n),num2str(ChPlusDataM(410,n)),'Color','r')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(56,n),num2str(ChPlusDataN(410,n)),'Color','r')
    Ch=ChPlusDataM(410,n)
end;
end


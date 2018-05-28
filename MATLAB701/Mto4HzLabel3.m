% M to 4HzLabel3
function Ch=Mto4HzLabel3(M,N,V,x)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
for n=1:202
    if ChPlusDataM(55,n)==max(ChPlusDataM((42:69),n))
        if ChPlusDataM(411,n)==1
            subplot(1,3,1);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusDataM(53,203)/1000,ChPlusDataM(55,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusDataM(411,n)==2
            subplot(1,3,2);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'r'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusDataM(50,203)/1000,ChPlusDataM(55,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusDataM(410,n)
    elseif ChPlusDataM(56,n)==max(ChPlusDataM((42:69),n))
        if ChPlusDataM(411,n)==1
            subplot(1,3,1);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusDataM(57,203)/1000,ChPlusDataM(56,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusDataM(411,n)==2
            subplot(1,3,2);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'r'),hold on,axis([3 5 0 20]),grid on
            text(ChPlusDataM(60,203)/1000,ChPlusDataM(56,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusDataM(410,n)
    end;
end;
if ChPlusDataM(55,x)>ChPlusDataM(56,x)
    subplot(1,3,3);
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'m',ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(55,x),num2str(ChPlusDataM(410,x)),'Color','m')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(55,x),num2str(ChPlusDataN(410,x)),'Color','k')
else 
    subplot(1,3,3);
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'m',ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(56,x),num2str(ChPlusDataM(410,x)),'Color','m')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(56,x),num2str(ChPlusDataN(410,x)),'Color','k')
end;
end


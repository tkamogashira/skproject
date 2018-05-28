% M to 666HzLabel4
function Ch=Mto666HzLabel4(M,N,V,x)
ChPlusDataM=[M;V];
ChPlusDataN=[N;V];
hold off;
for n=1:202
    if ChPlusDataM(91,n)==max(ChPlusDataM((85:98),n))
        if ChPlusDataM(411,n)==1
            subplot(1,3,1);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b'),hold on,axis([5.6 7.6 0 20]),grid on
            text(ChPlusDataM(86,203)/1000,ChPlusDataM(91,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusDataM(411,n)==2
            subplot(1,3,2);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'r'),hold on,axis([5.6 7.6 0 20]),grid on
            text(ChPlusDataM(86,203)/1000,ChPlusDataM(91,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusDataM(410,n)
    elseif ChPlusDataM(92,n)==max(ChPlusDataM((85:98),n))
        if ChPlusDataM(411,n)==1
            subplot(1,3,1);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'b'),hold on,axis([5.6 7.6 0 20]),grid on
            text(ChPlusDataM(97,203)/1000,ChPlusDataM(92,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        elseif ChPlusDataM(411,n)==2
            subplot(1,3,2);
            plot(ChPlusDataM(:,203)/1000,ChPlusDataM(:,n),'r'),hold on,axis([5.6 7.6 0 20]),grid on
            text(ChPlusDataM(97,203)/1000,ChPlusDataM(92,n),num2str(ChPlusDataM(410,n)),'FontSize',10,'Color','k')
        end
        Ch=ChPlusDataM(410,n)
    end;
end;
if ChPlusDataM(91,x)>ChPlusDataM(92,x)
    subplot(1,3,3);
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'m',ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(91,x),num2str(ChPlusDataM(410,x)),'Color','m')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(91,x),num2str(ChPlusDataN(410,x)),'Color','k')
else 
    subplot(1,3,3);
    semilogx(ChPlusDataM(:,203)/1000,ChPlusDataM(:,x),'m',ChPlusDataN(:,203)/1000,ChPlusDataN(:,x),'k'),hold on,axis([1 10 0 40]),grid on
    text(ChPlusDataM(30,203)/1000,ChPlusDataM(92,x),num2str(ChPlusDataM(410,x)),'Color','m')
    text(ChPlusDataN(30,203)/1000,ChPlusDataN(92,x),num2str(ChPlusDataN(410,x)),'Color','k')
end;
end


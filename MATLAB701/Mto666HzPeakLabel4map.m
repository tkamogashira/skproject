% M to 666HzPeakLabel4map
function Ch=Mto666HzPeakLabel4map(M,V)
ChPlusData=[M;V];
hold off;
for n=1:202
    if ChPlusData(91,n)==max(ChPlusData((85:98),n))
        text(ChPlusData(412,n),ChPlusData(413,n),num2str(ChPlusData(410,n))),hold on;
    elseif ChPlusData(92,n)==max(ChPlusData((85:98),n)) 
        text(ChPlusData(412,n),ChPlusData(413,n),num2str(ChPlusData(410,n))),hold on;
    end
end;
for n=1:202
    if ChPlusData(411,n)>0
        plot(ChPlusData(412,n),ChPlusData(413,n),'ko'),hold on;
    else
        plot(ChPlusData(412,n),ChPlusData(413,n),'k.'),hold on;    
    end
end;
end



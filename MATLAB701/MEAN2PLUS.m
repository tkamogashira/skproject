% MEAN 2 PLUS
function plusMEAN=MEAN2PLUS(MEAN,A20)
plusMEAN(1,:)=MEAN(1,:);
plusMEAN(2,:)=MEAN(2,:);
for n=1:202
    if MEAN(3,n)>0
        plusMEAN(3,n)=MEAN(3,n);
    else
        plusMEAN(3,n)=0;
    end;
end;
assignin('base','plusMEAN',plusMEAN);
stem3(plusMEAN(1,:),plusMEAN(2,:),plusMEAN(3,:),'k')
hold on;
for n=1:203
    if A20(4,n)>0
        plot(A20(2,n),A20(3,n),'ok'),hold on
    else
        plot(A20(2,n),A20(3,n),'xk'),hold on
    end
end



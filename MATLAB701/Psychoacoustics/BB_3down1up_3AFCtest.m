% BB_3down1up_3AFCtest
function RESULT=BB_3down1up_3AFCtest(F0,F1,Z,w)
if F1>F0
    Width=w;
else
    Width=-w;
end;
t=(1:(1/8192):5);
NoBB=[(sin(2*pi*t*F0))' (sin(2*pi*t*F0))'];
ISI2s=zeros([(8192*2),2]);
Tnumber(1,1)=1;
Freq(1,1)=F1;
BB=[(sin(2*pi*t*F0))' (sin(2*pi*t*Freq(1,1)))'];
BBinterval(1,1)=unidrnd(3);
if BBinterval(1,1)==1
    Trial=[BB;ISI2s;NoBB;ISI2s;NoBB];
elseif BBinterval(1,1)==2
    Trial=[NoBB;ISI2s;BB;ISI2s;NoBB];
else
    Trial=[NoBB;ISI2s;NoBB;ISI2s;BB];
end;
sound(Trial)
Ans(1,1)=input('Which is BB? 1, 2 or 3?');
if Ans(1,1)==BBinterval(1,1)
    Judge(1,1)=1;Freq(1,2)=Freq(1,1);Stay(1,1)=1;
else
    Judge(1,1)=0;Freq(1,2)=Freq(1,1)+Width;Stay(1,1)=0;
end;
Tnumber(1,2)=2;
BB=[(sin(2*pi*t*F0))' (sin(2*pi*t*Freq(1,2)))'];
BBinterval(1,2)=unidrnd(3);
if BBinterval(1,2)==1
    Trial=[BB;ISI2s;NoBB;ISI2s;NoBB];
elseif BBinterval(1,2)==2
    Trial=[NoBB;ISI2s;BB;ISI2s;NoBB];
else
    Trial=[NoBB;ISI2s;NoBB;ISI2s;BB];
end;
sound(Trial)
Ans(1,2)=input('Which is BB? 1, 2 or 3?');
if Ans(1,2)==BBinterval(1,2)
    Judge(1,2)=1;Freq(1,3)=Freq(1,2);Stay(1,2)=1;
else
    Judge(1,2)=0;Freq(1,3)=Freq(1,2)+Width;Stay(1,2)=0;
end;
for m=3:Z
    BB=[(sin(2*pi*t*F0))' (sin(2*pi*t*Freq(1,m)))'];
    BBinterval(1,m)=unidrnd(3);
    if BBinterval(1,m)==1
        Trial=[BB;ISI2s;NoBB;ISI2s;NoBB];
    elseif BBinterval(1,m)==2
        Trial=[NoBB;ISI2s;BB;ISI2s;NoBB];
    else
        Trial=[NoBB;ISI2s;NoBB;ISI2s;BB];
    end;
    sound(Trial)
    Ans(1,m)=input('Which is BB? 1, 2 or 3?');
    if Ans(1,m)==BBinterval(1,m)
        Judge(1,m)=1;
    else
        Judge(1,m)=0;
    end;
    if Stay(1,(m-2))*Stay(1,(m-1))==0
        x=Judge(1,m);
    else
        x=(Judge(1,(m-2))+Judge(1,(m-1))+Judge(1,m))*Judge(1,m);
    end;
    if x==0
        Freq(1,(m+1))=Freq(1,m)+Width;
        Stay(1,m)=0;
    elseif x==3
        Freq(1,(m+1))=Freq(1,m)-Width;
        Stay(1,m)=0;
    else
        Freq(1,(m+1))=Freq(1,m);
        Stay(1,m)=1;
    end;
    Tnumber(1,m)=m;
end;
RESULT=[Freq(1,(1:Z));BBinterval(1,(1:Z));Ans(1,(1:Z));Judge(1,(1:Z));Stay(1,(1:Z));Tnumber(1,(1:Z))];
assignin('base','RESULT',RESULT);
plot(RESULT(6,(RESULT(4,:)==1)),RESULT(1,(RESULT(4,:)==1)),'ok'),hold on
plot(RESULT(6,(RESULT(4,:)==0)),RESULT(1,(RESULT(4,:)==0)),'xk'),hold on
end

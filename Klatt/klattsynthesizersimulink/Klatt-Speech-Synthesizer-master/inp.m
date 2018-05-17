function [tim sig] = inp(ttf,F0)
T0 = 1./F0;
t = ttf./1000;
sig=[];
tim=[];
oldT=0;
for i=1:size(ttf)-1
    Tperiod = fix(T0(i)*10000)/10000;
    tempT = ceil((t(i+1)-t(i))/Tperiod)*Tperiod;
    T = oldT:0.0001:oldT+tempT-0.0001;
    S = [];
    
    AV = 1/Tperiod;
    Oq = 0.5;
    a = 27*AV/(4*Tperiod*Oq*Oq);
    b = 27*AV/(4*Tperiod*Tperiod*Oq*Oq*Oq);
    
    if mod(Tperiod*10000,2) == 0
        tempt1 = 0:0.0001:Tperiod*Oq-0.0001;
    else
        tempt1 = 0:0.0001:floor(Tperiod*Oq*10000)/10000;
    end
    tempt2 = Tperiod*Oq:0.0001:Tperiod-0.0001;
    
    sig1 = a.*(tempt1.^2) - b.*(tempt1.^3);
    sig2 = zeros(size(tempt2));

    for j = 1:tempT/Tperiod
        S = [S sig1 sig2];
    end
    
    sig=[sig S];
    tim = [tim T];
    oldT=oldT+tempT;
end
tim = tim*1000;
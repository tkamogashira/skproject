function [tim sig] = impul(ttf,F0)
T0 = 1./F0;
t = ttf./1000;
sig=[];
tim=[];
oldT=0;
for i=1:size(ttf)-1
    tempT = ceil(t(i+1)/T0(i))*T0(i);
    T = oldT:0.0001:tempT-0.0001;
    S = zeros(size(T));
    
    S(1:T0(i)*10000:tempT*10000-oldT*10000-1)=1;
    
    sig=[sig S];
    tim = [tim T];
    oldT=tempT;
end
tim = tim*1000;
plot(T,S);
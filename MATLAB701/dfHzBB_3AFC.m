% dfHzBB_3AFC
function Trial=dfHzBB_3AFC(n)
t=(1:(1/8192):4);
BBn=[(sin(2*pi*t*250))' (sin(2*pi*t*(250+n)))'];
BB0=[(sin(2*pi*t*250))' (sin(2*pi*t*250))'];
ISI2s=zeros([(8192*2),2]);
R=unidrnd(3);
if R==1
    Trial=[BBn;ISI2s;BB0;ISI2s;BB0];
elseif R==2
    Trial=[BB0;ISI2s;BBn;ISI2s;BB0];
else
    Trial=[BB0;ISI2s;BB0;ISI2s;BBn];
end;
sound(Trial)
end

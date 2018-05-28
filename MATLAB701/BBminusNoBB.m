% BBminusNoBB
function Dif=BBminusNoBB(M,N,F)
D=[(M((15:137),(1:202))-N((15:137),(1:202))),M((15:137),203)];
Dif=[F;D];
assignin('base','Dif',Dif);    
end




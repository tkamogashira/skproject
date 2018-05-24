%898
for n=1:length(CFcombiselect898)
    m1=findstr(CFcombiselect898(n).Fiber1, ' ');
    ds1 = dataset(CFcombiselect898(n).Fiber1(1:(m1-1)), CFcombiselect898(n).Fiber1((m1+1):length(CFcombiselect898(n).Fiber1)));
    m2=findstr(CFcombiselect898(n).Fiber2, ' ');
    ds2 = dataset(CFcombiselect898(n).Fiber2(1:(m1-1)), CFcombiselect898(n).Fiber2((m1+1):length(CFcombiselect898(n).Fiber2)));
    
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC,IRA] = EvalFSphase2Rlin_A0898(ds1,ds2);
    
    sigidx=find(IPC.pRayleigh <= 0.001);
    CFcombiselect898(n).IRx = IRA.X(sigidx);
    CFcombiselect898(n).IRy = IRA.Y(sigidx);
    CFcombiselect898(n).IRmaxY = IRA.eachMax(sigidx);
    clear IPC;clear IRA;
    display(n)
end;






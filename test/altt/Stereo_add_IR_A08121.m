%8121
for n=1:length(CFcombiselect8121)
    m1=findstr(CFcombiselect8121(n).Fiber1, ' ');
    ds1 = dataset(CFcombiselect8121(n).Fiber1(1:(m1-1)), CFcombiselect8121(n).Fiber1((m1+1):length(CFcombiselect8121(n).Fiber1)));
    m2=findstr(CFcombiselect8121(n).Fiber2, ' ');
    ds2 = dataset(CFcombiselect8121(n).Fiber2(1:(m2-1)), CFcombiselect8121(n).Fiber2((m2+1):length(CFcombiselect8121(n).Fiber2)));
    
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC,IRA] = EvalFSphase2Rlin_A08121(ds1,ds2);
    
    sigidx=find(IPC.pRayleigh <= 0.001);
    CFcombiselect8121(n).IRx = IRA.X(sigidx);
    CFcombiselect8121(n).IRy = IRA.Y(sigidx);
    CFcombiselect8121(n).IRmaxY = IRA.eachMax(sigidx);
    clear IPC;clear IRA;
    display(n)
end;






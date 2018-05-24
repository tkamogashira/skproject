%242
for n=1:length(CFcombiselect242)
    ds1 = dataset('a0242', CFcombiselect242(n).Fiber1(7:length(CFcombiselect242(n).Fiber1)));
    ds2 = dataset('a0242', CFcombiselect242(n).Fiber2(7:length(CFcombiselect242(n).Fiber2)));
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC,IRA] = EvalFSphase2Rlin(ds1,ds2);
    
    sigidx=find(IPC.pRayleigh <= 0.001);
    CFcombiselect242(n).IRx = IRA.X(sigidx);
    CFcombiselect242(n).IRy = IRA.Y(sigidx);
    CFcombiselect242(n).IRmaxY = IRA.eachMax(sigidx);
    clear IPC;clear IRA;
    display(n)
end;






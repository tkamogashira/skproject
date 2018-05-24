

%898
for n=1:length(CFcombiselect898)
    m1=findstr(CFcombiselect898(n).Fiber1, ' ');
    ds1 = dataset(CFcombiselect898(n).Fiber1(1:(m1-1)), CFcombiselect898(n).Fiber1((m1+1):length(CFcombiselect898(n).Fiber1)));
    m2=findstr(CFcombiselect898(n).Fiber2, ' ');
    ds2 = dataset(CFcombiselect898(n).Fiber2(1:(m1-1)), CFcombiselect898(n).Fiber2((m1+1):length(CFcombiselect898(n).Fiber2)));
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin_A0898(ds1,ds2);
    CFcombiselect898(n).pLinReg = IPC.pLinReg;
    CFcombiselect898(n).MSerror = IPC.MSerror;
    CFcombiselect898(n).DF = IPC.DF;
    clear IPC;
    display(n)
end;






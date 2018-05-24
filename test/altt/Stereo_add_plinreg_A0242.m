

%242
for n=1:length(CFcombiselect242)
    ds1 = dataset('a0242', CFcombiselect242(n).Fiber1(7:length(CFcombiselect242(n).Fiber1)));
    ds2 = dataset('a0242', CFcombiselect242(n).Fiber2(7:length(CFcombiselect242(n).Fiber2)));
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin(ds1,ds2);
    CFcombiselect242(n).pLinReg = IPC.pLinReg;
    CFcombiselect242(n).MSerror = IPC.MSerror;
    CFcombiselect242(n).DF = IPC.DF;
    clear IPC;
    display(n)
end;






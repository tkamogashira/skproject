%241
for n=1:length(CFcombiselect241)
    ds1 = dataset('a0241', CFcombiselect241(n).Fiber1(7:length(CFcombiselect241(n).Fiber1)));
    ds2 = dataset('a0241', CFcombiselect241(n).Fiber2(7:length(CFcombiselect241(n).Fiber2)));
    [BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin(ds1,ds2);
    CFcombiselect241(n).pLinReg = IPC.pLinReg;
    CFcombiselect241(n).MSerror = IPC.MSerror;
    CFcombiselect241(n).DF = IPC.DF;
    clear IPC;
    display(n)
end;

%242
%for n=1:length(CFcombiselect242)
    %ds1 = dataset('a0242', CFcombiselect242(n).Fiber1(7:length(CFcombiselect242(n).Fiber1)));
    %ds2 = dataset('a0242', CFcombiselect242(n).Fiber2(7:length(CFcombiselect242(n).Fiber2)));
    %[BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin(ds1,ds2);
    %CFcombiselect242(n).pLinReg = IPC.pLinReg;
    %CFcombiselect242(n).MSerror = IPC.MSerror;
    %CFcombiselect242(n).DF = IPC.DF;
    %clear IPC;
    %display(n)
%end;

%898
%for n=1:length(CFcombiselect898)
    %m1=findstr(CFcombiselect898(n).Fiber1, ' ');
    %ds1 = dataset(CFcombiselect898(n).Fiber1(1:(m1-1)), CFcombiselect898(n).Fiber1((m1+1):length(CFcombiselect898(n).Fiber1)));
    %m2=findstr(CFcombiselect898(n).Fiber2, ' ');
    %ds2 = dataset(CFcombiselect898(n).Fiber2(1:(m1-1)), CFcombiselect898(n).Fiber2((m1+1):length(CFcombiselect898(n).Fiber2)));
    %[BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin_A0898(ds1,ds2);
    %CFcombiselect898(n).pLinReg = IPC.pLinReg;
    %CFcombiselect898(n).MSerror = IPC.MSerror;
    %CFcombiselect898(n).DF = IPC.DF;
    %clear IPC;
    %display(n)
%end;

%8121
%for n=1:length(CFcombiselect8121)
    %m1=findstr(CFcombiselect8121(n).Fiber1, ' ');
    %ds1 = dataset(CFcombiselect8121(n).Fiber1(1:(m1-1)), CFcombiselect8121(n).Fiber1((m1+1):length(CFcombiselect8121(n).Fiber1)));
    %m2=findstr(CFcombiselect8121(n).Fiber2, ' ');
    %ds2 = dataset(CFcombiselect8121(n).Fiber2(1:(m2-1)), CFcombiselect8121(n).Fiber2((m2+1):length(CFcombiselect8121(n).Fiber2)));
    %[BF,BestITD,BP,CD,CP,CF1,CF2,IPCx,IPCy,ISRx,ISRy,IPC] = EvalFSphase2Rlin_A08121(ds1,ds2);
    %CFcombiselect8121(n).pLinReg = IPC.pLinReg;
    %CFcombiselect8121(n).MSerror = IPC.MSerror;
    %CFcombiselect8121(n).DF = IPC.DF;
    %clear IPC;
    %display(n)
%end;




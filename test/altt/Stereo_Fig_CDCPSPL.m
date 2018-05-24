CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

subplot(2,2,1)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).pLinReg < 0.005 
    plot(CFcombiselectALL(n).SPL1(1), CFcombiselectALL(n).CD, 'ko');hold on;
    end;
end;
axis([30 70 -1.5 1.5]);line([30 70],[0 0],'color','k');
title('Linear');xlabel('Tone intensity (dB)');ylabel('CD (ms)');

subplot(2,2,2)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).pLinReg < 0.005 
    plot(CFcombiselectALL(n).SPL1(1), CFcombiselectALL(n).CPr, 'ko');hold on;
    end;
end;
axis([30 70 -0.5 0.5]);line([30 70],[0 0],'color','k');
title('Linear');xlabel('Tone intensity (dB)');ylabel('CP (cycles)');

subplot(2,2,3)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).pLinReg >= 0.005 
    plot(CFcombiselectALL(n).SPL1(1), CFcombiselectALL(n).CD, 'ko');hold on;
    end;
end;
axis([30 70 -1.5 1.5]);line([30 70],[0 0],'color','k');
title('Nonlinear');xlabel('Tone intensity (dB)');ylabel('CD (ms)');

subplot(2,2,4)
for n=1:length(CFcombiselectALL)
    if CFcombiselectALL(n).pLinReg >= 0.005 
    plot(CFcombiselectALL(n).SPL1(1), CFcombiselectALL(n).CPr, 'ko');hold on;
    end;
end;
axis([30 70 -0.5 0.5]);line([30 70],[0 0],'color','k');
title('Nonlinear');xlabel('Tone intensity (dB)');ylabel('CP (cycles)');
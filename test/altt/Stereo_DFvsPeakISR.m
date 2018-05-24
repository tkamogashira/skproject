CFcombiselectALL = [CFcombiselect241, CFcombiselect242, CFcombiselect898, CFcombiselect8121];

for k=1:length(CFcombiselectALL)
    CFcombiselectALL(k).spl=CFcombiselectALL(k).SPL1(1);
end;
for k=1:length(CFcombiselectALL)
    [C,I] = max(CFcombiselectALL(k).ISRy);
    CFcombiselectALL(k).peakISR_f = max(CFcombiselectALL(k).ISRx(I));
    clear C;clear I;
end;


CFcombiselectALL_70=structfilter(CFcombiselectALL,'$spl$==70');
CFcombiselectALL_60=structfilter(CFcombiselectALL,'$spl$==60');
CFcombiselectALL_50=structfilter(CFcombiselectALL,'$spl$==50');
CFcombiselectALL_40=structfilter(CFcombiselectALL,'$spl$==40');
CFcombiselectALL_30=structfilter(CFcombiselectALL,'$spl$==30');

structplot(CFcombiselectALL,'peakISR_f','BF');

figure
for m=1:length(CFcombiselectALL)
    if CFcombiselectALL(m).pLinReg < 0.005
         plot(CFcombiselectALL(m).peakISR_f, CFcombiselectALL(m).BF, 'k.','markersize',6);hold on;
    elseif CFcombiselectALL(m).pLinReg >= 0.005
         plot(CFcombiselectALL(m).peakISR_f, CFcombiselectALL(m).BF, 'ko','markersize',6);hold on;
    end;
end;
axis([0 2500 0 2500]);
f=(1:1:2500);line(f,f*0.9485+ones(1,2500)*88.11,'color','k');grid on;%Corr: 0.94 (p=0)
xlabel('Tone frequency for peak ISR (Hz)');ylabel('Dominant Frequency (Hz)');


linear=structfilter(CFcombiselectALL, '$pLinReg$ < 0.005');
structplot(linear,'peakISR_f','BF','fit','linear');

%subplot(1,5,1)
structplot(CFcombiselectALL_70,'peakISR_f','BF');
%subplot(1,5,2)
structplot(CFcombiselectALL_60,'peakISR_f','BF');
%subplot(1,5,3)
structplot(CFcombiselectALL_50,'peakISR_f','BF');
%subplot(1,5,4)
structplot(CFcombiselectALL_40,'peakISR_f','BF');
%subplot(1,5,5)
structplot(CFcombiselectALL_30,'peakISR_f','BF');


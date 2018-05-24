
%for n=1:length(BBICselectWithCF)
    %f1=dataset(BBICselectWithCF(n).Filename, BBICselectWithCF(n).Seqid);
    %[ArgOut,ThrCF,DomF,RateBF,sigpX,sigpY,lineX,lineY,CD,CP,BestITD,CalcData] = EvalBB22(f1);
    
    %sigidx=find(CalcData.vs.raysig <= 0.001);
    %BBICselectWithCF(n).sigRX=CalcData.vs.freq(sigidx);
    %BBICselectWithCF(n).sigRY=CalcData.vs.r(sigidx);
    %BBICselectWithCF(n).sigRateX=CalcData.rate.freq(sigidx);
    %BBICselectWithCF(n).sigRateY=CalcData.rate.rate(sigidx);
    %BBICselectWithCF(n).sigSyncRateX=BBICselectWithCF(n).sigRX;
    %BBICselectWithCF(n).sigSyncRateY=(BBICselectWithCF(n).sigRY).*(BBICselectWithCF(n).sigRateY);
    %close all;
%end;

BBICselectWithCF_70db=structfilter(BBICselectWithCF,'$spl$ == 70');
BBICselectWithCF_60db=structfilter(BBICselectWithCF,'$spl$ == 60');
BBICselectWithCF_50db=structfilter(BBICselectWithCF,'$spl$ == 50');
BBICselectWithCF_40db=structfilter(BBICselectWithCF,'$spl$ == 40');
BBICselectWithCF_30db=structfilter(BBICselectWithCF,'$spl$ == 30');

subplot(5,1,1)
MM=BBICselectWithCF_70db;
for m=1:length(MM)
    line(MM(m).sigSyncRateX, MM(m).sigSyncRateY, 'color','k','LineWidth',0.5);hold on;
end;axis([0 4000 0 100]);title('70dB');xlabel('Tone frequecy (Hz)');ylabel('SyncRate (spikes/sec)');

subplot(5,1,2)
MM=BBICselectWithCF_60db;
for m=1:length(MM)
    line(MM(m).sigSyncRateX, MM(m).sigSyncRateY, 'color','k','LineWidth',0.5);hold on;
end;axis([0 4000 0 100]);title('60dB');xlabel('Tone frequecy (Hz)');ylabel('SyncRate (spikes/sec)');

subplot(5,1,3)
MM=BBICselectWithCF_50db;
for m=1:length(MM)
    line(MM(m).sigSyncRateX, MM(m).sigSyncRateY, 'color','k','LineWidth',0.5);hold on;
end;axis([0 4000 0 100]);title('50dB');xlabel('Tone frequecy (Hz)');ylabel('SyncRate (spikes/sec)');

subplot(5,1,4)
MM=BBICselectWithCF_40db;
for m=1:length(MM)
    line(MM(m).sigSyncRateX, MM(m).sigSyncRateY, 'color','k','LineWidth',0.5);hold on;
end;axis([0 4000 0 100]);title('40dB');xlabel('Tone frequecy (Hz)');ylabel('SyncRate (spikes/sec)');

subplot(5,1,5)
MM=BBICselectWithCF_30db;
for m=1:length(MM)
    line(MM(m).sigSyncRateX, MM(m).sigSyncRateY, 'color','k','LineWidth',0.5);hold on;
end;axis([0 4000 0 100]);title('30dB');xlabel('Tone frequecy (Hz)');ylabel('SyncRate (spikes/sec)');





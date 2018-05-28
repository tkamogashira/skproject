%FreqLevelPlot -- Quick offline analysis of Freq-level plot

global MonitorSetting STIM

%Use the TONE data only
Idx=strmatch('Tone',STIM(:,1));

%Frequency
s=char(STIM(Idx,2));
freq=str2num(s);
freqlist=unique(freq);
nfreq=length(freqlist);
%SPL
s=char(STIM(Idx,3));
spl=str2num(s);
spllist=unique(spl);
nspl=length(spllist);
%Stimulus duration
s=char(STIM(Idx,7));
dur=str2num(s);
xrng=ceil(dur(1)):ceil(dur(1)+dur(2));

%Spike count during the tone
Cnt=sum(MonitorSetting.PSTH.ZData(Idx,xrng),2);
Cnt=reshape(Cnt,[nfreq,nspl])';

%Draw figure
figure(1)
imagesc(1:nfreq,1:nspl,Cnt);
ytick=1:nspl;
yticklabel=num2str(spllist(:));
if nspl>10
    skip=ceil(nspl/10);
    ytick=ytick(1:skip:nspl);
    yticklabel=yticklabel(1:skip:nspl,:);
end
xtick=1:nfreq;
xticklabel=num2str(round(freqlist(:)));
if nfreq>10
    skip=ceil(nfreq/10);
    xtick=xtick(1:skip:nfreq);
    xticklabel=xticklabel(1:skip:nfreq,:);
end
set(gca,'XTick',xtick,'XTickLabel',xticklabel,'YTick',ytick,'YTickLabel',yticklabel,'YDir','normal');
colorbar


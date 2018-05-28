function [Y, impRes, Lat, maxAmp]= fastErevAna(FN, iSeq, binWidth,plotArg, Delay, tsel);
persistent DelaY
more off

ignoreReject = 0;
if nargin<3,
   binWidth = 0.1;
elseif binWidth<0,
   ignoreReject = 1;
end
if nargin<4,
   if ischar(binWidth), 
      plotArg=binWidth;
      binWidth = 0.1;
   else, plotArg='b'; end
end

if nargin<5,
   if isempty(DelaY), 
      DelaY = 0;
   end
else,
   DelaY = Delay;
end

if nargin<6, tsel = []; end

if iscell(iSeq),
   ploco = 'brgmkrgmkrgmkrgmk';
   % ploli = {'-' ':' '-.' '--' '-' ':' '-.' '--' '-' ':' '-.' '--' '-' ':' '-.' '--' };
   ploli = {'' '' '' '' '' '' '' '' '' '' '' '' '' '' '' };
   for ii=1:length(iSeq),
      [Y, impRes, Lat(ii), maxAmp(ii)] = fasterevana(FN,iSeq{ii},binWidth,[ploco(ii) ploli{ii}], DelaY, tsel);
   end
   return;
end

if isequal(plotArg(1),'b'),
   HO = 'off';
   if ishandle(1), delete(1); end;
   f1;
   if ~inUtrecht, 
      % fpos = get(1,'position');
      set(1,'position',[20 86 1244 868]);
   end
   set(1, 'PaperOrientation', 'landscape');
else,
   HO = 'on';
   f1; hold on;
end

Ntok = listSGSRdata(FN, abs(iSeq), 'StimParams.Ntoken');
Ntok = Ntok(find(Ntok~=0));
if length(unique(Ntok))>1, error('unequal ntokens'); end
RS = listSGSRdata(FN, abs(iSeq), 'StimParams.Rseed');
RS = RS(find(RS~=0));
if length(unique(RS))>1, error('unequal random seeds'); end
Ntok = max(Ntok);
Y = 0;
for itok=1:Ntok,
   [XX, Freq, Sel, DC] = erevanalyze3(FN, iSeq, itok, binWidth);
   Y = Y + XX/Ntok;
end
Sel = Sel(2:end-2);
YY = Y(Sel);
Y = Y*0;
Y(Sel)=YY;
freq = Freq(Sel)/1e3;
pha = DelaY*freq;
YY = YY.*exp(2*pi*i*pha);
[maxGain, imaxGain] = max(abs(YY));

f1; 
%-----------------AMP/freq--------------------
subplot(2,2,1); hold on;
iDC = find(freq==DC/1e3);
fcar = freq(iDC);
amp = a2db(abs(YY));
amp(iDC) = NaN;
plot(freq, amp,plotArg);
%CL = find(abs(freq-fcar)<=1);
%plot(freq(CL), amp(CL),'linewidth',2);
% YL = ylim;
XL = xlim;
ylim([5*ceil(max(0.2*amp))+[-40 0]]);
xlim(XL)
[dum maxAmp] = max(amp); maxAmp = freq(maxAmp);
title(['file ' FN ' --- seqs ' trimspace(num2str(iSeq))])
% xlabel('Frequency (kHz)');
ylabel('Gain (dB)');
%-----------------PH/freq--------------------
subplot(2,2,3); hold on;
PH = angle(YY);
% PH(iDC) = nan;
PH = (1/2/pi)*unwrap([PH(1:iDC-1) PH(iDC+1:end)]);
PH = [PH(1:iDC-1) nan PH(iDC:end)];
% align phases at max gain
phaAtMax = PH(imaxGain);
deltaPha = ceil(phaAtMax)
if ~isnan(deltaPha),
   PH = PH - deltaPha; 
end
plot(freq, PH ,plotArg);
xlim(XL);
% title(['file ' FN ' --- seqs ' trimspace(num2str(iSeq))])
xlabel('Frequency (kHz)');
ylabel('Phase (cycles)')

%-----------------IMPULSE RESPONSE--------------------
NN = length(Y);
dt = 1/NN/(freq(2)-freq(1))
t = dt*(0:NN-1);
if isempty(tsel), tsel = 10; end;
tsel
tsel = find(t<tsel);
t = t(tsel);
impRes = ifft(fftshift((Y)));
% figure(2);
subplot(2,2,2); hold(HO);
absi = abs(impRes(tsel));
absi = absi/max(absi);
plot(t,absi,plotArg);
ylabel('Envelope of Impulse Response');


%-----------------INST FREQ IMP RESPONSE--------------------
[dum Lat] = max(absi); Lat = t(Lat);
subplot(2,2,4); hold(HO);
fcar
plot(0.5*dt+t(1:end-1),fcar+1e-3*diff((1e3/2/pi/dt)*unwrap(angle(impRes(tsel)))),plotArg);
ylim([fcar+ [-2 2]]);
xlabel('time (ms)');
ylabel('inst freq (kHz)');




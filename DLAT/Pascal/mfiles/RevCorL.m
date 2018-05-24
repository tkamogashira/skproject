function [ir, T, Gain_ir_hamming, Phase_ir_hamming, freq,samper,Nspike] = RevCorL(DS, isub, maxWin);

% REVCOR - RevCor analysis 
%  Syntax: [ir, time, Gain, Phase, freq] = RevCorL(filter, DS, isub, maxWin);
%       $DS$:          dataset
%       $isub$:        selectie van onafhankelijke variabele (welke rij van de dataset) -> welke stimulus
%       $maxWin$:      lengte in ms van de te berekenen impulsresponsie

try, UD = getuserdata(DS); %try-catch added by TF, 30/09/05, because error occurred when there is no user data present
if ~isempty(UD) & ~isnan(UD.CellInfo.THRSeq), 
    dsTHR = dataset(DS.filename, UD.CellInfo.THRSeq); 
    [CF, dummy, dummy, dummy, dummy] = evalTHR(dsTHR, 'plot', 'no');
else, 
    g = getCF4Cell(DS.filename, DS.id.iCell);
    CF = g.thr.cf;
end
catch,
    g = getCF4Cell(DS.filename, DS.id.iCell);
    CF = g.thr.cf;
end

%y=aangeboden stimulus
[y, samper] = StimSam(DS, isub);
Nwin = round(maxWin*1e3/samper); % ms->us->samples
Nsam = size(y,1);
Nchan = size(y,2);
%SPT=vector met tijdstippen waarop spikes optreden in de respons van de AN
SPT = DS.SPT;
SPT = cat(2,SPT{isub,:}).'; % spiketimes of requested subseq, pooled over reps
Nspike = length(SPT);

%construct binary spike signal @ correct sample rate
TimeEdges = (0:Nsam)*samper*1e-3; % binning edges in ms
spikes = histc(SPT, TimeEdges);

ir = [];
for ichan=1:Nchan,
    %deling door Nspike middelt uit over aantal keer dat stimulus is aangelegd en aantal 
    %spikes in 1 meting
    xc = xcorr(y(:,ichan), spikes, Nwin)/Nspike;
    xc = flipUD(xc);
    ir = xc; %ook de negatieve tijden van revcor worden meegenomen
    %ir = [ir xc((Nwin+1):end)]; %enkel positieve tijden van revcor worden meegenomen
end

%Hammingwindow=lengte van ir
hamming_filter=hamming(length(ir));
hamming_filter=(max(ir)/max(hamming_filter)).*hamming_filter;
ir_hamming=hamming_filter.*ir;

%constructie tijdsas bij bekomen RevCor (impulsresponsie)
M = size(ir((Nwin+1):end),1);
T = TimeEdges(1:M)';
T_neg = -(flipud(T));
T = [T_neg(1:(end-1)); T];

% compute spectrum waarbij beginnullen verwijderd zijn
indices=find(ir_hamming==0);
if(isempty(indices)==0),
   ir_hamming_adjusted=ir_hamming(min(indices):end);
else
   ir_hamming_adjusted=ir_hamming;
end
Spec_ir_hamming=fft(ir_hamming_adjusted,2^16);
Gain_ir_hamming=a2db(abs(Spec_ir_hamming));
%enkel positieve frequenties
Spec_ir_hamming=Spec_ir_hamming(1:ceil(length(Spec_ir_hamming)/2));
Gain_ir_hamming=Gain_ir_hamming(1:ceil(length(Gain_ir_hamming)/2));
freq=(0:length(Gain_ir_hamming)-1)*((1/(samper*10^-3))-1)/(2*(length(Gain_ir_hamming)));
%effDelay = cdelay+maxWin/2;
effDelay=maxWin/2;
Phase = delayphase(angle(Spec_ir_hamming)/2/pi, freq(:), effDelay, 2); % unwrap, advance and add int#cycles towards zero
Phase_ir_hamming = delayphase(angle(Spec_ir_hamming)/2/pi, freq(:), effDelay, 2); 
%normalisatie spectrum
max_gain=max(Gain_ir_hamming);
Gain_ir_hamming=Gain_ir_hamming-max_gain;
%%spectrum filter
Spec_filter=fft(hamming_filter,2^16);
Gain_filter=a2db(abs(Spec_filter));
%enkel positieve frequenties
Spec_filter=Spec_filter(1:ceil(length(Spec_filter)/2));
Gain_filter=Gain_filter(1:ceil(length(Gain_filter)/2));

%-------------------------------------
%plot
%-------------------------------------  
figure

%plot revcor and hamming filtering window
subplot(2,2,1), plot(T,ir),
hold 
subplot(2,2,1), plot(T,hamming_filter,'g:')
xlabel('ms')
ylabel('RevCor')
gegevens= strcat(DS.filename,'-',DS.seqid,' - CF = ',num2str(CF), ' Hz - SPL = ',num2str(DS.spl),' dB');
title(gegevens)

%plot windowed revcor
subplot(2,2,2),plot(T,ir_hamming)

%plot magnitude-frequency plot plus a vertical line on CF
subplot(2,2,3), semilogx(freq,Gain_ir_hamming);
hold 
ind=find(abs(freq-(CF)*10^(-3))<=0.01);
ind=ind(1);
subplot(2,2,3), line(freq([ind ind]),[max(Gain_ir_hamming)+10 min(Gain_ir_hamming)-10]);
%subplot(2,2,3), semilogx(freq,Gain_filter,'g')
axis([0 20 min(Gain_ir_hamming)-10 max(Gain_ir_hamming)+10]);
xlabel('kHz')
ylabel('dB')

%plot phase-frequency plot
subplot(2,2,4), semilogx(freq,Phase);
axis([0 20 min([min(Phase),min(Phase_ir_hamming)])-10 max([max(Phase),max(Phase_ir_hamming)])+10]);
hold 
subplot(2,2,4), semilogx(freq,Phase_ir_hamming)
xlabel('kHz')
ylabel('rad')
function [ir, T, Gain, Phase, freq] = RevCor(DS, isub, maxWin, Tav, plotArg, cdelay, maxFreq);
% REVCOR - RevCor analysis 
%  Syntax: [ir, time, Gain, Phase, freq] = RevCor(DS, isub, maxWin, Tav, compDelay, maxFreq);

% error under_construction

if nargin<3, maxWin = []; end;
if nargin<4, Tav=[]; end; 
if nargin<5, plotArg='-'; end; 
if nargin<6, cdelay=0; end; 
if nargin<7, maxFreq=5; end;  % 5 kHz max freq of spectrum
maxFreq
if isequal(0,isub), isub=1:DS.nsub; end

if isempty(maxWin), maxWin = 20; end; % width of time window in ms
if isempty(Tav), Tav=0; end; % running-average window

if length(isub)>1,
   for ii=1:length(isub),
      RevCor(DS, isub(ii), maxWin, Tav, ploco(ii));
   end
   title([DS.title ', ' DS.xshortname '=[' num2sstr(DS.xval(isub)) '] ' DS.xunit]);
   return;
end
maxWin

[y, samper] = StimSam(DS, isub);
Nwin = round(maxWin*1e3/samper); % ms->us->samples
Nav = round(Tav*1e3/samper); % ms->us->samples
Nsam = size(y,1);
Nchan = size(y,2);
SPT = DS.SPT;
SPT = cat(2,SPT{isub,:}).'; % spiketimes of requested subseq, pooled over reps
Nspike = length(SPT);
% construct binary spike signal @ correct sample rate
TimeEdges = (0:Nsam)*samper*1e-3; % binning edges in ms
spikes = histc(SPT, TimeEdges);
% plot(TimeEdges, spikes); pause;
ir = [];
%NW2 = round(Nwin/2);
for ichan=1:Nchan,
   xc = xcorr(y(:,ichan), spikes, Nwin)/Nspike;
   xc = flipUD(xc);
   xc = runAv(xc,Nav);
   % xc = [zeros(30,1); xc(1:end-30)];
   ir = [ir xc((Nwin+1):end)];
end
M = size(ir,1);
T = TimeEdges(1:M)';% - maxWin/2;

if nargout>2, % compute spectrum
   Dur = max(T)-min(T) + diff(T(1:2)); % duration of impulse response in ms
   DF = 1/Dur; % freq spacing in kHz
   NsamPlot = floor(maxFreq/DF);
   for ichan=1:size(ir,2), Spec(:,ichan) = ir(:,ichan).*hann(size(ir,1)); end
   Spec = fft(Spec); Spec = Spec(1:NsamPlot); % pos freqs only
   Gain = a2db(abs(Spec)); Gain = Gain-max(Gain);
   freq = (0:NsamPlot-1)*DF;
   % dsiz(Spec, freq)
   effDelay = cdelay+maxWin/2;
   Phase = delayphase(angle(Spec)/2/pi, freq(:), effDelay, 2); % unwrap, advance and add int#cycles towards zero
end

if (nargout<1) | (nargin>4), 
   xplot(T, ir, plotArg);
   figure(gcf);
   xlabel('Time (ms)');
   ylabel('RevCor');
   xval = DS.xval(isub);
   title([DS.title ', ' DS.xshortname '=' num2sstr(xval) ' ' DS.xunit, ...
         '  ---  Nspike = ' num2str(Nspike)]);
end

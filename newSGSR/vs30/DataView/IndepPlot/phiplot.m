function phiplot(freq, phase, cdelay, iSig, plotArg, Offset);
% phiplot - generic phase plot function
%   phplot(Freq, Phase, Cdelay) 
%   phase vs freq in Hz after compensating
%   for a given delay of Cdelay ms.
%   Freq in Hz; 
%   Phase is given as lag in radians, but plotted as
%   lead in cycles.

if nargin<4, iSig = NaN; end
if nargin<5, clf; plotArg = 'b'; end % new plot
if nargin<6, Offset = 0; end;
   
if iscell(freq), % recursive multiple call
   clf;
   for ii=1:length(freq),
      isis = iSig; 
      if iscell(isis), isis = isis{ii}; end
      ioff = Offset;
      if iscell(ioff), ioff = ioff{ii}; end
      phiplot(freq{ii}, phase{ii}, cdelay, isis, ploco(ii), ioff);
   end
   return;
end

if ~iscell(iSig),
   if isnan(iSig), iSig = 1:length(freq); end
end

%---------single curve from here---------
[freq, phase, iSig] = deal(freq(:), phase(:), iSig(:));
if ~isempty(iSig),
   phase = unwrap(-phase+2*pi*freq*1e-3*cdelay)/2/pi;
   [phase, freq] = deal(phase(iSig), freq(iSig));
   phase = phase-round(phase(1))+Offset;
   try,xplot(freq, phase, ['-o' plotArg],  'markerfacecolor', plotArg);
   catch,xplot(freq, phase, plotArg);
   end
else,
   phase = unwrap(-phase+2*pi*freq*1e-3*cdelay)/2/pi;
   phase = phase-round(mean(phase))+Offset;
   xplot(freq, phase, ['-o' plotArg], 'markerfacecolor', 'auto');
end
xlabel('Frequency (Hz)');
ylabel('Phase lead (cycle)');







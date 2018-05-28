function y = PlotPostStimHist(Nbin);
global SMS SPIKES
persistent NB
if ~isempty(NB) & nargin<1,
   Nbin = NB;
elseif nargin<1,
   Nbin = -1; % 1-ms binwidth
end
NB = Nbin;

% collect spike times and various info
SpikeInfo = CollectSpikeTimes(SMS,SPIKES);
Nsubseq = SpikeInfo.Header.Nsubseq;
NsubseqR = SpikeInfo.Header.NsubseqRecorded;
NsubseqR = SpikeInfo.Header.NsubseqRecorded;
PlayOrder = SpikeInfo.Header.PlayOrder;
repDur = SpikeInfo.Header.repDur;
VarUnit = SpikeInfo.Header.varUnit;
% determine subplot layout
[Nx, Ny, PlotCoord] = factorsForSubPlot(Nsubseq);

WAITforFIG = 0;
figh = findobj('tag','HistPlotMenu');
if isempty(figh), figh=NaN; end; % avoid empty ifs
if ~ishandle(figh), % open new figure
   hh = openuimenu('HistPlot');
   figh = hh.Root;
   closeStimMenu(figh); % add as stimmenu-dependent window
   DeclareMenuDefaults('HistPlot','Root:position');
   WAITforFIG = 1;
else,
   figure(figh);
end

minX = 0;
maxX = max(repDur);
minY = 0;
maxY = -inf;
% negative # bins means minus binwidth in ms
if Nbin<0,
   Nbin = round(-maxX/Nbin);
   if Nbin<2, Nbin=2; end;
end
Sinfo = SpikeInfo.Header.SessionInfo;
[PP NN] = fileparts(Sinfo.dataFile);
iseq = Sinfo.iSeq-1;
Stype = Sinfo.CurrentStimMenu;
binedges = linspace(0,maxX,Nbin+1);
DE = binedges(2)-binedges(1);
Name = ['HISTplot  --- file ' upper(NN) ...
      ' ---  seq ' num2str(iseq) ' (' Stype ') --- bin width: ' ...
      num2str(DE) ' ms'];
set(figh,'name',Name);

% now start collecting spike times and plot
for ii = 1:Nx*Ny, % ii counts in order of presentation
   if ii<=Nsubseq, % this is existing condition - generate subplot in any case
      isubseq = PlayOrder(ii); % isubseq counts in order of SMS storage (natural order)
      spikes = SpikeInfo.SpikeTimes.SubSeq{ii};
      idpv = spikes.IndependentVariable;
      plotvar = spikes.PlotVariable;
      subplot(Ny,Nx,isubseq);
      if (ii<=NsubseqR), % recording of this subseq is complete; plot its histogram
         st = [];
         for irep=1:length(spikes.Rep),
            st = [st spikes.Rep{irep}];
         end
         if length(st)>0, % avoid crash of bar due to empty data
            NN = histc(st,binedges); 
            bar(binedges+DE/2,NN,'histc'); % the +DE/2 is to fix matlab bug with bar/histc
            Xlim = get(gca,'Xlim');
            Ylim = get(gca,'Ylim');
            maxY = max(maxY,Ylim(2));
         end
      end
      title([num2str(plotvar,4) ' ' VarUnit  ' (' num2str(ii) ')']);
   end % if isubseq<=Nsubseq
end
% standardize plotlimits, etc, add ticklabels at left and bottom most subplots only
for ii = 1:Nx*Ny,
   subplot(Ny,Nx,ii);
   set(gca,'XLim',[minX 1.01*maxX]);
   if isinf(maxY), maxY = 1; end; % can happen if all histograms are empty
   set(gca,'YLim',[minY maxY]);
   xx = PlotCoord(ii,1);
   yy = PlotCoord(ii,2);
   if isequal(xx,1), 
      ylabel('# spikes');
   else,
      set(gca, 'Ytick', []); 
   end;
   if isequal(yy,Ny), 
      xlabel('time (ms)');
   else,
      set(gca, 'Xtick', []); 
   end;
end

if WAITforFIG, waitfor(figh); end;




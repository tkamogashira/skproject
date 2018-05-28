function [figh, ds, params, ymax, ilegend, Th] ...
   = dataplotHist(histdat, figh, caller, XlabelStr, showburst, subLine)
% dataplotHist - setup and draw standard histogram dataplot

if nargin<5, showburst=0; end;
if nargin<6, subLine = {}; end; % if supplied, subLines are ordered like histdat.hist

figh = openDataPlot(figh, 'PSTplot', caller);

% abbreviations
params = histdat.params;
ds = histdat.DSinfo; % dataset w/o data

% setup the graph and plot
Nplot = length(histdat.hist);
POS = get(figh,'position'); XoverY = POS(3)/POS(4);
[Ny, Nx, PC] = factorsforsubplot(1+Nplot, XoverY);
ilegend = {Nx, Ny, Nplot+1}; % subplot "coordinates" of legend
% Y-limits
if isequal('Spikes', params.Yunit), 
   MaxN = max([histdat.hist.N]); 
   grandYmax = MaxN; 
   YUnitStr = 'Spike count';
elseif isequal('Spikes/rep', params.Yunit), 
   MaxNperRep = max([histdat.hist.NperRep]); 
   grandYmax = MaxNperRep; 
   YUnitStr = 'Spikes/rep ';
elseif isequal('Rate', params.Yunit), 
   MaxRate = max([histdat.hist.Rate]);
   grandYmax = MaxRate; 
   YUnitStr = 'Spikes/s ';
else error(['unknown Yunit value ''' params.Yunit '''']);
end
if isequal('auto', params.Ymax),
   fac = getFieldOrDef(params, 'YmaxFactor', 1.1);
   ymax = fac*grandYmax;
else
   ymax = params.Ymax; 
end;
if ~(ymax>0), ymax = 1; end % avoid trivial fuss due to empty histograms
xvalstr = words2cell(num2sstr(ds.xval)); % all in once -> restrict dynamix range (see num2sstr)
displayIsub = ~(all(diff(histdat.iSub)==1)); % display isub only when non standard order
for iplot=1:Nplot,
   isub=histdat.iSub(iplot); % disinguish i-th sequence measured and i-th seq plotted
   subplot(Nx, Ny, iplot);
   set(gca,'nextplot','add');
   Histo = histdat.hist(iplot); 
   if showburst, % draw vertical grey line(s) indicating burst durations
      bd = ds.burstdur;
      bd = bd(min(end,iplot));
      line([1;1]*(bd),ymax*[0 0;1 1], 'color', 0.8*[1 1 1],'linewidth',2);
   end % note: do this before adding data and text, so that they overwrite the grey line
   X = Histo.Edges(2:end)-0.5*Histo.binwidth; % bin centers
   if isequal('Spikes', params.Yunit), Y = Histo.N;
   elseif isequal('Spikes/rep', params.Yunit), Y = Histo.NperRep;
   elseif isequal('Rate', params.Yunit), Y = Histo.Rate;
   end
   bh = bar(X, Y,'histc'); bc = 0.5*[1 0.9 1.1];
   set(bh,'facecolor', bc, 'edgecolor', bc);
   xlim([histdat.xlim]); ylim([0 ymax]);
   % a title within the axes
   if displayIsub, isubstr = [' [' num2str(isub) ']']; else isubstr = ''; end;
   HeadLine = [xvalstr{isub} ' ' ds.xunit isubstr];
   if ~isempty(subLine),
      SL = subLine{iplot};
      for iline = 1:size(SL,1),
         ll = trimspace(SL(iline,:));
         if isequal('?', ll(1)), HeadLine = [HeadLine ' ' ll(2:end)];
         else HeadLine = strvcat(HeadLine, ll);
         end
      end
   end
   th = text(0, 0, HeadLine, ...
      'units', 'normalized', 'position', [0.5 1], ...
      'horizontalalign', 'center', ...
      'verticalalign', 'top', ...
      'fontsize', 8);
   if PC(iplot,2)==Nx, xlabel(XlabelStr); end;
   if PC(iplot,1)==1, ylabel(YUnitStr); end;
end
% title
subplot(Nx, Ny, 1); % upper/left
bd = ds.burstdur;
if (length(bd)>1) && (diff(bd)==0), bd = bd(1); end;
titstr = [ds.title ' --- ' ds.pres ' --- varied ' ds.xshortname, ...
      ' --- burst: ' num2sstr(bd) ' ms'];
Th = title(titstr, 'units', 'normalized', 'horizontalAlignment', 'left');
oldpos = get(Th,'position'); set(Th,'position', [-0.25 oldpos(2)]);
% legend
subplot(ilegend{:});
fcol = get(figh,'color');
set(gca,'xcolor', 0.9*fcol, 'ycolor', 0.9*fcol);
set(gca, 'box', 'on', 'color', 0.9*[1 1 1], 'xtick', [],  'ytick', []);

% make plotted data available from MatLab commandline
DVcomp(histdat);

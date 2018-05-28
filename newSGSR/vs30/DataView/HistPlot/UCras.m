function figh = UCras(ds, iSub);
% UCRAS - RASTER PLOT
persistent UCrasParam

if nargin<2, iSub=0; end % zero means all subseqs
iSub = iSub(:)'; % must be row vector for use in for loop

if isequal('THR', ds.stimtype), figh= []; return; end

hh = openUImenu('rasterPlot'); 
figh = hh.Root;
repositionFig(figh);
set(figh, 'closereq', 'SaveMenuDefaults(''rasterPlot'', '''', 1); delete(gcf);');
axh = gca;
xlabel('Time (ms)');
ylabel(ds.xlabel);
title([ds.title '   (' ds.pres   ')']);
set(gcf, 'name', ['Raster --- ' ds.title]);
if isequal(0,iSub), % all subs
   iSub = 1:ds.nrec;
end
[minsub, maxsub]= deal(min(iSub), max(iSub));

set(axh, 'xlim', [0 max(ds.repdur)], ...
   'ylim', [minsub-0.5 maxsub+0.5], ...
   'YTick', 1:ds.Nsub, ...
   'YTicklabel', eval(['{' num2sstr(ds.xval)  '}']), ...
   'nextplot', 'add' ...
   );

% draw gray line to indicate end of burst (if applicable)
% do it first or else it might mask spikes
burstdur = unique(ds.burstdur);
for bd = burstdur(:)';
   plot(bd*[1 1], ylim, 'color', 0.85*[1 1 1], 'linewidth', 2);
end

% plot spikes
SPT = ds.spt; % might speed up dereferencing
Nrep = min(ds.nrep);
ico = 0; % color index
for isub=iSub,
   X = []; Y = [];
   ico = ico+1;
   yy = linspace(isub-0.4,isub+0.4,Nrep+1);
   for irep=1:Nrep,
      nsp = length(SPT{isub,irep});
      if nsp>0,
         x = SPT{isub,irep};
         X = [X vectorzip(x,x,x+nan)];
         y1 = yy(irep)+0*x; % same size as x
         y2 = yy(irep+1)+0*x; % same size as x
         Y = [Y , vectorzip(y1, y2, y2)];
      end
      Nspike(isub) = numel([SPT{isub,:}]);
   end
   plot(X,Y,ploco(ico));
end
% fake axes for spike counts
FA.YTicklabel = eval(['{' num2sstr(Nspike)  '}']);
FA.position = get(axh,'position');
[FA.ylim, FA.ytick FA.xtick] = deal(get(axh, 'ylim'), get(axh, 'ytick'), []); 
FA.yaxislocation = 'right';
axes(FA);
ylabel('Spike Count')
% bring true axes to the front again
axes(axh);







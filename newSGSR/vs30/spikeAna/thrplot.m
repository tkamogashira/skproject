function [report, figh] = thrplot(varargin);
% THRPLOT - plot thr curve from SGSR datafile
%   usage: thrplot('A0304', 426) or thrplot('A0304', '50-1')
%   multiple plots: thrplot('A0304', [32 33 36 37 38])
%   returns brief report.
%   all args: [report, figh] = thrplot(DF, seq, plotArg)
%   plotArg = 'noplot' suppresses plotting.
%   
%   see also THRLIST.

if nargin>2,
   plotArg = varargin{3};
else, % open new figure
   plotArg = '';
   figh = figure;
   if isequal('OTO',compuname),
      set(gcf,'position',[187   252   448   300]);
   end
   % figh = openDataPlot(nan, 'thrplot', 'nop', 'ucrate'); % abuse ucrate switchboard for uimenus
end

if nargin==0,
   global SESSION
   [dum, df] = fileparts(SESSION.dataFile);
   iSeq = SESSION.SGSRSeqIndex-1;
   DS = dataset(df, iSeq);
   if ~isequal('THR', DS.stimtype),
      icell = DS.icell;
      DS = dataset(df, [num2str(icell) '-1']);
   end
elseif nargin==1,
   DS = varargin{1};
else,
   df = varargin{1};
   iSeq = varargin{2};
   multCall = (length(iSeq)>1) & (isnumeric(iSeq) | (iscellstr(iSeq)));
   if multCall,
      for ii=1:length(iSeq),
         if isempty(plotArg), pla = ploco(ii); else, pla = plotArg; end
         if iscellstr(iSeq), iseq = iSeq{ii}; else iseq = iSeq(ii); end;
         report{ii} = thrplot(df, iseq, pla, 'kHz');
      end
      return
   end
   DS = dataset(df, iSeq);
end

if nargin<4,
   XU = '';
else,
   XU = varargin{4};
end

if ~isequal(DS.stimtype,'THR'),
   error('non-THR data');
end


% get data
freq = DS.otherdata.thrCurve.freq;
thr = DS.otherdata.thrCurve.threshold;
% spont rate
NN = length(DS.spt); % # virtual bursts in silent interval
SPT = DS.spt; Nspike = length(cat(2,SPT{1,:}));
SpontRate = Nspike/(NN*DS.burstdur*1e-3);


if max(freq>1000) | isequal('kHz',XU),
   freq = freq/1000;
   xu = 'kHz';
else,
   xu = 'Hz';
end

% find minimum thr
[mint, ii] = min(thr);
minf = freq(ii);

%=======PLOT===========================
doplot = ~isequal('noplot', lower(plotArg));
if doplot,
   figh = gcf;
   set(gcf,'PaperOrientation', 'landscape');
   set(gcf, 'PaperPosition', [1 1.5 8 6]);
   if atBigScreen, set(gcf, 'position', [202   275   448   300]); end;
   if max(freq)/min(freq)>5,
      if isequal(plotArg, 'n'), plotArg=''; end;
      hold on; semilogx(freq,thr,['o-' plotArg]); hold off;
   else,
      xplot(freq,thr,['o-' plotArg]);
   end
   YL = ylim;
   ylim([min(YL(1), DS.minSPL), max(YL(2), DS.SPL)]);
   xlabel(['Frequency (' xu  ')']);
   ylabel('Threshold (dB SPL)');
   set(gca,'position', [0.13 0.13 0.75 0.71])
   % mark minimum thr
   hold on;
   xplot(minf,mint,'*r');
end

IDstr = [DS.title ' (' num2str(DS.iSeq) ') '];
mint = 0.1*round(10*mint);
minf = 0.001*round(1000*minf);
CFstr = [num2str(mint) ' dB SPL @ ' num2str(minf,3) ' ' xu '  SR = ' num2str(SpontRate,3) ' sp/s'];
if doplot, title(strvcat(IDstr, CFstr)); end;
report = ['% ' num2str(DS.iseq) ' --- cell ' num2str(DS.icell) ' -- ' CFstr '   <' DS.SeqID '>'];

% store data in plot
if doplot,
   % StoreInDataPlot(figh, emptydataset(ds), params, plotter);
end


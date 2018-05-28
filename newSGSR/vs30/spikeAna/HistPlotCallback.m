function y=HistPlotCallback;
TAG = get(gcbo,'Tag');

switch TAG
case 'NbinMenuItem'
   NbinStr = inputdlg('Number of bins:');
   if isempty(NbinStr), return; end;
   Nbin = str2num(NbinStr{1});
   if isempty(Nbin), return; end;
   Nbin = round(abs(Nbin(1)));
   if Nbin>0,
      plotPostStimHist(Nbin);
   end
case 'BinWidthMenuItem'
   NbinStr = inputdlg('Bin width in ms:');
   if isempty(NbinStr), return; end;
   Nbin = str2num(NbinStr{1});
   if isempty(Nbin), return; end;
   Nbin = -(abs(Nbin(1)));
   if Nbin<0,
      plotPostStimHist(Nbin);
   end
otherwise
   disp(['unknown callback object ' TAG]);
end


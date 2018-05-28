function DFinfo = ParseLogFile(FN, force)
% ParseLogFile - parse log file of experimental data.

if nargin<2
    force=0; 
end

% find log file and look if previous call was identical
FFN = FullFileName(FN, bdatadir,'.log', 'Log file');
LogFileInfo = dir(FFN);
DFinfo = FromCacheFile(mfilename, LogFileInfo);
if ~isempty(DFinfo) && ~force, return; end

[StartDate, Seqs, Nseq] = localReadLog(FFN);

DFinfo = CollectInStruct(FN, LogFileInfo, StartDate, Nseq, Seqs);
ToCachefile(mfilename, 1e3, LogFileInfo, DFinfo); % speed up next call


%--------------------------------
% read relevant lines of log file into cell array
function [StartDate, Seqs, Nseq] = localReadLog(FFN)
[StartDate, Seqs, Nseq] = deal('Started @: 11 12 1962 0 0 0', [], 0);
fid = fopen(FFN);
StartDate = '';
Nseq = 0; Seqs = emptystruct('iseq', 'ID');
while 1,
   line = trimspace(fgetl(fid));
   if ~isstr(line), break, end
   if isempty(StartDate),
      if findstr('Started @', line),
         StartDate = line;
         break;
      end
   end
end
fclose(fid);
LUT = log2lut(FFN);
Nseq = length(LUT);
if Nseq==0, 
   Seqs = emptyStruct('iseq', 'ID'); 
else
   [Seqs(1:Nseq).iseq] = deal(LUT(1:Nseq).iSeqStr);
   [Seqs(1:Nseq).ID] = deal(LUT(1:Nseq).IDstr);
   [Seqs(1:Nseq).iseq] = deal(LUT(1:Nseq).iSeqStr); % matlab bug?!
end;




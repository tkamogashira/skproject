function [d, FN] = GetSGSRdata(FN, iSeq)
% GetSGSRdata - retrieve data from .SGSR data file

if nargin<1
    FN = '';
end
if nargin<2
    iSeq = inf;
end % last one

if isempty(FN)
    FN = dataFile;
elseif isequal(FN,'?')
   [FN FP] = uigetfile([datadir '\*.sgsr']);
   if isequal(0,FN)
       return
   end
   FN = [FP FN];
end

if ischar(iSeq)
   [iSeq, IsIDF] = id2iseq(FN, iSeq, 'useLut'); 
   if IsIDF
       error('Data are not in SGSR format');
   end
end

FN = FullFileName(FN, dataDir, 'SGSR', 'SGSR data file');

if StrEndsWith(FN, 'C0305subset.SGSR')
    iseqOffset = 436;
else
    iseqOffset=0;
end

dd = load(FN, 'Directory','-mat');
dd = dd.Directory;


if isequal(lower(iSeq),'nseq') % return #seqs
   d = dd.Nseq;
   return
end

if isinf(iSeq)
    iSeq = dd.Nseq;
end
sn = dd.SeqNames{iSeq-iseqOffset}; % name of the sequence
dd = load(FN, sn,'-mat');
d = dd.(sn);
try % to decode spike times
   if isstruct(d.SpikeTimes.spikes.Buffer)
      d.SpikeTimes.spikes.Buffer ...
         = DecodeSpikeTimes(d.SpikeTimes.spikes.Buffer);
   end
catch
    warning('Unable to decode spike times');
end

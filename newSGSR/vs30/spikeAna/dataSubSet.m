function [dd, FN] = dataSubSet(FN, FNselect, iSeq);
% DataSubSet - generate dataset containing subselection of sequences
%   usage: dataSubSet(ExpName, SubSetName, Sequences)
%   example:
%    dataSubSet('C0305', 'C0305selectA', [34:78 80 84])



FN = fullFileName(FN, datadir, 'SGSR', 'SGSR data file');
FNselect = fullFileName(FNselect, datadir, 'SGSR');

if isequal(lower(FN), lower(FNselect)), 
   error('Filename of selection must be different from original datafilename');
end

load(FN, 'Directory','-mat');

newDirectory.newNseq = length(iSeq);
for ii=1:newDirectory.newNseq,
   iseq = iSeq(ii);
   sn = Directory.SeqNames{iseq};
   newDirectory.SeqNames{ii} = Directory.SeqNames{iseq};
   load(FN, sn,'-mat');
end

Directory = newDirectory;
save(FNselect, 'iSeq', 'Directory', Directory.SeqNames{:}, '-mat');





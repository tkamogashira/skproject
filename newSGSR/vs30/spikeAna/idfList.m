function [y, st]=IDFlist(FN, iSeq);
% IDFlist - list stimtypes of IDF

if nargin<2, iSeq=0; end;

IDF = idfread(FN);

Nseq = length(IDF.sequence);
if isequal(iSeq,0), iSeq = 1:Nseq;
elseif isinf(iSeq), iSeq = Nseq;
end

y = '';
for iseq=iSeq(:)',
   idfseq = IDF.sequence{iseq};
   stimtype = idfstimname(idfseq.stimcntrl.stimtype);
   st{iseq} = stimtype;
   y = strvcat(y, [num2str(iseq) ': '  stimtype]);
end

function [idf, ID, uetvar, SPT] = getSPKdata(FN, iseq);
% getSPKdata - get data from IDF/SPK files using flexible indexing

if nargin<1, FN =''; end;
if nargin<2, iseq = inf; end;

if isempty(FN), 
   FN = datafile;
elseif isnumeric(FN),
   FN = PDPtestSetName(FN);
end

if ischar(iseq),
   [iseq, PDP11] = id2iseq(FN, iseq,1);
   if ~PDP11, error('Not a PDP11-compatible dataset.'); end
   ID = [' <' id2iseq '>'];
else,
   ID = '';
end

idf = idfread(FN);
if isinf(iseq),
   iseq = length(idf.sequence);
end

ID = ['Seq: ' num2str(iseq) ID];

[PP NN] = fileparts(FN);
ID = ['File ' upper(NN) ' --- ' ID];


% read IDF, SPK, UETVAR
idf = idf.sequence{iseq};
if nargout<3, return; end
SPT = spkextractseq(FN, iseq);
uetvar=cat(1,SPT.subseqInfo{:});
uetvar = cat(1,uetvar.var1);
SPT = SPT.spikeTime;
limchan = idf.stimcntrl.limitchan;
if limchan>0,
   uetvar = uetvar(:,idf.stimcntrl.limitchan);
else
   TakeRite = std(uetvar(:,1))<std(uetvar(:,2));
   uetvar = uetvar(:,TakeRite+1);
end


function spkPlot(FN, iSeq, varargin);
% SPKplot - quick & dirty plotting function for selection of IDF-style data

if ischar(iSeq),
   [iSeq, isPDP] = id2iseq(FN, iSeq, 1); % last arg: remember iSeq char
   if ~isPDP,
      SGSRplot(FN, iSeq);
      return;
   end
end
idf = IDFget(FN, iSeq);
st = idf.stimcntrl.stimtype;
switch st,
case {0,13}, % fs fslog
   fsplot(FN, iSeq, varargin{:});
case {2,25,27}, % spl, nspl cspl
   splplot(FN, iSeq, varargin{:});
otherwise,
   warning(['Plot for ' upper(idfstimname(st)) ' data not yet implemented']);
end



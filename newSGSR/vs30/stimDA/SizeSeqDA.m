function Nsamp = SizeSeqDA(DBN);

% debugging function: # samples stored in DAMA at DNB for seqplay

if nargin<2, NoPlot=0; end;
chanList = dama2ml(DBN);

Nsamp = [0 0];
for ichan = 1:(length(chanList)-1),
   seqDBN = chanList(ichan);
   seq = dama2ml(seqDBN); % actual list
   nDBN = round((length(seq)-1)./2); % # DBNs
   for iDBN=1:nDBN,
      LL = length(dama2ml(seq(2*iDBN-1)));
      rep = seq(2*iDBN);
      Nsamp(ichan) = Nsamp(ichan) + rep*LL;
   end
end





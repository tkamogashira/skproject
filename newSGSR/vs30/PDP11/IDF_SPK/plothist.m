function plothist(fname, seq, isub, fignum)

spk = spkget(fname,seq);

st = spk.spikeTime;

nreps = size(st,2);
ST = [];
for ii=1:nreps
   ST = [ST st{isub,ii}];
end
if nargin<4
   fignum =1;
end

figure(fignum);
hist(ST,50);

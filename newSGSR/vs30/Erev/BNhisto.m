function [CHS, CHist] = BNhisto(FN, iSeq, CacheFileName);
% BNHISTO - computes specific cycle histogram of BN data and its spectrum
%   syntax: [CHS, CHist] = BNhisto(FN, iSeq, CacheFileName);
%   iSeq may be vector, in which case spikes are pooled across sequences.
global DEBUGbnDL

if nargin<3, 
   CacheFileName=''; 
end

if length(iSeq)>1, % recursive call; pool spike times and add histogram data
   for ii = 1:length(iSeq),
      [chs, chist] = BNhisto(FN, iSeq(ii), CacheFileName);
      if (ii==1), 
         CHS = chs;
         CHist = chist;
         CHS.BN = {CHS.BN}; 
      else,
         CHS.CHspec = CHS.CHspec + chs.CHspec;
         CHS.Nspike = CHS.Nspike + chs.Nspike;
         CHS.BN{ii}   = chs.BN;
         parc = StructComp(CHS.BN{ii-1}.pp, chs.BN.pp, 'TotDur');
         if ~isempty(parc), 
            idstr = ['iseq=' num2str(iSeq(ii))];
            warning([idstr ' pooling BN data having different params:']); 
         end;
         disp(parc);
         CHist = CHist + chist;
      end
   end
   return;
end

% single iSeq from here
FakeRun = 0;
if isequal(CacheFileName, 'ENVL') | isequal(CacheFileName, 'ENVR'),
   EnvChan = channelnum(CacheFileName(4));
   CacheFileName = '';
   FakeRun = 1; % no data, but stimulus envelope
end;


CacheParam = collectInStruct(FN,iSeq,DEBUGbnDL); % unique identifier
qqq = FromCacheFile(CacheFileName, CacheParam);
if ~isempty(qqq),
   eval(DealStructCommandStr(qqq)); % unpack outargs
   return;
end

% read data
ds = dataset(FN, iSeq);
if ~isequal(ds.stimtype,'BN'),
   error(['Seq ' num2str(iSeq) ' is not a BN stimulus']);
end
% reconstruct stimulus
global SGSR; origFsam = SGSR.samFreqs;
SGSR.samFreqs = ds.recordparams.samFreqs;
BN = prepareBNstim(ds.spar);
if FakeRun, % need envelope of stimulus as fake response
   Env = abs([BN.CWaveL(:) BN.CWaveR(:)]);
   Env = Env(:,EnvChan);
end
% remove byte-consuming parts of BN - parameters are all we need
BN = rmfield(BN,{ 'SpecL', 'SpecR', 'CWaveL', 'CWaveR'});
% restore original sample rates
SGSR.samFreqs = origFsam;
% compute cycle histogram 
isub = 1; % first subsequence by definition
try,
   ni = BN.pp.NoiseEar;
   if (ni==1) isub = 2; end
end
Tcyc = 1e3/BN.DDfreq(1); % exact stimulus period in ms
Ncyc = BN.Ncyc(isub); Ncomp = BN.pp.Ncomp;
DT = 1e3/BN.Fsam(1); % sample period in ms for histogram

if FakeRun, % take envelope of stimulus as fake response
   CHist = Env.^1;
   if ~isempty(DEBUGbnDL),
      Nsh = round(DEBUGbnDL/DT)
      CHist = [CHist(end-Nsh+1:end); CHist(1:end-Nsh)];
   end
else,  % compte cycle histogram
   spt = ds.spt{1,1}-Tcyc; % spikes before end of risetime will be negative
   spt = spt(find(spt>0)); % ignore rise time
   spt = spt(find(spt<=Ncyc*Tcyc)); % ignore fall time and beyond
   spt = rem(spt,Tcyc); % wrap around Tcyc
   Edges = (0:BN.NsamCyc(isub))*DT;
   CHist = histc(spt,Edges);
   if isempty(CHist), CHist = Edges*0; end; % no spikes -> histc is empty - shouldn't be
   CHist(end) = []; % remove final garbage bin (see help histc)
end

% Fourier analysis of cycle histogram
CHspec = length(CHist)*ifft(CHist);
if FakeRun, Nspike = 1e6;
else, Nspike = CHspec(1);
end
iCell = ds.icell;
% CHspec(1) = abs(CHspec(2));
Nfreq = min(round(length(CHspec)/2), 1+round(8*Tcyc)); %
CHspec = CHspec(1:Nfreq); % neg freqs and freqs>8 kHz not interesting
CHS = CollectInStruct(CHspec, Nspike, Nfreq, BN, iCell);
% store in cache file
Ncache = 400; if atsikio | atkiwi | atoto, Ncache = 1000; end
ToCacheFile(CacheFileName, Ncache, CacheParam, collectInStruct(CHS, CHist));


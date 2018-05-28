function TCPinstr = qtestIntr(isd, Nrep, MaxSpikeRate);
% test function for TCplay 
% isd is inter-stimulus duration

% assuming there is a correct SD from some stimmnu
global SD SGSR

if nargin<3, MaxSpikeRate = 300; end % in Hz

% prepare silence buffer(s)
SilenceDBNs = zeros(length(SGSR.samFreqs), 2);
Nsub = length(SD.subseq);
PL = cell(Nsub,2); % temporary play list
maxLenList = -inf;
for isub=1:Nsub,
   SS = SD.subseq{isub};
   ipo = SS.ipool;
   DD = cell(1,2);
   maxNdbn = -inf;
   chanUsed = find(ipo>0);
   for ichan=chanUsed,
      if ipo(ichan)>0, 
         DD{ichan} = SD.waveform{ipo(ichan)}.DAdata;
         ifilt = DD{ichan}.filterIndex ;
         SamP = DD{ichan}.samP;
         maxNdbn = max(maxNdbn, length(DD{ichan}.bufDBNs));
         % silence buffer
         Nsil = round(isd*1e3/SamP);
         if SilenceDBNs(ifilt, ichan)==0, % allocate it
            SilenceDBNs(ifilt, ichan) = ML2dama(zeros(1,Nsil));
         end
         DBNsil(ichan) = SilenceDBNs(ifilt, ichan);
      end
   end
   synchChan = min(chanUsed);
   chanList = []; Nplay = [];
   % now collect relevant info for D/A
   for ichan=chanUsed,
      dbn = [DD{ichan}.bufDBNs(:)'  DBNsil(ichan)];
      rep = [DD{ichan}.bufReps(:)' 1];
      % insert silence dbns
      dbn = repmat(dbn,1, Nrep);
      rep = repmat(rep,1, Nrep);
      % remove last silence
      dbn(end) = []; rep(end) = [];
      % include sync&switch and zip
      % [playList{ichan} Nsync Nswitch] = ...
      [PL{isub, ichan} Nsync Nswitch] = ...
         synchedList(dbn, rep, ifilt, ichan, ichan==synchChan);
      maxLenList = max(maxLenList, length(PL{isub, ichan}));
      Nburst(ichan) = DD{ichan}.Nplay-DD{ichan}.Nrepsil;
      Nplay = [Nplay, Nsync + Nswitch + Nrep*Nburst(ichan) + (Nrep-1)*Nsil];
      chanList = [];
   end
   Nplay = unique(Nplay);
   if ~isequal(Nplay,Nplay(1)),
      error('unequal #samples in the two channels ?!?');
   end
   % collect info
   Nburst = Nburst(synchChan);
   RecTiming = collectInStruct(Nrep, SamP, Nsync, Nswitch, Nburst, Nsil, MaxSpikeRate);
   chanDBN = [];
   DBNtone = DD{synchChan}.bufDBNs(:)';
   DBNsil;
   Hardware = hardwareInstr4DA(SS.DAmode, ifilt, Nplay, SamP);
   StartAtt = [40 40];
   StepAtt = [1.5 1.5];
   playList = []; PlayListDBN = []; % will be filled below
   % store in struct
   TCPinstr(isub) = collectInStruct(chanDBN, DBNsil, DBNtone, playList, PlayListDBN, ...
      synchChan, Hardware, RecTiming, StartAtt, StepAtt);
end

% allocate 2 dama buffers long enough to hold longest seq list ..
% .. and a small one to hold their DBNs
PlayListDBN = [ml2dama(zeros(1,maxLenList+1)), ...
      ml2dama(zeros(1,maxLenList+1)), 0]
chanDBN = ml2dama(PlayListDBN)
% revisit all subseqs to reset  playList and to set chanDBNs and playlistDBNs
for isub=1:Nsub,
   TCPinstr(isub).chanDBN = chanDBN;
   TCPinstr(isub).PlayListDBN = PlayListDBN;
   M = max(length(PL{isub,1}), length(PL{isub,end}));
   playList = zeros(2, M);
   L1 = length(PL{isub,1}); L2 = length(PL{isub,2});
   row2 = 1;
   if L1>0, playList(1,1:L1) = PL{isub, 1}; row2=2; end;
   if L2>0, playList(2,1:L2) = PL{isub, row2}; end;
   TCPinstr(isub).playList = playList;
end


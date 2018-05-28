function PRPinstr = TcurveInstr(SD);
% TcurveInstr - compiles PRP instructions for threshold curves

%function TCPinstr = qtestIntr(isd, Nrep, MaxSpikeRate);
% test function for TCplay 
% isd is inter-stimulus duration

if nargin<3, MaxSpikeRate = 300; end % in Hz


global SGSR

Nfreq = length(SD.subseq)-1; % first one is spontaneous rate determination
% first call the default instructor
PRPinstr = defPRPinstructor(SD);
PRPinstr = rmfield(PRPinstr, 'createdby');
PRPinstr.synchedPlayer = 'TcurvePlayRec';
PRPinstr.Adapt = [];
PRPinstr.createdby = mfilename;

% extract tracking info
Track = SD.PRP.Tracking;
% change label of first subsequence
PRPinstr.PLOT.VVlabel{1} = 'spont. activity';

% find out which channels can be used for silence detection and how
% while visting tsubseqs, also find out what max level is (analog atten wide open)
PO = SD.PRP.playOrder(:)';
global GLBsilence
SilChan = []; SilDBN = []; WVindex = []; MaxSPL = [];
for ipl=PO(2:end),
   ipool = SD.subseq{ipl}.ipool; % the waveform indices
   sc = min(find(ipool~=0)); % non-zero means: active during this subseq
   wv = ipool(sc);
   WVindex = [WVindex wv];
   SilChan = [SilChan sc];
   SilDBN = [SilDBN GLBsilence.large(1)]; % always first channel, that's the way ...
   anaAtten = SD.subseq{ipl}.AnaAtten(sc);  %  ... defPRPinstructor assigns the channels
   MX = SD.waveform{wv}.DAdata.MaxSPL; % max SPL as if no num att were present
   numAtten = SD.waveform{wv}.GENdata.numAtt;
   MaxSPL = [MaxSPL MX-numAtten]; % net max SPL 
end

PRPinstr.Adapt = CollectInStruct(SilDBN, SilChan, MaxSPL, Track);

% falsify RECORD data of first subsequence:
% the recording part must treat the single interval as if
% it is composed of Nspont repetitions without silence in between
PRPinstr.RECORD(1).Nrep = Track.Nspont;
PRPinstr.RECORD(1).repDur = PRPinstr.RECORD(1).repDur/Track.Nspont;
PRPinstr.RECORD(1).repsilDur = 0;

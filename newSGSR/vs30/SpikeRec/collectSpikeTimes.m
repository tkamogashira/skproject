function SpikeInfo = CollectSpikeTimes(SMS, spikes, Compressed);

% XXX adapt for variation of two params XXX preliminary quick & dirty version

if nargin<3, Compressed = 0; end
global StimMenuStatus

% HEADER
global SESSION
SessionInfo = SESSION;
% type of stimulus
[dummy StimName] = StimTypeOf(SMS); % XXX->SMS
% get date
[y m d h mi s] = datevec(now);
Today = round([d m y h mi s]);
Place = location;
% stimulus parameters
StimParams = StimMenuStatus.params;

% find out about interrupted recording
RecordingComplete = spikes.recordingComplete;
NsubseqRecorded = spikes.Nrecorded; % number of recorded subseqs
PlayOrder = SMS.PRP.playOrder;
Nsubseq = length(PlayOrder);
% values varied from subseq to subseq
[varValuesLeft varValuesRight] = SPKextractVarValues(SMS); % XXX-> SMS
if isempty(SMS.PRP.plotInfo),
   plotVarValues = zeros(1,100);
   varUnit = 'AU';
else,
   plotVarValues = SMS.PRP.plotInfo.varValues;
   varUnit = SMS.PRP.plotInfo.varValueUnit;
end
repDur = zeros(1, Nsubseq);
for isubseq=1:Nsubseq,
   repDur(isubseq) = spikes.RECORDinfo(isubseq).repDur;
end
% params relevant for recording details
global SGSR
samFreqs = SGSR.samFreqs;
switchDur = SGSR.switchDur;
RecordParams = CollectInStruct(samFreqs, switchDur);
SequenceID = IDrequest('current');
IndepVar = getFieldOrDef(SMS, 'IndepVar', local_indep(SMS.PRP.plotInfo));
StimSpecials = getFieldOrDef(SMS, 'StimSpecials', []);
if ~isempty(StimSpecials), % store true rep duration in it
   StimSpecials.RepDur = repDur(:); % accurate value only available after D/A preps
end
Header = CollectInStruct(SequenceID, StimName, Today, Place, StimParams, Nsubseq, ...
   NsubseqRecorded, RecordingComplete, PlayOrder, repDur,...
   varValuesLeft, varValuesRight, plotVarValues, varUnit, RecordParams, ...
   SessionInfo, IndepVar, StimSpecials);

% extract repetition durations which, in principle, may be 
% different from subseq to subseq
% find out how many reps are in one subseq
Nrep = zeros(1,Nsubseq);
for isubseq=1:Nsubseq,
   Nrep(isubseq) = spikes.RECORDinfo(isubseq).Nrep;
end

% wrap varvalues in cell
varValues = cell(1,Nsubseq);
for ii=1:Nsubseq,
   if isempty(varValuesLeft),
      VVL = [];
   elseif iscell(varValuesLeft),
      VVL = varValuesLeft{ii};
   else, % vector
      VVL = varValuesLeft(ii);
   end
   if isempty(varValuesRight),
      VVR = [];
   elseif iscell(varValuesRight),
      VVR = varValuesRight{ii};
   else, % vector
      VVR = varValuesRight(ii);
   end
   varValues{ii} = [VVL VVR];
end

% SpikeTimes
SubSeq = cell(1, Nsubseq);
for isubseq=1:Nsubseq,
   SubSeq{1,isubseq}.IndependentVariable = varValues{isubseq};
   SubSeq{1,isubseq}.PlotVariable = plotVarValues(isubseq);
   if ~Compressed,
      SubSeq{1,isubseq}.Rep = cell(1,Nrep(isubseq));
      for iRep=1:Nrep(isubseq),
         SubSeq{1,isubseq}.Rep{1,iRep} = GetSpikesOfRep(isubseq, iRep);
      end
   end
end
if Compressed,
   spikes = minimizespikes(spikes); % remove empty buffer allocs
   SubSeqInfo = SubSeq;
   spikes.Buffer = CodeSpikeTimes(spikes.Buffer);
   SpikeTimes = CollectInStruct(spikes, SubSeqInfo);
else,
   SpikeTimes = CollectInStruct(SubSeq);
end

SpikeInfo = CollectInStruct(Header, SpikeTimes);

%------------------------------
function IndepVar = local_indep(PI);
Name = trimSpace(strtok(PI.xlabel,'('));
ShortName = strtok(Name);
Values = PI.varValues;
Unit = PI.varValueUnit;
PlotScale = PI.XScale; 
IndepVar = CollectInStruct(Name, ShortName, Values, Unit, PlotScale);

%      xlabel: 'Flip freq (Hz)'
%       varValues: [26x1 double]
%    varValueUnit: 'Hz'
%         VVlabel: {1x26 cell}
%          XScale: 'log'
%        PlotType: 'spikeRate'













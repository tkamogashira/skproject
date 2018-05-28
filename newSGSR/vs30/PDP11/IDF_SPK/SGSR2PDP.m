function [idfSeq, spkSeq] = SGSR2PDP(SMS, spikes)

% function [idfSeq, spkSeq] = SGSR2PDP(SMS, spikes); XXX
% convert SGSR data to PDP11 format
% XXX what happens with interrupted sequences? (see below)
% XXX adapt for variation of two params
% I assume from idf1.sequence{16} that fixed space
% is allocated for the stim_info and stim_rep blocks
% and that the spike counts are simply zero. On the other
% hand, the stim_info blocks of non-completed stuff
% is zero-valued. I will just follow this inconsistent
% policy. 
% No - changed the incredibily stupid zeros to the values July 2002

if isPDP11compatible(SMS)
    stimtype = stimtypeOf(SMS);
else
    error('non-PDP11 data storage not implemented yet');
end

% find out about interrupted recording
Nrecorded = spikes.Nrecorded; % number of recorded subseqs
completeRecording = spikes.recordingComplete;
idfSeq = SMS.GlobalInfo.cmenu;
% modify idfSeq according to completion of recording
idfSeq.stimcntrl.complete = completeRecording;
idfSeq.stimcntrl.max_subseq = Nrecorded;
% get date
[y m d h mi s] = datevec(now);
idfSeq.stimcntrl.today = round([d m y h mi s]);


% extract values of varied parameters. Because of frequency
% roundings, this is non-trivial for some stimulus menus.
[vL vR] = SPKextractVarValues(SMS); % varvalues returned in cells
NvarValues = length(vL); 
% deal to matrix if cell
if iscell(vL)
   varValues = zeros(NvarValues,2);
   for ii=1:NvarValues
      varValues(ii,:) = [vL{ii} vR{ii}]; 
   end
else % vL and vR are vectors
   varValues = [vL(:) vR(:)];
end

Nrep = idfSeq.stimcntrl.repcount;

% 1. dir_entry
spkSeq.dir_entry = []; % will be filled by SPKaddSeqToFile
% 2. SeqInfo 
% number of values of the first (and only in this version)
% varied param equals the number of subseqs presented
num_series1 = NvarValues; % note: this is # "requested" subseqs, ...
stim_info = idfSeq.stimcntrl; %    ... not necessarily the # recorded
islogplot = isequal(SMS.PRP.plotInfo.XScale,'log');
xlow = min(min(varValues));
xhigh = max(max(varValues));
spkSeq.seqInfo = CreateSeqInfo(num_series1, ...
   stim_info, islogplot, xlow, xhigh);

% 3. SubseqInfo (see notes about interrupted sequences above)
spkSeq.subseqInfo = cell(1, NvarValues);
for isubseq=1:NvarValues
   var1 = [];
   var2 = [];
   var1 = varValues(isubseq,:); 
   var2 = SMS.GlobalInfo.var2Values(isubseq,:); 
   spkSeq.subseqInfo{isubseq} = subseqEntry(var1, var2);
end
% 4. and 5. SpikeTime and SpikeCount
% see notes above about interrupted sequences
spkSeq.spikeCount = zeros(NvarValues, Nrep);
spkSeq.spikeTime = cell(NvarValues, Nrep);
for isubseq=1:NvarValues
   for iRep=1:Nrep
      spt = GetSpikesOfRep(isubseq, iRep);
      spkSeq.spikeTime{isubseq, iRep} = spt;
      spkSeq.spikeCount(isubseq, iRep) = length(spt);
   end
end

% ----------local functions----------------------
function SI = CreateSeqInfo(num_series1, ...
   stim_info, islogplot, xlow, xhigh)
SI = struct(... 
         'data_rec_kind', 2, ...
            'which_take', 1, ...
             'uet_info', defaultUET, ...
           'num_series1', num_series1, ...
           'num_series2', 1, ...
             'stim_info', stim_info, ...
    'num_stim_info_recs', 0, ...
     'num_rep_info_recs', 0, ...
             'islogplot', islogplot, ...
                  'xlow', xlow, ...
                  'xhigh', xhigh, ...
                 'dummy', 0, ...
             'chan_info', defaultChanInfo, ...
             'SPS_delay', 0 ...
             );
          
function DU = defaultUET
DU = struct( ...          
	'numactive', 1, ...
  'activelist', [1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0], ...
     'tdecade', 0, ...
       'tmult', 0, ...
    'triglist', [0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0], ...
   'startchan', 1, ...
    'stopchan', 1 ...
   );
function DC = defaultChanInfo
ACT = struct('recnum', 1, 'entry', 1); % active channel
INACT = struct('recnum', 0, 'entry', 0); % active channel
DC = [  ACT INACT INACT INACT ...
      INACT INACT INACT INACT ...
      INACT INACT INACT INACT ...
      INACT INACT INACT INACT];
%      
function SE = subseqEntry(var1, var2)
if isempty(var1), var1 = [0 0]; end;
if isempty(var2), var2 = [0 0]; end;
SE = struct('var1', var1, 'var2', var2, 'uet_status', [0 0 0 0]);

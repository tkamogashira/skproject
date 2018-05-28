function INSTR = playInstr2(SD);

% playList - generates instructions for playing
% SYNTAX:
% function INSTR = playInstr(SD);
% INPUTS: SD: stimdef struct
% OUTPUTS:
% INSTR is a struct with fields PLAY, RECORD and PLOT.
% PLAY and RECORD are arrays containing the information that
%   defines a PlayRec actions.
% PLOT is a struct that defines the plotting of spike rates 
%    during the measurement
%
% See PLAYIT for more info


% input arg checking & defaults
if nargin<1, global SD; end;

Nsubseq = length(SD.subseq);
playOrder = SD.PRP.playOrder; % order of stored subseqs need not be order of playing
% SubseqIndex contains indices in play order
SubseqIndex = playOrder(:)'; % row vector for for loop

playCount = 0; % counts the subseqs in playing order, not stored order
maxListLen = [0 0]; % maximum length of DNB list per channel (for DAMA allocation)
for iSubseq=SubseqIndex, 
   DBNplayList = cell(1,2); % per channel list of 16-bit DBNs
   playCount = playCount + 1;
   % collect params of this subseq
   DAmode = SD.subseq{iSubseq}.DAmode;
   Nrep = SD.subseq{iSubseq}.NREP;
   ipool = SD.subseq{iSubseq}.ipool;
   NheadSub = SD.subseq{iSubseq}.Nhead;
   NtrailSub = SD.subseq{iSubseq}.Ntrail;
   % reduce ipool by removing zero and duplicate elements
   if isequal(DAmode, 'D'), ipool = ipool(1); end;
   ipool = ipool(find(ipool~=0));
   Npool = length(ipool);
   for ichan=1:Npool, % fill DNB with channel/rep info list
      dad = SD.waveform{ipool(ichan)}.DAdata; % main source of info
      % heading & trailing zero samples according to subseq prescription
      Nbefore = NheadSub(ichan); % # zeros preceding the burst
      [dbnBefore repBefore] = silenceList(Nbefore, ichan);
      Nafter(ichan) = dad.Nrepsil - Nbefore; % # zeros following the burst;
      [dbnAfter repAfter] = silenceList(Nafter(ichan), ichan);
      % combine these zeros with the waveforms stored in DAdata
      % note: because of running noise, the reps are not necessarily identical ...
      dbn = []; rep = []; %... so we mist use loop rather than ... 
      for irep=1:Nrep, % ... repmat when realizing reps
         % extract the dbns and reps of the current rep
         [dbnBurst, repBurst] = local_selectBurstDBNs(dad, irep);
         % concatenate this interval rep to the total subseq list
         dbn = [dbn; dbnBefore; dbnBurst; dbnAfter]; % column vectors!
         rep = [rep; repBefore; repBurst; repAfter]; % column vectors!
      end
      % convert to zipped format after adding synch & switch features
      [DBNplayList{ichan} Nsync Nswitch] ...
         = synchedList(dbn, rep, dad.filterIndex, ichan, ichan==1); % sync in 1st chan 
      maxListLen(ichan) = max(maxListLen(ichan), size(DBNplayList{ichan},2)); % max len of list
   end; % endfor ichan
   % hardware settings: PA4; SS1; PD1 routing
   PA4 = PA4settings(SD.subseq{iSubseq}.AnaAtten); % PA4 instructions
   % PD1 & SS1 instructions
   Nplay = Nsync + Nswitch + dad.Nplay*Nrep; % entire subseq, including sync/switch
   Hinstr = HardwareInstr4DA(DAmode, dad.filterIndex, Nplay, dad.samP);
   % combine left and right list to single 2xN matrix
   Nleft = length(DBNplayList{1}); Nrite = length(DBNplayList{2});
   ListLen = max(Nleft, Nrite); playList = zeros(2,ListLen);
   if Nleft>0, playList(1,1:Nleft) = DBNplayList{1}; end; % stricter (pedantic) rules on empty -index assigments in R12
   if Nrite>0, playList(2,1:Nrite) = DBNplayList{2}; end;
   % fill the INSTR struct with all the info that defines
   % a D/A & Record Action
   PLAY(playCount) = struct(...
      'chanDBN', [0 0 0], ...
      'PlayListDBN', [0 0 0], ...
      'playList', playList, ...
      'Nplay', Nplay, ...
      'SamP', dad.samP, ...
      'PA4', PA4, ...
      'Hardware', Hinstr...
   );
   % Info needed for spike recording
   RECORD(playCount) =  struct( ...
      'Nrep', Nrep, ... % # reps in subseq (needed for spike stats)
      'repDur', dad.Nplay*1e-3*dad.samP, ... % rep duration in ms
      'repsilDur', min(Nafter)*1e-3*dad.samP, ... % repsil dur in ms; take shorter of the 2 channels
      'iSubseq', iSubseq, ... % index of subsequence within sequence
      'switchDur', (Nswitch+1)*dad.samP*1e-3 ... % exact switch dur in ms
      );
end; % for iSubseq

% put everything in single struct INSTR
% (plotinfo only needed once)
INSTR = struct(...
   'PLAY',     PLAY, ...
   'RECORD',   RECORD, ...
   'PLOT', SD.PRP.plotInfo ...
   );

% allocate single dama buffer per channel long enough to hold longest play list
Nleft = maxListLen(1); Nright = maxListLen(2);
commonChanDBN = [0]; % trailing 0 of list
commonPlayListDBN = [0]; % trailing 0 of list
ChanList = [0];;
if Nright>0, % insert DBN of right play list
   RightPlayDBN = ml2dama(zeros(1,Nright)); 
   commonPlayListDBN = [RightPlayDBN commonPlayListDBN];
   ChanList = [RightPlayDBN ChanList];
end;
if Nleft>0, % insert DBN of left play list
   LeftPlayDBN = ml2dama(zeros(1,Nleft)); 
   commonPlayListDBN = [LeftPlayDBN commonPlayListDBN];
   ChanList = [LeftPlayDBN ChanList];
end;
commonChanDBN = ml2dama(ChanList);
% visit all PLAY instructions and provide them with these two DNBs
for ii = 1:Nsubseq,
   INSTR.PLAY(ii).PlayListDBN = commonPlayListDBN;
   INSTR.PLAY(ii).chanDBN = commonChanDBN;
end
% signature
INSTR.createdby = mfilename;

%-------------------------locals-----------------------------

function [dbnBurst, repBurst] = local_selectBurstDBNs(DAdata, irep);
% returns DBN list and #repetition per DBN for a single "repetition" within
% a subsequence. In case of running noise, and maybe in some other 
% future cases as well, the "repeitions" are not exact duplicates, so
% the samples of each repetition can be in different buffers.
% This is indicacted by a non-unity number of COLUMNS in the
% bufDBNs and bufReps fields of DAdata. Different rows, on the other
% hand, refer to buffers that are all played in order WITHIN a
% single rep.
%
% first the DBNs
Ncol_dbn = size(DAdata.bufDBNs,2); % # columns in the prepared buffers
icol_dbn = min(Ncol_dbn, irep); % the index of the column we need for the current rep
dbnBurst = DAdata.bufDBNs(:, icol_dbn); % selection of this column
dbnBurst = dbnBurst(find(dbnBurst~=0)); % remove zero-valued elements (due to different sizes of columns)
% exactly the same thing for the reps (=repetition per buffer listed in dbnBurst)
Ncol_rep = size(DAdata.bufReps,2);
icol_rep = min(Ncol_rep, irep);
repBurst = DAdata.bufReps(:, icol_rep);
repBurst = repBurst(find(repBurst~=0));






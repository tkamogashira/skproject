function playInstr = PreparePlayitStruct(Stim, Nrep, DAmode, SamP);

% returns playInstr struct containing instruction for playit to play Stim
% debug/test function.
% SYNTAX: playInstr = PreparePlayitStruct(Stim, DAmode, SamP);
%  Stim is single or dual channel stimulus (row vector or 2xN matrix)
%  Nrep is number of repetitions of Stim
%  DAmode = 'L' | 'R' | 'B'  (left|right|both)
%  SamP is sample period in us. If Samp<0, -Samp is the index of
%    the standard set of SGSR sample frequencies. In this case,
%    switching of the filter-SS1 is done according to this sample rate.
%    If SamP > 0, the highest-freq analog filter present will be used

global SGSR GLBsync GLBsilence
if SamP<0,
   fltIndex = -SamP;
   SamP = 1e6/SGSR.samFreqs(fltIndex);
else,
   fltIndex = length(SGSR.samFreqs); % highest filter around
end

Nsil = round(SGSR.switchDur/(SamP*1e-3));
[SilDBN SilREP] = silencelist(Nsil,1);
SyncDBN = GLBsync.DBN;
SyncREP = 1;
NsamStim = size(Stim,2);
if isequal(DAmode,'B'),
   stimDBN = ml2dama(Stim(1,:));
   stimDBN = [stimDBN ml2dama(Stim(2,:))];
else,
end

trainREP = NtrainCycle;
DBNlist = [SyncDBN; SilDBN; trainDBN]; % column vector
REPlist = [SyncREP; SilREP; trainREP]; % idem
playList = [DBNlist'; REPlist'];
playList = [playList(:)' 0]; % row vector with DBNs and REPs zipped + trailing zero
% add fake second channel
playList = kron(playList,[1;0]);
% playList buffer must be large enough to contain playList
PlayListDBN = [ml2dama(playList(1,:)) 0];
chanDBN = ml2dama(PlayListDBN);
SampleLibDBNs = [];
Nplay = length(dama2ml(SyncDBN)) + Nsil + NsamPerTrainCycle*trainREP;
PA4 = [1 99.9; 2 99.9];
[nStreams addSimp specIB] = PD1routing('L');
[preGo] = ss1switching('L',1);
postGo = []; % don't switch to sound, but keep timing the events!
PLAYinstr = CollectInStruct(chanDBN, PlayListDBN, playList,SampleLibDBNs, ...
            Nplay, SamP, PA4, nStreams, addSimp, specIB,...
            preGo, postGo);

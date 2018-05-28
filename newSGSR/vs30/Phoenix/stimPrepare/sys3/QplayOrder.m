function QplayOrder(ichan, iSeg, Nrep);
% QplayOrder - specify chunk order for sequenced play on RP2
%   QplayOrder(ichan, iSeg, Nrep) specifies the order in which the
%   waveform chunks of D/A channel ichan are to be played. 
%   The elements of the vector iSeg indicate the respective chunk numbers,
%   counted from 1. Nrep holds the #reps for each chunk.
%   Nrep defaults to ones(size(iSeg)).
% 
%   If order is a 2xM matrix, the two rows are the sequences of
%   the left and right DA channels, respectively. NaNs will be
%   stripped of - this allows you two specify sequence lists of
%   different lengths for the two DA channels.
%
%   See also QplayPrep, QplayLoad, QplayGo, QplayStop.

if nargin<3, Nrep = ones(size(iSeg)); end % every chunk just once

iSeg = iSeg(:).'; % row vector
Nrep = Nrep(:).'; % idem

% get qplay params as set by QplayPrep
QP = QplayPrep('current');

if ichan==1,
   Len = QP.chunkLen1;
   offsets = QP.offset1;
   listName = 'seqList1';
   % reset counters
   sys3setpar(1, 'reset1', QP.Dev);
   sys3setpar(0, 'reset1', QP.Dev);
elseif ichan==2,
   Len = QP.chunkLen2;
   offsets = QP.offset2;
   listName = 'seqList2';
   % reset counters
   sys3setpar(1, 'reset2', QP.Dev);
   sys3setpar(0, 'reset2', QP.Dev);
else, error('Invalid ichan.');
end

offsets = offsets(iSeg);
Nsam = Len(iSeg);
PlayMatrix = [offsets; Nsam; Nrep; 0*Nrep]; % last column supplies Tim's memory alignment
PlayMatrix = [PlayMatrix, [-1;0;0;0]];  % -1 is end-of-list
PlayList = PlayMatrix(:).'; % vector-zipped version: [offset1 nsam1 nrep1 0  offset2 nsam2 nrep2 0  ... -1 0 0 0]

% upload
sys3write(PlayList, listName, QP.Dev, 0, 'I32');







function MST = MergeSpikeTimes(ST, iSubseq, reps);

% MergeSpikeTimes - merges spike arrival times of different reps of a subseq into a row array
% SYNTAX:
% MST = MergeSpikeTimes(ST, iSubseq, reps);
% where ST is spike time cell matrix (subseq x rep entries)
% reps = row vector containing the selection of reps (absent or zero reps: all repetitions)

if nargin<3, reps = 0; end;

Nsub = size(ST,1);
Nrep = size(ST,2);

if isequal(0,reps), reps = 1:Nrep; end;
reps = reps(:)'; % force into row vector

MST = [];
for iRep = reps,
   MST = [MST, ST{iSubseq,iRep}];
end


   
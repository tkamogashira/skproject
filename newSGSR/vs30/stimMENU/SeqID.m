function [FileStr, SeqStr] = SeqID(tog);
% SEQID - return strings that identify current sequence
if nargin<1, tog=0; end;
[fp fname] = fileparts(dataFile);
FileStr = ['File: ' upper(fname)];
SeqStr = ['Seq: ' SeqIndex];
if tog,
   FileStr = [FileStr ' --- ' SeqStr ];
end

function seqStr = SeqIndex;
% SEQINDEX - returns index string of next or current sequence
global StimMenuStatus SESSION

if isempty(SESSION),
   warning('No session initialized.');
   seqStr = '*-*-*'; return;
elseif ~isfield(SESSION,'iSeq'),
   warning('No session initialized.');
   seqStr = '*-*-*'; return;
end

if isPDP11compatible(StimMenuStatus.MenuName),
   seqStr = num2str(SESSION.iSeq);
else,
   seqStr = ['N ' num2str(SESSION.SGSRSeqIndex)];
end

if SESSION.requestID,
   seqStr = [seqStr, '  <' IDrequest('current') '>'];
end
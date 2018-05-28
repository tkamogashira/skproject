function y=StimMenuMayBeClosed;
% StimMenuMayBeClosed - may current stimmenu be closed?
%   0: if busy (play, checking params, etc)
%   1: if waiting ot non-existent
% Note: uses enable status of stimmenu's "CloseButton,"
%  which is governed by PRPsetButtons

y = 1;
global PRPstatus;
if ~StimMenuActive, return; end;
y = isequal('waiting',PRPstatus.action);
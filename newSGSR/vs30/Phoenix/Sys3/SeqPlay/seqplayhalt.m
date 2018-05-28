function y = SeqplayHalt(skipCheck);
% SeqPlayHALT - immediately halt sequenced play D/A
%   SeqplayHalt triggers the seqplay circuit on the Sys3 device to stop D/A conversion.
%   The circuit is immediately halted and reset.
%
%   See also Seqplay, SeqPlayInit, SeqPlayUpload, SeqPlayList, SeqPlayGo, SeqPlayStatus

if nargin<1, skipCheck=0; end
SPinfo = SeqplayInfo(skipCheck);

% Halt
sys3trig(3, SPinfo.Dev);
% Reset
sys3trig(4, SPinfo.Dev); % reset twice to prevent the circuit from running away
sys3trig(4, SPinfo.Dev);
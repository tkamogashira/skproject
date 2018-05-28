function y = SeqplayGo;
% SeqplayGo - trigger sequenced play over sys 3 device
%   SeqplayGo triggers the sequenced play previously specified
%   by SeqplayInit, SeqplayUpload and SeqplayList.
%
%   Type 'help Seqplay' to get an overview of sequenced playback.
%
%   See also SeqplayInit, SeqplayUpload SeqplayList, SeqplayHalt, Seqplaystatus.

SPinfo = SeqplayInfo; % checking of initialization and circuitID is implicit in this call

if ~isequal('listed', SPinfo.Status),
   error('No playlist specified for sequenced play. Call SeqplayList first.');
end

% make sure to abort any ongoing D/A
SeqplayHalt(1); % 1: skip checks

% Go
sys3trig(1, SPinfo.Dev);
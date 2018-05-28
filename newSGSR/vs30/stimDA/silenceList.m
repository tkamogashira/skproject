function [DBN, REP] = SilenceList(Nsamples, channel);
% returns DBNs and REPs for playing Nsamples zeros
% channel is scalar; no vector stuff here
% default channel is 1

global GLBsilence;

if nargin<1, error('insufficient input args'); end;
if nargin<2, channel=1; end;

if isempty(GLBsilence), initSpecialBufs; end;

channel = channel(1); % no smart stuff here
N = GLBsilence.Nlarge;

REP = [floor(Nsamples/N); rem(Nsamples, N)];
DBN = [GLBsilence.large(channel); GLBsilence.small(channel)];

% filter out zero-valued repetition numbers
valid = find(REP~=0);
REP = REP(valid);
DBN = DBN(valid);
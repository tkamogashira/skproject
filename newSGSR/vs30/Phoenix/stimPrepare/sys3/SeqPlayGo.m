function SeqPlayGo;

% SeqPlayGo - trigger sequenced play on RP2
%   SeqPlayGo starts the palying of chunks in the order specified by
%   SeqPlayOrder earlier.  If D/A is ongoing, SeqPlayGo
%   results in the D/A conversion to jump back, i.e.,
%   to interrupt the current play and start over again.
%
%   See also SeqPlayPrep, SeqPlayLoad, SeqPlayOrder, SeqPlayStop.

sys3trig(1);                            %%reset counters

global SeqPlay_jumpLoc

sys3write(SeqPlay_jumpLoc(1:2), 'jumpLoc', 'RP2_1', 0, 'I32');  %%remove stop code at first 2 locs


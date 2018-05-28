function SeqPlayStop;

% SeqPlayStop - Stop playing waveforms on the RP2
%   SeqPlayStop halts the counters on the RP2 and resets them, 
%   so no chunks are played and the circuit is ready to start playing all over again.
%   Use before using eqPlayLoad, SeqPlayOrder or SeqPlayGo
%
%   See also SeqPlayPrep, SeqPlayLoad, SeqPlayOrder, SeqPlayGo.

sys3write([-1 -1], 'jumpLoc', 'RP2_1', 0, 'I32');       %%stop code

sys3trig(1);                                            %%reset counters
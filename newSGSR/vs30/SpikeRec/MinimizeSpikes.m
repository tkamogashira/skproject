function sp=MinimizeSpikes(sp);
% MinimizeSpikes - reduces  buufer length within gloabl SPIKES to just fit data
% syntax:
% mspikes=MinimizeSpikes;
% if no outarg is given, global SPIKES itself is minimized

if nargin<1,
   global SPIKES
   sp = SPIKES;
end
sp.Buffer = sp.Buffer(1:sp.counter);
sp.SUBSEQ = sp.SUBSEQ(1:sp.ISUBSEQ);
if (nargout<1) & (nargin<1), % replace global
   SPIES = sp;
end


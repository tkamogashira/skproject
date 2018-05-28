function y = SeqplayInfo(skipCheck);
% SeqplayInfo - current status of Seqplay circuit
%   throws error if SeqPlay circuit has not been initialized and/or 
%   the circuit ID is mismatched.
%  
%   SeqplayInfo(1) skips the checks.
%
%   See also Seqplayinit, seqplayCheckCircuitID.

if nargin<1, skipCheck=0; end

if ~skipCheck,
   error(SeqplayCheckCircuitID);
end

y = SeqplayInit('status');

if isempty(y) & ~skipCheck,
   error('Seqplay not initialized. Call SeqplayInit first.');
end



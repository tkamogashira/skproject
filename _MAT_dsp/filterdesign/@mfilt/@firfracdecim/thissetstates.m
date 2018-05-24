function S = thissetstates(Hm, S)
%THISSETSTATES Overloaded set the states property

% This should be a private method

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1);  M = R(2);

P = Hm.PolyphaseDelays;
if isempty(P),
    l0 = 1;
    m0 = 1;
else
    l0 = P(1);
    m0 = P(2);
end

% Number of output states.
outDelays = (L-1)*m0;     
% There are no output states when m0=1, bc a commutator is used.
%if m0==1, outDelays = 0; end

% Output circular buffer has more memory than states.
outBufLen = L*m0;

% Determine number of input + filter states
inDelays = thisnstates(Hm) - outDelays;

% Extract the input+filter states & convert from linear to circular buffer.
CircInStates = lin2circ_instates(S(1:inDelays),Hm.inBufWIdx,inDelays);

% Extract the output states and convert from linear to circular bufferss.
CircOutStates = lin2circ_outstates(S(inDelays+1:end),Hm.outBufIdx,outDelays,outBufLen);

% Save new states.
Hm.HiddenStates = [CircInStates; CircOutStates];

%--------------------------------------------------------------------------
function inBuf = lin2circ_instates(zf,idx,inDelays)
% Convert the input+filter states from linear buffer to circular buffer.
% Add 1 additional memory location for the algorithm.

inBufLen = inDelays+1; % Circular buffer has an extra state.
inBuf = zeros(inBufLen,1);  
for k = 1:inDelays,
    if idx <= 0; idx = inBufLen; end
    inBuf(idx,:) = zf(k,:);     % (L-1)*l0 + M*(Lh-1) input+filter states.
    idx = idx-1;
end

%--------------------------------------------------------------------------
function outBuf = lin2circ_outstates(zfout,idx,outDelays,outBufLen)
% Convert the output states from linear buffer to circular buffer.  Add
% an additional m0 memory locations for the algorithm.

outBuf = zeros(outBufLen,1);  
if idx == 0 || isempty(zfout), return, end  % Initializing object.

for k = 1:outDelays,
    if idx > outBufLen; idx = 1; end
    outBuf(idx,:) = zfout(k,:);
    idx = idx+1;
end

% [EOF]

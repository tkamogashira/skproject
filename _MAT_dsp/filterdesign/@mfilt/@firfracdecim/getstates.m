function S = getstates(Hm,dummy)
%GETSTATES Overloaded get for the States property.

% This should be a private method

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactor;
L = R(1);  M = R(2);

Pdelays = Hm.PolyphaseDelays;
l0 = Pdelays(1); m0 = Pdelays(2);

Lh = ceil(Hm.nCoeffs/(L*M));     % Length of polyphase sub-filter.
inDelays = (L-1)*l0 + M*(Lh-1);  % Number of input + filter states.
outDelays = (L-1)*m0;            % Number of output states.

% Convert circular buffer to linear vector of input + filter states.
outBufLen = L*m0;
zf = circ2lin_indelays(Hm.HiddenStates(1:end-outBufLen,:),Hm.inBufWIdx,inDelays);

% Convert output circular buffer to linear vector of states.
zf_out = circ2lin_outdelays(Hm.HiddenStates(end+1-outBufLen:end,:),...
        Hm.outBufIdx,outDelays,outBufLen,m0);

% Concatenate input+filter+output states.
S = [zf; zf_out];

%--------------------------------------------------------------------------
function zf = circ2lin_indelays(inBuf,idx,inDelays)

zf = [];
if isempty(idx); return; end  % Object initialization.

for k = 1:inDelays
    zf(k,:) = inBuf(idx,:);      % (L-1)*l0 + M*(Lh-1) input+filter states.
    idx = idx-1;
    if idx <= 0; idx = inDelays+1; end
end

%--------------------------------------------------------------------------
function zf_out = circ2lin_outdelays(outBuf,idx,outDelays,outBufLen,m0)

zf_out = [];
if isempty(idx); return; end  % Object initialization.

% When m0=1 no output states are stored bc a commutator is used.
%if m0==1, outDelays=0; end

for k = 1:outDelays
    zf_out(k,:) = outBuf(idx,:);      % (L-1)*m0 states.
    idx = idx+1;
    if idx > outBufLen; idx = 1; end
end

% [EOF]

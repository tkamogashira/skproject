function [y, zf] = secfilter(Hm,x,zi)
% SECFILTER Direct-Form FIR Polyphase Fractional Decimator filter.
%  [Y,Zf] = SECFILTER(Hm,X,Zi)
  
%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.

[Lx,nchans] = size(x);
if Lx*nchans == nchans,    % Convert row vectors to column vectors.
    x = x(:);
    [Lx,nchans] = size(x);
end

% Cache upsample and downsample factors.
R = Hm.RateChangeFactor;
L = R(1); M = R(2);

% l0 and m0 are the input and output delays between each interp phase.
Pdelays = Hm.PolyphaseDelays; 
l0 = Pdelays(1); m0 = Pdelays(2);

% Get indices to states vectors.
oldIdx.outBufIdx = Hm.outBufIdx;
oldIdx.inBufIdx  = Hm.inBufIdx;
oldIdx.inBufWIdx = Hm.inBufWIdx;

% [decimIdx InputOffset]
% [1          0        ]
% [2          M-1      ]
% [3          M-2      ]
% ...
% [M          1        ]
oldIdx.decimIdx = mod(M-mod(Hm.InputOffset,M),M)+1;

% Get, validate, and expand (if necessary) PolyphaseAccum.
[old_pSum,nchans] = polyphaseacc(Hm);

% Length of output buffer - it has m0 extra slots. 
outBufLen = L*m0;

% % When m0=1 no output states are stored bc a commutator is used.
% if m0==1, outBufLen=1; end

zi_out = zi(end+1-outBufLen:end,:); % Extract the output buffer states.
if isempty(zi_out), 
    if L==1, zi_out = 0;           % Allow 1/L case to work w/out if-statements.
    else     zi_out = zeros(outBufLen,nchans);          
    end
end
zi = zi(1:end-outBufLen,:);         % Extract the input + filter states.

% Filters.
hp = polyphase(Hm);
Lh = length(hp(1,:));
h = hp.';  % convert rows to columns.
h = h(:);  % convert matrix to one column.

% Number of required input delays to make structure causal + filter states.
inDelays = (L-1)*l0 + M*(Lh-1);

[y,zf,zf_out,pSum,newIdx] = firfracdecimfiltmcode(Hm,h,Lh,x,Lx,nchans,...
                             L,M,l0,m0,inDelays,zi,zi_out,outBufLen,old_pSum,oldIdx);

% Append the output buffer states to the final states of the filter.
% Don't store states for m0=1, since a commutator is used at the output.
%if m0==1,  zf_out = [];  end
zf = [zf; zf_out];

% Store indices and partial sums.
Hm.outBufIdx  = newIdx.outBufIdx;
Hm.inBufWIdx  = newIdx.inBufWIdx;
Hm.inBufIdx   = newIdx.inBufIdx;

% Transform decimIdx back into input offset
Hm.InputOffset = mod(M-mod(newIdx.decimIdx,M),M)+1;

Hm.PolyphaseAccum = pSum;

%--------------------------------------------------------------------------
function [polyacc,nchans] = polyphaseacc(Hm)

% Get PolyphaseAccum
polyacc = Hm.PolyphaseAccum;

nchans = Hm.nchannels;

npolyacc = size(polyacc,2);
if ~( isempty(polyacc) || (any(npolyacc == [nchans,1])) ),
	error(message('dsp:mfilt:firfracdecim:secfilter:InvalidDimensions'));
end

% Expand polyacc for multiple channels
if nchans > 1 && npolyacc==1,
    polyacc = polyacc(:,ones(1,nchans));
end

%--------------------------------------------------------------------------
function [yout,zf,zfout,pSum,Idx]=firfracdecimfiltmcode(Hm,h,Lh,x,Lx,nchans,...
                              L,M,l0,m0,inDelays,zi,zi_out,outBufLen,old_pSum,oldIdx)
% Implements the efficient polyphase fractional decimator as described in
% N. J. Fliege, Multirate Digital Signal Processing pp 110-114.

% Input delay line, (L-1)*l0 + 1 delays. +1 is to store the input sample.
inBuf = zi;
inBufIdx = oldIdx.inBufIdx;
inBufWIdx = oldIdx.inBufWIdx; % Position to start writing to input buffer.

% Initialize partial sums.
pSum = old_pSum; 

% Output initialization.
Ly = allocate(Hm,Lx,Hm.InputOffset);
yout = zeros(Ly,nchans);
youtidx = 1;

% Output states. Uses an extra m0 states.
outBuf = zi_out;
%outBufIdx = oldIdx.outBufIdx;
yidx = 1;
interpOffset = oldIdx.outBufIdx;

% Decimation filter index.
decimIdx = oldIdx.decimIdx;

Xidx = 0;               % index into x.
while Xidx < Lx,
    Xidx     = Xidx+1;      
    inBufIdx = inBufIdx + 1;

    % Update the input delay line (input buffer) with next sample.
    inBufWIdx = inBufWIdx+1;
    if inBufWIdx > inDelays+1; inBufWIdx = 1; end
    inBuf(inBufWIdx,:) = x(Xidx,:);

    % Cycle through all interp phases and generate partial sums.
    for n=1:L,    

        % Counter-clockwise commutator, so pick filters in reverse order.
        % Determine the offset between each filter coeff since we alternate
        % between interp phases.
        fidx = (decimIdx-1)*Lh+1 + (n-1)*(Lh*M); % 1st term is decim phase, 2nd term is interp phase

        if inBufIdx(n) > inDelays+1, inBufIdx(n) = 1; end % wrap if necessary.
        for m=1:Lh,  % Loop over coeffs of each sub-filter

            % Figure out indx for state for next filter coeff.
            bufidx = inBufIdx(n)-(m-1)*M;
            if bufidx<=0; bufidx=inDelays+1+bufidx; end   % wrap if necessary.
            
            % Add output of each decimator and store in pSum.
            pSum(n,:) = pSum(n,:) + h(fidx+(m-1))*inBuf(bufidx,:);
        end
        
    end % interp phase looping

    % Generate an output each time the commutator completes a cycle.
    if decimIdx==1,
        for n = 1:L,  % Loop through each interpolation phase.
            
            % Insert (n-1)*m0 delays at the output of the nth interp phase.
            outBufIdx = (n-1)*m0+interpOffset;
            if outBufIdx>outBufLen, outBufIdx = outBufIdx-outBufLen; end
            outBuf(outBufIdx,:) = pSum(n,:);
            
            % Output
            yidx = (n-1)+interpOffset;
            if yidx>outBufLen, yidx = yidx-outBufLen; end
            yout(youtidx,:) = outBuf(yidx,:);
            youtidx = youtidx+1;

            % Reset partial sums after they're written to the output buffer.
            pSum(n,:)=0;
        end
        
        % Increment interpOffset by the interp factor L for the next interp sum.
         interpOffset = interpOffset+L;
         if interpOffset>outBufLen, interpOffset=1; end

        % Now that we've processed all interp phases, reset decim idx.
        decimIdx = M+1;  % +1 bc we'll decrement next.
    end
    
    decimIdx = decimIdx-1;
end

% Return input delay-line+filter, and output states.
zf    = inBuf;
zfout = outBuf; %zeros((L-1)*m0,nchans);

% Return updated indices.
Idx.inBufIdx  = inBufIdx;
Idx.inBufWIdx = inBufWIdx;
Idx.outBufIdx = interpOffset;
Idx.decimIdx  = decimIdx;

% [EOF]

function [y, z] = secfilter(Hm,x,z)
% SECFILTER Polyphase FIR Fractional Interpolator filter.
%  [Y,Zf] = SECFILTER(Hm,X,Zi)

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactor;
L = R(1); M = R(2);

% Pdelays(2) and Pdelays(1) are the delays (l0 and m0) at the
% input and output respectively for the FIR Fractional Interpolator.
Pdelays = Hm.PolyphaseDelays;
l0 = Pdelays(2);
m0 = Pdelays(1);

% Coefficients
p = polyphase(Hm);

% Input Offset
inOffset = double(Hm.InputOffset);

% Get framesize, number of channels and initialize yout
[nx nchans] = size(x);

% Determine output length
ny = allocate(Hm,nx,inOffset);

% Pre-allocate memory
y = zeros(ny,nchans);   % Output
polyacc = zeros(L,M); % Intermediate variable hold output of each polyphase subfilter

% An extra dummy state is needed (+1) to prevent the for loop in
% firfracinterpfiltmecode from erroring out for the first stage.
% This is similar to zizeropad in some of the dfilt/secfilter methods.
outBufSize = (M-1)*m0+1;
filtBufSize = nstates(Hm)-outBufSize+2;

filtBuf = z(1:filtBufSize,:);
outBuf = z(filtBufSize+1:filtBufSize+outBufSize,:);

% Circular buffer indices
tapIndex = Hm.TapIndex;

% Call mex function here ,instead of the mcode prototype.
[y,filtBuf,outBuf,tapIndex] = firfracinterpfiltmcode(...
    p,x,inOffset,L,M,l0,m0,y,polyacc,...
    filtBuf,outBuf,filtBufSize,outBufSize,tapIndex);

z = [filtBuf;outBuf];
Hm.TapIndex = tapIndex;
Hm.InputOffset = mod(nx+inOffset,M);

%--------------------------------------------------------------------------
function [y,filtBuf,outBuf,filtCIdx] = firfracinterpfiltmcode(...
    p,x,inOffset,L,M,l0,m0,y,accinterp,filtBuf,outBuf,filtBufSize,OutBufSize,filtCIdx);
% One circular buffer 

[nx nchans] = size(x);

% Number of coefficients per polyphase subfilter
nbpoly = size(p,2); 

% Initialize read indices
readIdx = zeros(nbpoly,1);

% Circular buffers indices
filtCIdx = filtCIdx+1; % 1-based indexing

for k=1:nchans,
    % Local copy of circular index
    writeIdx  = filtCIdx;
    % Output index
    idy = 1;
    for idx = 1:nx,
        % Load input sample into input buffer
        filtBuf(writeIdx,k) = x(idx,k);

        % Decimate by M the input of each interpolator
        if mod((idx-1)+inOffset,M)==0, % (idx-1) because 1-based indexing
            %--------------------------------------------------------------
            % Filter through each interpolator from top to bottom
            %--------------------------------------------------------------
            for mi=1:M,
                % Increment read indices
                readIdx(1) = writeIdx+(mi-1)*l0;
                % Wrap if necessary
                if readIdx(1)>filtBufSize,
                    readIdx(1) = readIdx(1)-filtBufSize;
                end
                for j=2:nbpoly,
                    readIdx(j) = readIdx(j-1)+M;
                    % Wrap if necessary
                    if readIdx(j)>filtBufSize,
                        readIdx(j) = readIdx(j)-filtBufSize;
                    end
                end
                % Filter one sample trough an interpolator. Get L samples back
                accinterp(:,mi) = forminterp(p,mi,filtBuf(readIdx,k),L);
            end
            %--------------------------------------------------------------
            % Output samples and update output buffer
            %--------------------------------------------------------------
            for li=1:L,
                % Output samples = sum of last interpolator and last value
                % of output buffer
                y(idy,k) = accinterp(li,M) + outBuf(OutBufSize,k);
                % For each phase (bottom up)
                for mi=M-1:-1:1,
                    offset = (mi-1)*m0+1; % +1 for the first dummy location in outBuf.
                    % Udpate the length m0 buffer of each phase from top to bottom
                    for j=m0:-1:2,
                        % Copy state to lower location
                        outBuf(j+offset,k) = outBuf(j+offset-1,k);
                    end
                    outBuf(1+offset,k) = outBuf(offset,k)+accinterp(li,mi);
                end
                % increment output index
                idy = idy+1;
            end
        end
        % Decrement circular index , wrap if necessary
        writeIdx = writeIdx-1;
        if writeIdx==0,
            writeIdx = filtBufSize;
        end
    end
end

filtCIdx = writeIdx-1;   % 1-based indexing


%--------------------------------------------------------------------------
function y = forminterp(p,mi,z,L)
% This function see one sample at a time

poffset = (mi-1)*L;
nz = length(z);

% For each polyphase subfilter compute one output
for k = 1:L,
    % Initialize Acc
    acc = 0.0;
    for j=1:nz,
        acc = acc + p(k+poffset,j) * z(j);
    end
    y(k) = acc;
end


function SeqPlayLoadNew(ichan, W, L);
% SeqPlayLoadNew - upload stimuli for sequenced play on RP2
%   SeqPlayLoad(iChan, W, L) loads the samples of the waveform
%   to RAMbuffer for D/A channel iChan of the RP2.
%   W is a vector obtained by concatenating all the
%   respective stimulus buffers ("chunks").
%
%   L is a vector containing the respective lengths of the chunks:
%   sum(L) = length(W). For technical reasons (blame Tim), all buffers
%   lengths must be even numbers.
%   The number of chunks (the length of L) may not exceed 5000.

%
%   See also QplayPrep, QplayOrder, QplayGo, QplayStop.

if nargin<3, L = length(W); end
if any(L<1), error('Buffer lengths must be positive.'); end
if any(rem(L,2)), error('Buffer lengths must be even numbers.'); end

if any(abs(W)>2^15-1),
   error('Magnitude of samples exceeds maximum 2^15-1 for 16-bit DA conversion.')
end

if sum(L)~=length(W),
   error('Sum of chunk lengths in L does not match total length length of waveform W.');
end

L = L(:).';  % row vector

% compute offsets from chunk lengths
offset = [0, cumsum(L(1:end-1))];

% upload waveforms as 16-bit integers to RP2 circuit; ...
% ... store chunk lengths & offsets in QplayPrep persistent
if ichan==1, 
   chunkLen1 = L; offset1 = offset(:).'; 
   QP = QplayPrep('current', chunkLen1);
   QP = QplayPrep('current', offset1);
   sys3write(W, 'samples1', QP.Dev, 0, 'I16');
elseif ichan==2,
   chunkLen2 = L; offset2 = offset(:).';
   QP = QplayPrep('current', chunkLen2);
   QP = QplayPrep('current', offset2);
   sys3write(W, 'samples2', QP.Dev, 0, 'I16');
else, error('Invalid ichan value.');
end













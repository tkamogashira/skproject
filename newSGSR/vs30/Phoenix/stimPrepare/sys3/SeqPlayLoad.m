function SeqPlayLoad(W, L);
% SeqPlayLoad - upload stimuli for sequenced play on RP2
%   SeqPlayLoad(W, L) loads the samples of the waveform
%   to e RAMbuffer on the RP2.
%   W is a 2xN vector obtained by concatenating all the
%   respective dual-channel stimulus buffers ("chunks").
%   If a row vector R is specified for W, this is interpreted
%   as W = [R;R], i.e., diotic play.
%
%   The elements of the vector L specify the lengths of the
%   individual chunks: sum(L) = size(W,2).
%   If L is not specified, it is set to length(W), i.e., W is
%   considered a single chunk.
%   The number of chunks (the length of L) may not exceed 5000.
%
%   See also SeqPlayPrep, SeqPlayOrder, SeqPlayGo, SeqPlayStop.

if nargin<2, L = size(W,2); end
if any(L<1), error('Buffer lengths must be positive.'); end

if ~isequal(sum(L), size(W,2)),
   error('Sum of chunk lengths in L does not match total length length of waveform W.');
end

if any(abs(W)>2^15-1),
   error('Magnitude of samples exceeds maximum 2^15-1 for 16-bit DA conversion.')
end

if size(W,1)==1,
   W = [W;W]; % diotic
elseif size(W,1)~=2,
   error('Waveform W must be 2xN matrix or row vector.');
end

% prepend two little zero buffers to bypass timing problems
Nprezero = 5; 
W = [zeros(2,2*Nprezero+1) W];
L = [Nprezero Nprezero L];

% store L in global
global SeqPlay_L;
SeqPlay_L = L;

% upload waveforms as 'zipped' 16-bit integers (sys3write automatically reads column per column)
sys3write(W, 'DAsamples', 'RP2_1', 0, 'I16');

% fill jumpLoc with -1s
jumpLoc = -ones(1, 5000);
sys3write(jumpLoc, 'jumpLoc', 'RP2_1', 0, 'I32');


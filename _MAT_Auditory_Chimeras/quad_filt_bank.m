function b = quad_filt_bank(cutoffs, Fs, N)
% QUAD_FILT_BANK - Create bank of FIR complex filters
% 	whose real and imaginary parts are in quadrature
% Usage: b = quad_filt_bank(cutoffs, Fs, N)
%   cutoffs   band cutoff frequencies (Nbands + 1)
%   Fs        sampling rate (default 1)
%   N         filter order (default 8*Fs/(min(bandwidth)))
%   b         filter bank [N+1 X Nbands]
%
%	Copyright Bertrand Delgutte, 1999-2000
%
if nargin < 2, Fs = 1; end

w = 2*cutoffs/Fs;   % Matlab normalized frequency
if nargin < 3 | isempty(N), 
   N = round(8/min(diff(w))); 
	if rem(N,2) ~= 1, N = N+1; end	% make even
end

nbands = length(cutoffs) - 1;
b = zeros(N+1, nbands);

bw = diff(w)/2;    % lowpass filter bandwidths
fo = w(1:nbands) + bw;   % frequency offsets
t = [-N/2:N/2];     % time vector

for k = 1:nbands, 
   b(:,k) = (fir1(N, bw(k)) .* exp(j*pi*fo(k)*t)).'; 
end



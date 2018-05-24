function [y,z] = secfilter(Hm,x,z)
%SECFILTER Filter this section.
%   [Y,Zf] = SECFILTER(Hd,X,ZI) filters this section.  This function is only
%   intended to be called from DFILT/FILTER.  
%
%   See also MFILT.   
  
%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

BL = Hm.BlockLength;
L = Hm.InterpolationFactor;
[Lx,nchannels] = size(x);
if rem(Lx,BL),
    error(message('dsp:mfilt:fftfirinterp:secfilter:InvalidBlockLength'));
end

M = polyorder(Hm);

y = zeros(L*Lx,nchannels);
Nfft = BL+M;


% Get the fft coeffs
fftcoeffs = Hm.fftcoeffs;

% Initialize block output
yblock = zeros(Nfft,L);

for k = 1:nchannels,
	for n = 1:BL:Lx,
		yblock = ifft(fftcoeffs.*fft(repmat(x(n:n+BL-1,k),1,L),Nfft));
		yblock(1:M,:) = yblock(1:M,:) + z(:,k*L-(L-1):k*L); 	
		y(L*n-(L-1):L*n+L*BL-L,k) = reshape(yblock(1:BL,:).',L*BL,1);
		z(:,k*L-(L-1):k*L) = yblock(end-M+1:end,:);
	end
end

if isreal(x) && isreal(Hm),
    y = real(y);
    z =real(z);
end



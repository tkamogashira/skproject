function y=RealIFFT(x,n)
%RealIFFT(X,N) -- Real IFFT
%Input vector X is the spectrum for the POSITIVE frequency only.
%Thus, the output vector has a length of length(X)*2
%Usage: y=RealIFFT(x,n)
%by SF, 7/24/01 (Adapted from RIFT.M 12/23/97)

if size(x,1)==1
	x2=[0 x fliplr(conj(x(1:end-1)))];
else
	x2=[0; x; flipud(conj(x(1:end-1)))];
end

if nargin>1
	y2=ifft(x2,n*2);
else
	y2=ifft(x2,length(x2));
end

y=real(y2);


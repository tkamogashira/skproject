function [e1_fs2, e2_fs1] = multi_band_chimera(x1, x2, Fco, Fs, refilter)
% MULTI_BAND_CHIMERA - Synthesize pair of multi-band "auditory chimeras"
% by dividing each signal into frequency bands, then interchanging 
% envelope and fine structure in each band using Hilbert transforms.
%
% Usage:  [e1_fs2, e2_fs1] = multi_band_chimera(x1, x2, Fco, Fs, refilter)
%	x1, x2	original signals
%	Fco	    band cutoff frequencies (Nbands+1), or filter bank
%	Fs	    sampling rate in Hz (default 1)
%   refilter  set to 1 to filter again after exchange operation (default 0)
% 	e1_fs2  chimera with envelope of x1, fine structure of x2 in each band
% 	e2_fs1  chimera with envelope of x2, fine structure of x1 in each band
%
%	Copyright Bertrand Delgutte, 1999-2000
%
if nargin < 3, error('Specify original signals and cutoff frequencies'); end
if nargin < 4, Fs = 1; end
if nargin < 5, refilter = 0; end

if min(size(x1)) == 1, x1 = x1(:); end	% make column vectors
if min(size(x2)) == 1, x2 = x2(:); end
nchan = size(x1, 2);

% pad with zeroes to match lengths
if length(x1) < length(x2),
	x1 = [x1; zeros(length(x2)-length(x1),nchan)];
elseif length(x2) < length(x1),
	x2 = [x2; zeros(length(x1)-length(x2),nchan)];
end
   
% Because the Hilbert transform and the filter bank are both linear operations,
% they commute and associate.  We create a bank of complex FIR filters whose
% real and imaginary parts are in quadrature (cos and sin).  This complex filter 
% is directly applied the original signals. The Hilbert envelope in each band
% is the absolute value of the complex filter output.
% This approach avoids computation of large FFTs as in Matlab's 'hilbert'.

if min(size(Fco)) > 1 | isstr(Fs), 
   b = Fco;	% kluge to specify filters
else b = quad_filt_bank(Fco, Fs);
end

e1_fs2 = zeros(size(x1));
e2_fs1 = zeros(size(x1));

% loop over filters in bank 
for k = 1:size(b,2),

	zfilt1 = fftfilt(b(:,k), x1);
	zfilt2 = fftfilt(b(:,k), x2);
	
	% interchange envelope and fine structure	
  	e1_fs2_filt = abs(zfilt1) .* cos(angle(zfilt2));
    e2_fs1_filt = abs(zfilt2) .* cos(angle(zfilt1));
      
    % refilter backward to avoid delay accumulation
    if refilter,
        len = length(e1_fs2_filt);
        e1_fs2_filt(len:-1:1,:) = fftfilt(real(b(:,k)), e1_fs2_filt(len:-1:1,:));
    	e2_fs1_filt(len:-1:1,:) = fftfilt(real(b(:,k)), e2_fs1_filt(len:-1:1,:));
	end
      
	% accumulate over frequency bands
  	e1_fs2 = e1_fs2 + e1_fs2_filt;
    e2_fs1 = e2_fs1 + e2_fs1_filt;
     
end
  
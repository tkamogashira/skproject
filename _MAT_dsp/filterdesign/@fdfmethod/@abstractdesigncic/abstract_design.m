function N = abstract_design(~,R,M,fp,A,~)
%ABSTRACT_DESIGN Shared CIC Decim/Interp Number of Sections (N) estimator.
% N = abstract_design(this,R,M,fp,A,ftype)
% R     - Rate change factor
% M     - Comb Differential Delay parameter
% A     - Aliasing/Imaging Attenuation in dB. This corresponds to the 
%         first and maximum error over all aliasing (for decimation) or
%         imaging (for interpolation) bands.  This value is specified
%         relative to the maximum filter response of 0dB.
% ftype - String indicating type of filter: 'decim' for Decimators and
%         'interp' for Interpolators.
%
% Outputs:
% N    - Number of Sections which produces an aliasing attenuation of at least A.

%   Copyright 2005-2010 The MathWorks, Inc.

% Compute nulls of CIC 
Fo = cicnulls(R,M);

% Design a single section CIC (all pass filter) when R and M are both
% equal to 1.
N = 1;

if ~isempty(Fo)
  % Find fAI as shown in Hogenauer's paper
  fAI = Fo(1)-fp;
  
  % Estimate N given a aliasing/imaging attenuation
  N = getNfromfreqresp(A,R,M,fAI);
end
%--------------------------------------------------------------------------
function N = getNfromfreqresp(AI,R,M,fAI)
%CICNFROMFREQRESP   Compute N from the CIC frequency response.

% Frequency response of a CIC in dB
% H   = 20*log10(abs(((sin(pi*M*fc)./(sin(pi*fc/R)))).^N)/gCIC)

% Rearrange frequency response equation and solve for N
num = log(abs(10^(AI/20)));
den = log(abs((sin(pi*M*R*fAI/2)/sin(pi*fAI/2))/(R*M)));

% Return the number of sections, N
N = ceil(abs(num/den));

% [EOF]

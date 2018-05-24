function realizemdl(H,varargin)
%REALIZEMDL Filter realization (Simulink diagram).
%     REALIZEMDL(Hd) automatically generates architecture model of filter
%     Hd in a Simulink subsystem block using individual sum, gain, and
%     delay blocks, according to user-defined specifications.
%
%     REALIZEMDL(Hd, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) generates
%     the model with parameter/value pairs.
%
%    EXAMPLES:
%    % Design an elliptic halfband decimator with a decimation factor of 2 
%    % and sampling frequency 2000 Hz. The filter transition width is 100 Hz
%    % and stopband attenuation is 80 dB and realize the filter with map
%    % the coefficients to the ports.
%    f = fdesign.decimator(2,'halfband','TW,Ast',100,80,2000); 
%    Hm = design(f,'ellip','FilterStructure','iirdecim') 
%    coeffnames.Phase1 = {'P1_Section1','P1_Section2','P1_Section3'};     % coefficient names for phase 1
%    coeffnames.Phase2 = {'P2_Section1','P2_Section2','P2_Section3'};     % coefficient names for phase 2
%    realizemdl(Hm,'MapCoeffsToPorts','on','CoeffNames',coeffnames);
%
%    See also MFILT/REALIZEMDL

%   Copyright 2005-2009 The MathWorks, Inc.

super_realizemdl_composite(H,varargin{:});

% [EOF]

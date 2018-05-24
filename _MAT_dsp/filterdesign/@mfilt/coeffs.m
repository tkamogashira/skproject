%COEFFS   Returns the filter coefficients in a structure.
%   S = COEFFS(Hd) Returns the filter coefficients of object Hm in the
%   structure S.  The structure will have fields matching the property
%   names in the object Hm.
%
%   If Hm is a multistage object (cascade), the returned structure will
%   contain fields for each of the stages of the multistage filter.
%
%   % EXAMPLE:
%   f  = fdesign.decimator(8,'lowpass',.1,.12,1,80);
%   Hm = design(f,'multistage');
%   c  = coeffs(Hm)

%   Copyright 2006 The MathWorks, Inc.

% Help for the DFILT method COEFFS.

% [EOF]

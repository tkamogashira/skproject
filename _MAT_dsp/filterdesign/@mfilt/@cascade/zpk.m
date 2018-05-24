function [z,p,k] = zpk(Hm)
%ZPK   Multirate filter zero-pole-gain conversion.
%   [Z,P,K] = ZP(Hd) returns the zeros, poles, and gain corresponding to the
%   discrete-time filter Hd in vectors Z, P, and scalar K respectively.
%
%   See also MFILT/TF, MFILT/IMPZ.   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

Hd = dispatch(Hm);
[z,p,k] = zpk(Hd);


% [EOF]

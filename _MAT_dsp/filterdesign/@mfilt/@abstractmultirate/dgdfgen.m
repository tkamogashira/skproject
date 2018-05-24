function DGDF = dgdfgen(Hd,hTar,doMapCoeffsToPorts)
%DGDFGEN generate the dg_dfilt structure from a specified filter structure
%Hd.

%   Author(s): Honglei Chen
%   Copyright 1988-2011 The MathWorks, Inc.


error(message('dsp:mfilt:abstractmultirate:dgdfgen:Notsupported', Hd.FilterStructure));

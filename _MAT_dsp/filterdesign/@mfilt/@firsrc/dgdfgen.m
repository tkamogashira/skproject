function DGDF = dgdfgen(Hd,hTar,doMapCoeffsToPorts)
%DGDFGEN Generate the dg_dfilt structure from a specified filter structure
%Hd.


%   Copyright 2007 The MathWorks, Inc.


DGDF=firsrcdggen(Hd.filterquantizer,Hd,hTar.coeffnames,doMapCoeffsToPorts,hTar.privStates);

% EOF
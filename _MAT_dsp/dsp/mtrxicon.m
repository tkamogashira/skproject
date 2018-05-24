function [x,y] = mtrxicon(side,v,orient,method)
% MTRXICON  Matrix Icon function for SIMULINK Matrix blocks.
%       Matrices no longer have port identifiers; thus, we
%       simply return a pair of NaN's.  For backwards compatibility
%       only.

%	Copyright 1995-2002 The MathWorks, Inc.

x=NaN; y=NaN;

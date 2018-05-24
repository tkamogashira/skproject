function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% This method is required because it is called from ziscalarexpand in the
% setstates of ...@dfilt/@abstractfilter/schema.m

Snum = fi(0,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.NumStateFracLength);
Sden = fi(0,'Signed',true,'WordLength',q.StateWordLength,...
    'FractionLength',q.DenStateFracLength);

S = filtstates.dfiir(Snum,Sden);

% [EOF]

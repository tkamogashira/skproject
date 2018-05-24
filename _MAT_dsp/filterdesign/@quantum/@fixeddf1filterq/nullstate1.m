function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

% This method is required because it is called from ziscalarexpand in the
% setstates of ...@dfilt/@abstractfilter/schema.m

Snum = fi(0,'Signed',true,'WordLength',q.InputWordLength,...
    'FractionLength',q.InputFracLength);
Sden = fi(0,'Signed',true,'WordLength',q.OutputWordLength,...
    'FractionLength',q.OutputFracLength);

S = filtstates.dfiir(Snum,Sden);

% [EOF]

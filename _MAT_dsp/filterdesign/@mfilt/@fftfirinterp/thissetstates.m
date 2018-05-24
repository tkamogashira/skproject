function S = thissetstates(Hm,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

Hm.hiddenstates = S;

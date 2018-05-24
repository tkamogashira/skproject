function s = designopts(this)
%DESIGNOPTS Structure of design options

%   Copyright 2005-2011 The MathWorks, Inc.

addsysobjdesignopt(this);

s = get(this);

s = rmfield(s, {'DesignAlgorithm','FilterStructure'});

% [EOF]

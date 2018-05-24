function h = ellipalpfstop
%ELLIPALPFSTOP   Construct an ELLIPALPFSTOP object.

%   Author(s): R. Losada
%   Copyright 1999-2006 The MathWorks, Inc.

h = fdfmethod.ellipalpfstop;

set(h,'DesignAlgorithm','Elliptic');

% [EOF]

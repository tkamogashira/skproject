function [p, v] = info(this)
%INFO   Return the information for the display.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:Input')), ...
     getString(message('signal:dfilt:info:Output'))};

v = {sprintf('S%dQ%d', this.InputWordLength, this.InputFracLength), ...
    sprintf('S%dQ%d', this.OutputWordLength, this.OutputFracLength)};

% [EOF]

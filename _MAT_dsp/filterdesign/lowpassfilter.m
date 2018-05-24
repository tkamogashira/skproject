function h = lowpass
%LOWPASS   Design a lowpass filter.

%   Author(s): J. Schickler
%   Copyright 2005-2006 The MathWorks, Inc.

% Call the gateway graphicaldesign function and tell it the name of the
% designer that it should use.
h = designdialog('FilterDesignDialog.LowpassDesign');

% [EOF]

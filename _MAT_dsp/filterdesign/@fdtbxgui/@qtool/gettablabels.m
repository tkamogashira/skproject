function tablabels = gettablabels(this)
%GETTABLABELS   Returns the labels for the tabs.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

tablabels = {getString(message('dsp:fdtbxgui:fdtbxgui:Coefficients')), ...
             getString(message('dsp:fdtbxgui:fdtbxgui:InputOutput')), ...
             getString(message('dsp:fdtbxgui:fdtbxgui:FilterInternals'))};

% [EOF]

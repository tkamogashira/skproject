function fdahoststruct = fdaregisterhost
%FDAREGISTERHOST Registers the DSP System Toolbox as the Host of an FDATool session.
%   STRUCT = FDAREGISTERHOST Returns the proper FDATool host structure to 
%   register the DSP System Toolbox as the Host of FDATool.

%   Copyright 1995-2010 The MathWorks, Inc.

fdahoststruct.name = 'DSP System Toolbox';
fdahoststruct.version = 1.0;

% SUBTITLE is used later when we have the name to the block.
fdahoststruct.subtitle = '';
fdahoststruct.figtitle = 'Block Parameters:';

% [EOF]

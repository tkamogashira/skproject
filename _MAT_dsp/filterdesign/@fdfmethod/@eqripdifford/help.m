function help(this)
%HELP   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

help_equiripple(this);
help_densityfactor(this);
disp(sprintf('%s', ...
    sprintf('    Notice that the filter order must be odd.')));
disp(' ');
help_uniformgrid(this);
help_examples(this);

% [EOF]

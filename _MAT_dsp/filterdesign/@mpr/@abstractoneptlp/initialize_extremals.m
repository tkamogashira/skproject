function initialize_extremals(this)
%INITIALIZE_EXTREMALS   

%   Author(s): R. Losada
%   Copyright 1999-2005 The MathWorks, Inc.

M = this.M;

% Initialize extremals, they must be on the grid
fgrid = this.fgrid;

Lgrid = length(fgrid);

mextidx = round(linspace(2,max(2,Lgrid-floor((Lgrid-1)/M)),M));

this.fext = [0,fgrid(mextidx),fgrid(end)];



% [EOF]

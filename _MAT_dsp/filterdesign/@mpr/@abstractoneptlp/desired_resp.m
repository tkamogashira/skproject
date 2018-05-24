function desired_resp(this)
%DESIRED_RESP   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Determine desired function at extremals
this.Aext = [1, zeros(1,length(this.fext)-1)];

% Determine desired response on grid
this.Agrid = [1, zeros(1,length(this.fgrid)-1)];


% [EOF]

function weights_at_ext(this)
%WEIGHTS_AT_EXT   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Determine weights at extremals
this.Wext = this.Wgrid(ismember(this.fgrid,this.fext));


% [EOF]

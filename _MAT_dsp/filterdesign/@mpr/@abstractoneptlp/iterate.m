function iterate(this)
%ITERATE   Perform one iteration of the MPR algorithm

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
fext = this.fext;
Wext = this.Wext;
Agrid = this.Agrid;
Aext = this.Aext;
fgrid = this.fgrid;
Wgrid = this.Wgrid;

% Compute error analytically
compute_err(this);

% Evaluate approximating polynomial at grid points
Ggrid = evalapprox(this,fgrid); % Need to pass grid as input

errgrid = Wgrid.*(Agrid - Ggrid); 

% Find new M extremals (keep the edges)
[new_ext,newidx] = extremals(this,fgrid,errgrid);

% Update the mag of the error
this.measurederr = norm(errgrid,inf);

if (length(new_ext) > length(fext)),
    % Number of extremals increased, reject superfluous extremals    
    new_ext = reject_ext(this,new_ext,newidx);
end

% Compute polynomial at new extremals
Gext = evalapprox(this,new_ext); % Takes a different grid as input

% Set extremals to new extremals
this.fext = new_ext;

% Determine weights at extremals
weights_at_ext(this);

% Compute error at extremals
errext = this.Wext.*(Aext-Gext);

this.errgrid = errgrid;
this.errext = errext;
this.Ggrid = Ggrid;
this.Gext = Gext;
this.Aext = Aext;

this.iter = this.iter+1;


% [EOF]

function init(this,Fst,wstruct)
%INIT   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;

% Setup search grid
dF = this.DensityFactor; % Use either factory or specified value
dens = dF*(M+2); % grid density

this.fgrid = [0,linspace(Fst,1,dens)];

% Initialize guess for extremals
initialize_extremals(this);

% Determined desired response at extremals and on entire grid
desired_resp(this);

% Determine weights on entire grid
determine_weights(this,wstruct);

% Determine weights at extremals
weights_at_ext(this);

% Initialize value of approx polynomial on grid
this.Ggrid = zeros(size(this.Agrid));

% Initialize value of approx polynomial at extremals
this.Gext = zeros(size(this.Aext));

% Initialize error on grid
this.errgrid = this.Agrid;

% Initialize error at extremals
this.errext = this.Aext;


% [EOF]

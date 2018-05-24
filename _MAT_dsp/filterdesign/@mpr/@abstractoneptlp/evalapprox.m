function Ggrid = evalapprox(this,grid)
%EVALAPPROX   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
Aext = this.Aext;
Wext = this.Wext;
err = this.analyticerr;

% Determine Ck, the value the approx poly takes at the extremals
k = 1:M+1;
sgn = (-1).^k;
Ck = Aext(1:end-1) + sgn*err./Wext(1:end-1);

% Evaluate the approximating polynomial at all grid points by using the
% Lagrange interpolation formula in barycentric form

%Ggrid = barycentriclagrange(this,Ck,grid); % The barycentric form was used in the original MPR
Ggrid = modifiedlagrange(this,Ck,grid); % try this alternative; it's faster and seems to produce better results

% [EOF]

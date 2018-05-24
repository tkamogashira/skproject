function Ggrid= modifiedlagrange(this,Ck,grid)
%MODIFIEDLAGRANGE   Implements the modified lagrange interpolation formula
%   For a reference see: www.maths.man.ac.uk/~nareports/narep440.pdf
%   or IMA Journal of Numerical Analysis (2004) 24, 547 556 The numerical
%   stability of barycentric Lagrange interpolation.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
fext = this.fext(1:end-1); % Notice last point not used

beta = lagrangecoeff(this,M+1,fext);

% 
Ggrid = zeros(size(grid));
for n = 1:length(grid),
    Gext = Ck(grid(n)==fext);
    if isempty(Gext),
        ssum = sum(Ck.*beta./(cos(grid(n)*pi)-cos(fext*pi)));
        % If grid(n) is very close to an element of fext, ssum may become
        % infinite. Use Ck in this case
        if isinf(ssum),
            [m,i] = min(abs(grid(n)-fext));
            Ggrid(n) = Ck(i);
        else
            lx = prod(cos(grid(n)*pi)-cos(fext*pi));
            Ggrid(n) = lx.*ssum;
        end
    else
        Ggrid(n) = Gext;
    end
end



% [EOF]

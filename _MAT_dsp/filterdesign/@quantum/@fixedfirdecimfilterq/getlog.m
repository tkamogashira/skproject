function [prodlog,outlog,acclog] = getlog(this,b,y,acc,x,phaseidx)
%GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

[prodlog,outlog,acclog] = super_getlog(this,b,y,acc);

% Number of Operations
[npoly,M] = size(b);
[nx,nchan] = size(x);

if phaseidx==0,
    ni = 1; % Number of input samples that produce the first output
else
    ni = M-phaseidx+1; 
end
nf = rem(nx-ni,M); % Partially processed input samples

nprodini = ni*npoly*nchan;              % Initial number of multiplications
if phaseidx==0, 
    naccini = nprodini;
else
    naccini = max(nprodini-nchan,0);
end

nprodsteady = npoly*((nx-ni-nf)*nchan); % Steady State
naccsteady = max(nprodsteady-((nx-ni-nf)/M*nchan),0);

nprodfin = nf*npoly*nchan;              % Partially processed input samples
naccfin = max(nprodfin-nchan,0);

outlog.NOperations = prod(size(y));
prodlog.NOperations = nprodini+nprodsteady+nprodfin;
acclog.NOperations = naccini+naccsteady+naccfin;

% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
elseif ~isreal(b) && ~isreal(x),
    prodlog.NOperations = 4*prodlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations + 2*prodlog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]

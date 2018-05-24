function [prodlog,outlog,acclog,statelog,polyacclog] = getlog(this,b,y,acc,z,polyacc,x,phaseidx)
%GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

prodlog = get(getqloggerstruct(b,2));
prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));

if isempty(z),
    acclog  = get(getqloggerstruct(acc,0)); 
else,
    acclog  = get(getqloggerstruct(z,1)); 
end
acclog.Range = double(range(acc));

statelog  = get(getqloggerstruct(z,0));
statelog.Range = double(range(z));

polyacclog  = get(getqloggerstruct(polyacc,0));
polyacclog.Range = double(range(polyacc));

% Number of Operations
[M,npoly] = size(b);
[nx,nchan] = size(x);

if phaseidx==0,
    ni = 1; % Number of input samples that produce the first output
else
    ni = M-phaseidx+1; 
end
nf = rem(nx-ni,M); % Partially processed input samples

nprodini = ni*npoly*nchan;              % Initial number of multiplications
if phaseidx==M-1, 
    npolyaccini = max(nprodini-npoly*nchan,0);
else
    npolyaccini = nprodini;
end
naccini = (npoly-1)*nchan;

nprodsteady = npoly*((nx-ni-nf)*nchan); % Steady State
npolyaccsteady = max(nprodsteady-((nx-ni-nf)/M*npoly*nchan),0);
naccsteady = (npoly-1)*(nx-ni-nf)/M*nchan;

nprodfin = nf*npoly*nchan;              % Partially processed input samples
npolyaccfin = max(nprodfin-npoly*nchan,0);
naccfin = 0;

outlog.NOperations = prod(size(y));
prodlog.NOperations = nprodini+nprodsteady+nprodfin;
polyacclog.NOperations = npolyaccini+npolyaccsteady+npolyaccfin;
acclog.NOperations = naccini+naccsteady+naccfin;

if isempty(z),
    acclog.NOperations = nchan;
end
    
% Complex cases
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
    acclog.NOperations = 2*acclog.NOperations;
end
if (isreal(b) && ~isreal(x)) || (isreal(x) && ~isreal(b)),
    prodlog.NOperations = 2*prodlog.NOperations;
    polyacclog.NOperations = 2*polyacclog.NOperations;    
elseif ~isreal(b) && ~isreal(x),
    polyacclog.NOperations = 2*polyacclog.NOperations + 2*prodlog.NOperations;
    prodlog.NOperations = 4*prodlog.NOperations;
    
end
if npoly<=M,
    statelog.NOperations = 0;
else
    statelog.NOperations = acclog.NOperations;
end

% Cap the number of overflows in acc to 100% (necessary because we don't
% count the initialization of the acc when determining the number of
% operations)
acclog.NOverflows = min(acclog.NOverflows,acclog.NOperations);

% [EOF]

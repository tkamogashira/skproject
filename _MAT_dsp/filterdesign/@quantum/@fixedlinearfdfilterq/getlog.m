function [prodlog,outlog,acclog,tapsumlog] = getlog(this,d,y,x,zlog)
%GETLOG   Get the log.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

prodlog = get(getqloggerstruct(d,0));
prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));

acclog  = get(getqloggerstruct(x,0));
acclog.Range = double(range(quantizer(...
    [this.fimath.SumWordLength this.fimath.SumFractionLength])));

tapsumlog  = get(getqloggerstruct(zlog,0));
tapsumlog.Range = double(range(quantizer(...
    [this.fdfimath.SumWordLength this.fdfimath.SumFractionLength])));

% Number of Operations
outlog.NOperations = prod(size(y));
if ~isreal(y),
    outlog.NOperations = 2*outlog.NOperations;
end
prodlog.NOperations = outlog.NOperations;
acclog.NOperations = outlog.NOperations;
tapsumlog.NOperations = outlog.NOperations;

% [EOF]

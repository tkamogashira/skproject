function [prodlog,outlog,acclog] = super_getlog(this,b,y,acc)
%SUPER_GETLOG   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

prodlog = get(getqloggerstruct(b,2));
prodlog.Range = double(range(quantizer(...
    [this.fimath.ProductWordLength this.fimath.ProductFractionLength])));

outlog  = get(getqloggerstruct(y,0)); 
outlog.Range = double(range(y));

acclog  = get(getqloggerstruct(acc,0)); 
acclog.Range = double(range(acc));


% [EOF]

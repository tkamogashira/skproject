function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
updateinternalsettings(this);

prodfl = getautoscalefl(this,s.Product,true,this.ProductWordLength);
fpprodfl = this.TapSumFracLength+this.FDFracLength;
if prodfl>fpprodfl,
    prodfl = fpprodfl;
end
    
accumfl = getautoscalefl(this,s.Accumulator,true,this.AccumWordLength);
if (accumfl>prodfl),
    accumfl = prodfl;
end

outfl = getautoscalefl(this,s.Output,true,this.OutputWordLength);
if (this.OutputWordLength>=this.AccumWordLength) && outfl>accumfl,
    outfl = accumfl;
end
this.OutputFracLength = outfl;


if binptaligned,
    fl = min(prodfl,accumfl);
    this.ProductFracLength = fl;
    this.AccumFracLength = fl;
else
    this.ProductFracLength = prodfl;
    this.AccumFracLength = accumfl;
end


this.loggingreport = [];

% [EOF]
